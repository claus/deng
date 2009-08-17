/*
DENG Modular XBrowser
Copyright (C) 2002-2004 Mozquito

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

// ===========================================================================================
//   class DENG.CWnd
// ===========================================================================================

DENG.CSS_BLOCKELEMENT_DISPLAY_MATCH_ARR = { block: true, table: true, runin: true, marker: true };
DENG.CSS_BLOCKELEMENT_DISPLAY_MATCH_ARR["list-item"] = true;
DENG.CSS_BLOCKELEMENT_DISPLAY_MATCH_ARR["table-cell"] = true;

DENG.CWnd = function()
{
}

DENG.CWnd.prototype.initialize = function(node, parent)
{
	// initialize some references
	// (to root, parent and siblings)
	if(parent != undefined) {
		this.parentNode = parent;
		this.rootNode = parent.rootNode;
	} else {
		this.parentNode = null;
		this.rootNode = this;
	}
	this.nextSibling = null;
	var _ps = node.previousSibling;
	if(_ps) {
		_ps.obj.nextSibling = this;
		this.previousSibling = _ps.obj;
	} else {
		this.previousSibling = null;
	}
	this.childNodes = [];
	// reference to xmldom
	this.xmlDomRef = node._xmlDomCallback;
	// reference to corresponding xmlnode object
	this.node = node;
	// create css object for this element
	this.css = new DENG.CCss(this);
	// initialize calculated values object
	this.cssPropCalculated = {};
	// initialize pseudo class hooks
	this.cssActivePseudoClasses = {};
	// if we're root, initialize css property definitions
	if(!this.parentNode) {
		this.css.dom.propertyDefs.init(true);
		// root always is a block element
		this.cssPropCalculated.display = "block";
		this.css.dom.propertyTableAttr.overflow = "scroll";
	}
	this.initCSSAttr();
	this.initStyleAttr();
}

DENG.CWnd.prototype.initCSSAttr = function()
{
	if(this.cssPropAttr != undefined) {
		var _att = this.node.attributes;
		var _pia = this.rootNode.css.dom.propertyDefs.propInitial;
		for(var _i in _att) {
			var _pname = _i.split("-").join("");
			if(this.cssPropAttr[_pname] || _pia[_pname] != undefined) {
				this.xmlDomRef.cssParseQueue.push({ type: 3, name: _pname, value: _att[_i], obj: this });
			}
		}
	}
}

DENG.CWnd.prototype.initStyleAttr = function()
{
	// if the style attribute is set (inline styles)
	if(this.node.attributes.style != undefined) {
		// add inline styles to queue
		this.xmlDomRef.cssParseQueue.push({ type: 2, css: this.node.attributes.style, obj: this });
	}
}


DENG.CWnd.prototype.create = function()
{
	var d;
	var p;

	//mytrace(this.toString(), "CWnd", "create");

	// resolve pseudoclasses/-elements
	if(this.cssPseudoClass == undefined) {
		this.pseudo = this.rootNode.css.resolvePseudos(this);
	}

	if(this.parentNode.$noRendering || (d = this.resolveCssProperty("display")) == "none") {
		this.$noRendering = true;
		this.size = null;
		this.position = null;
		this.paint = null;
		//mytrace(this.toString() + " [display:none]", "CWnd", "create");
		return;
	}
	//mytrace(this.toString() + " [display:" + d + "]", "CWnd", "create");

	// create counters
	var _counterReset = this.resolveCssProperty("counterreset");
	if(_counterReset != "none") {
		if(typeof _counterReset != "object") {
			_counterReset = [{ type:201, value:_counterReset }];
		}
		var _crl = _counterReset.length;
		var _counters = this.xmlDomRef.counters;
		for(var i = 0; i < _crl; i++) {
			var _cName = _counterReset[i].value;
			var _cValue = 0;
			if(_counters[_cName] == undefined) {
				_counters[_cName] = [];
			}
			if(_counterReset[i+1] != undefined && _counterReset[i+1].type != 201) {
				_cValue = _counterReset[++i].value;
			}
			_counters[_cName].push(_cValue);
			// register created counter
			// to clean up the counter again, after creating this wrapper
			if(this.createdCounters == undefined) { 
				this.createdCounters = [_cName];
			} else {
				this.createdCounters.push(_cName);
			}
		}
	}
	// increment counters
	var _counterIncrement = this.resolveCssProperty("counterincrement");
	if(_counterIncrement != "none") {
		if(typeof _counterIncrement != "object") {
			_counterIncrement = [{ type:201, value:_counterIncrement }];
		}
		var _cil = _counterIncrement.length;
		var _counters = this.xmlDomRef.counters;
		for(var i = 0; i < _cil; i++) {
			var _cName = _counterIncrement[i].value;
			var _cIncr = 1;
			if(_counterIncrement[i+1] != undefined && _counterIncrement[i+1].type != 201) {
				_cIncr  = _counterIncrement[++i].value;
			}
			if(_counters[_cName] != undefined) {
				// increment counter
				_counters[_cName][_counters[_cName].length-1] += _cIncr;
			} else {
				// create counter, and increment it
				_counters[_cName] = [ _cIncr ];
				// register created counter
				// to clean up the counter again, after creating this wrapper
				if(this.rootNode.createdCounters == undefined) { 
					this.rootNode.createdCounters = [_cName];
				} else {
					this.rootNode.createdCounters.push(_cName);
				}
			}
		}
	}
	
	// flow positioning
	this.relPositioning = true;
	
	// css 2.1, 9.7 (p.120, visual formatting model)
	// relationships between display, position and float
	p = this.resolveCssProperty("position");
	if(p == "absolute" || p == "fixed" || this.resolveCssProperty("float") != "none") {
		if(p == "absolute" || p == "fixed") {
			// absolute positioning
			this.relPositioning = false;
			this.cssPropCalculated.float = "none";
		}
		switch(d) {
			case "inline-table":
				this.cssPropCalculated.display = d = "table";
				break;
			case "block":
			case "list-item":
			case "table":
				break;
			default:
				// inline, run-in, table-row-group, table-column,
				// table-column-group, table-header-group, table-footer-group,
				// table-row, table-cell, table-caption, inline-block
				this.cssPropCalculated.display = d = "block";
				break;
		}
	}

	// are we dealing with a block level element?
	this.isBlockElement = (DENG.CSS_BLOCKELEMENT_DISPLAY_MATCH_ARR[d] == true);
	this.isMarker = (d == "marker");

	// get object/mc of element's containing block 
	var cbr = this.getContainingBlock();
	this.cbt = cbr[0];
	this.cbObj = cbr[1];
	this.cbMC = cbr[2];
	
	if(this.isBlockElement) {
		// create mc
		this.mc = this.cbMC.createEmptyMovieClipExt();
		this.mc.classRef = this; // callback to this object
		//mytrace(this.mc, "CWnd");

		// do we need to mask the content?
		this.$cssOverflow = this.resolveCssProperty("overflow");
		if(this.$cssOverflow == "auto" || this.$cssOverflow == "scroll" || this.$cssOverflow == "hidden") {
			// create mask mc
			this.mcContent = this.mc.createEmptyMovieClipExt("_CONTENT_");
			this.mcMask = this.mc.createEmptyMovieClipExt("_MASK_");
			this.mcContent.classRef = this; // callback to this object
			this.mcContent.setMask(this.mcMask);
			if(this.$cssOverflow != "hidden") {
				// create scrollbars
				// (this is subject to change yet)
				this.mcScrollerTop = this.mc.createEmptyMovieClipExt("_SCROLLUP_");
				this.mcScrollerBottom = this.mc.createEmptyMovieClipExt("_SCROLLDOWN_");
				this.mcScrollerTop.classRef = this.mcScrollerBottom.classRef = this;
				this.$hscrollOffset = 0;
			}
		} else {
			this.mcContent = this.mc;
		}

		this.$tfCreate = true; // a textfield has to be created yet

		var _li = this.resolveCssProperty("link");
		if(_li != "none") {
			// link is defined
			var _href;
			if(typeof _li == "string") {
				_href = _li;
			} else {
				var _li0 = _li[0];
				if(_li0.type == 100) {
					if(_li0.value == "attr") {
						_href = this.node.attributes[_li0.expr[0].value];
						// todo: namespaced elements?
					} else if(_li0.value == "content") {
						_href = this.node.firstChild.nodeValue;
						// todo: support elements that contain childnodes
					}
				}
			}
			if(_href != undefined) {
				// register the click handler on the containing block element's wrapper
				var _clhID = this.registerClickHandler(
					{
						obj: this,
						uri: new DENG.CUri(_href, this.getBaseUrl()).getAbsolute(),
						targetStyle: this.resolveCssProperty("targetstyle"),
						targetPosition: this.resolveCssProperty("targetposition"),
						targetName: this.resolveCssProperty("targetname")
					}
				);
				this.clickHandlerID = _clhID;
				
				// set mouse handlers
				this.mc.createEmptyMovieClip("_HITAREA_", 6000);
				var _mc = this.mc._HITAREA_;
				_mc.classRef = this;
				_mc.onRollOver = function() { this.classRef.privateOnRollOver(); }
				_mc.onRollOut = function() { this.classRef.privateOnRollOut(); }
				_mc.onPress = function() { this.classRef.privateOnPress(); }
				_mc.onRelease = function() { this.classRef.privateOnRelease(); }
				_mc.onReleaseOutside = function() { this.classRef.privateOnReleaseOutside(); }
				_mc.onDragOver = function() { this.classRef.privateOnDragOver(); }
				_mc.onDragOut = function() { this.classRef.privateOnDragOut(); }
			}
		}
	}

	switch(d)
	{
		case "block":
			if(this.parentNode && this.relPositioning) {
				// tell this element's parent block element to create 
				// a new textfield for following inline elements
				// (as we are a block element we break the inline chain)
				this.cbObj.$tfCreate = true;
			}
			break;

		case "table":
			// create a table wrapper, taking care of table sizing etc
			new DENG.CTableWrapper().insertAfter(this, this.node);
			break;

		case "list-item":
			if(!this.cssActivePseudoClasses.before) {
				var _pc = new DENG.CElemPseudoBefore();
				_pc.regChildnode(this, this.node, 0);
				var _pta = _pc.css.dom.propertyTableAttr;
				switch (this.resolveCssProperty("liststyletype")) {
					case "disc":
						_pta.content = [{type:200, value:"•"}];
						break;
					case "decimal":
						_pta.content = [{type:100, value:"counter", operator:1, expr:[{type:201,value:"$licounter$"}]},{type:200, value:"."}];
						break;
					/* TODO:
					case "square":
					case "circle":
					...
					*/
				}
				_pta.display = "marker";
				_pta.counterincrement = [{type:201, value:"$licounter$"}];
				var _pca = _pc.cssPropCalculated;
				_pca.margintop = _pca.marginright = _pca.marginbottom = _pca.marginleft = 0;
			}
			break;
	}
	
	// create children
	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.create();
		}
		while(_cno = _cno.nextSibling);
	}
	
	// reset created counters
	if(this.createdCounters != undefined) { 
		for(var i in this.createdCounters) {
			var _cName = this.createdCounters[i];
			var _ca = this.xmlDomRef.counters[_cName];
			_ca.pop();
			if(!_ca.length) {
				delete this.xmlDomRef.counters[_cName];
			}
		}
		delete this.createdCounters;
	}
}



DENG.CWnd.prototype.size = function()
{
	with(this) {
		var _td = (this.cssPropCalculated.display == "table-cell");
		var _tr = (this.cssPropCalculated.display == "table-row");
		if(this.isBlockElement) {
			// position the mc
			if(_td) {
				this.cbX = cbObj.calcContentX;
				this.cbY = cbObj.calcContentY;
				this.cbWidth = parentNode.parentNode.columns[this.$tdIdx].w;
				this.cbHeight = cbObj.calcContentHeight;
			} else {
				switch(this.cbt) {
					case 0:
						// anchestor's content edge
						this.cbX = cbObj.calcContentX;
						this.cbY = cbObj.calcContentY;
						this.cbWidth = cbObj.calcContentWidth;
						break;
					case 1:
						// initial containing block
						var cb = this.getInitialContainingBlock();
						this.cbX = cb.x;
						this.cbY = cb.y;
						this.cbWidth = cb.width;
						this.cbHeight = cb.height;
						break;
					case 2:
						// viewport
						var cb = this.getInitialContainingBlock();
						this.cbX = cb.x;
						this.cbY = cb.y;
						this.cbWidth = cb.width;
						this.cbHeight = cb.height;
						break;
					case 3:
						// anchestor's padding edge
						this.cbX = cbObj.calcPaddingX;
						this.cbY = cbObj.calcPaddingY;
						this.cbWidth = cbObj.calcContentWidth - this.resolveCssPropertyPercentage("paddingleft", cbObj.calcContentWidth) - this.resolveCssPropertyPercentage("paddingright", cbObj.calcContentWidth);
						break;
				}
			}

			// retrieve css border properties
			// this method will create an object "this.$cssBorder"
			//   containing the objects 
			//   t (top)
			//   r (right)
			//   b (bottom)
			//   l (left)
			//     each with member variables
			//     w (width)
			//     s (style)
			//     c (color)
			// example:
			// this.$cssBorder.b.s retrieves the style of the bottom border edge
			// we store those properties in an object because of performance reasons
			this.getBorderCssProperties();

			// calculate x/y coordinates of contained blocks
			this.calcPaddingX = this.resolveCssPropertyPercentage("marginleft", cbObj.calcContentWidth) + $cssBorder.l.w;
			this.calcPaddingY = this.resolveCssPropertyPercentage("margintop", cbObj.calcContentHeight) + $cssBorder.t.w;
			this.calcContentX = calcPaddingX + this.resolveCssPropertyPercentage("paddingleft", cbObj.calcContentWidth);
			this.calcContentY = calcPaddingY + this.resolveCssPropertyPercentage("paddingtop", cbObj.calcContentHeight);
		} else {
			this.calcContentX = this.calcContentY = this.calcPaddingX = this.calcPaddingY = 0;
			this.cbWidth = cbObj.cbWidth;
			this.cbX = 0;
			this.cbY = 0;
		}
		// initialize flowOffset
		this.flowOffset = 0;
		// get the element's content width
		// eventually adjusts right and left properties
		var _calc = this.getCalculatedWidthHeight();
		this.calcContentWidth = _calc.width;
		this.calcContentHeight = _calc.height;
	}
	
	// size children
	var _cno = this.childNodes[0];
	if(_tr) {
		var _tdIdx = 0;
		if(_cno) {
			do {
				// this is a tr, so set the index of the td
				// todo: take col/rowspans into account
				_cno.$tdIdx = _tdIdx++;
				_cno.size();
			}
			while(_cno = _cno.nextSibling);
		}
	} else {
		if(_cno) {
			do {
				_cno.size();
			}
			while(_cno = _cno.nextSibling);
		}
	}
}



DENG.CWnd.prototype.position = function()
{
	with(this) {
		var x = 0, y = 0;
		var _td = (this.cssPropCalculated.display == "table-cell");
		var _tr = (this.cssPropCalculated.display == "table-row");

		if(isBlockElement) {
			// set initial contentHeight (top margin/border/padding)
			this.contentHeight = this.resolveCssPropertyPercentage("margintop", cbObj.calcContentHeight) 
									 + this.resolveCssPropertyPercentage("paddingtop", cbObj.calcContentHeight)
									 + $cssBorder.t.w;
			// calculate movieclip positions
			if(parentNode) {
				y = cbObj.calcContentY + cbObj.flowOffset;
				x = (_td) ? cbObj.calcContentX + parentNode.parentNode.columns[this.$tdIdx].x : cbObj.calcContentX;
			}
		} else {
			this.contentHeight = 0;
		}

		// position children
		var _cno = this.childNodes[0];
		if(_cno) {
			do {
				// add children's contentHeight
				var _ch = _cno.position();
				this.contentHeight += (_tr) ? 0 : _ch;
			}
			while(_cno = _cno.nextSibling);
		}

		if(isBlockElement)
		{
			// add bottom margin/border/padding
			this.contentHeight += this.resolveCssPropertyPercentage("marginbottom", cbObj.calcContentHeight)
									  + this.resolveCssPropertyPercentage("paddingbottom", cbObj.calcContentHeight)
									  + $cssBorder.b.w;
			// update the containing-block wrapper's flowOffset
			if(_td) {
				if(parentNode.flowOffsetMax == "undefined") {
					parentNode.flowOffsetMax = contentHeight;
				} else {
					if(parentNode.flowOffsetMax < contentHeight) {
						parentNode.flowOffsetMax = contentHeight;
					}
				}
			} else {
				cbObj.flowOffset += contentHeight;
			}
			
			// at this point, 
			// contentHeight is the total height of this element
			// calcContentHeight is either undefined or the specified height for this element
			//trace("<" + node.nodeName + "> " + contentHeight + " " + calcContentHeight);
			
			// position main movieclip
			mc._x = x;
			mc._y = y;

			if(mcMask) {
				// adjust scolloffset in case it got out of bounds during resize
				// (ie the elements content is all scrolled down, and the containig block gets 
				//  bigger => scolloffset must be reduced to fit bottom edge of containing block)
				if(contentHeight - $hscrollOffset < calcContentHeight) {
					$hscrollOffset = contentHeight - calcContentHeight + 1;
					if($hscrollOffset < 0) {
						$hscrollOffset = 0;
					}
				}
				// set position of content
				mcContent._y = -$hscrollOffset;
			}
		}
		else if(_tr)
		{
			// we are a <tr> (thus no blockelement):
			// add maximum height of children <td>s to contentHeight
			this.contentHeight += flowOffsetMax;
			// update the parent <table>s flowOffset
			cbObj.flowOffset += contentHeight;
			// adjust height of children
			_cno = this.childNodes[0];
			if(_cno) {
				do {
					// add children's contentHeight
					_cno.calcContentHeight = _cno.$height = contentHeight;
				}
				while(_cno = _cno.nextSibling);
			}
			delete this.flowOffsetMax;
			// position main movieclip
			mc._x = x;
			mc._y = y;
		} 

		// evaluate "real" height
		// and eventually adjust flowoffset
		this.$height = contentHeight;
		if(calcContentHeight) {
			this.$height = calcContentHeight;
			cbObj.flowOffset += $height - contentHeight;
		}
		
		/*
		if(!parentNode) {
			trace(
				"root element:\n" +
				"  this.mc._x: " + mc._x + "\n" +
				"  this.mc._y: " + mc._y + "\n" +
				"  this.$height: " + $height + "\n" +
				"  this.contentHeight: " + contentHeight + "\n" +
				"  this.calcContentHeight: " + calcContentHeight + "\n"
			);
		}
		*/
		
		return (!isBlockElement || relPositioning) && !isMarker ? $height : 0;
	}
}



DENG.CWnd.prototype.paint = function()
{
	with(this) {
		if(isBlockElement) {
			// get width/height
			var w = cbWidth;
			var h = this.$height;
			// get margins
			var mt = this.resolveCssPropertyPercentage("margintop", cbObj.calcContentHeight);
			var mr = this.resolveCssPropertyPercentage("marginright", cbObj.calcContentWidth);
			var mb = this.resolveCssPropertyPercentage("marginbottom", cbObj.calcContentHeight);
			var ml = this.resolveCssPropertyPercentage("marginleft", cbObj.calcContentWidth);
			//if(!relPositioning) {
				//pr += this.resolveCssProperty("right");
			//}
			
			var _bgc = this.resolveCssPropertyColor("backgroundcolor");
			var _bgo = this.resolveCssPropertyColor("backgroundopacity") * 100;
			if(_bgo < 0) { _bgo = 0; }
			else if(_bgo > 100) { _bgo = 100; }

			// todo
			// - paintFrame method
			// - top/right/bottom/left properties
			
			// paint border/background
			this.mc.paintFrame2($cssBorder, _bgc, _bgo, ml, mt, w-ml-mr, h-mt-mb);
			
			if(this.mc._HITAREA_)
			{
				with(this.mc._HITAREA_) {
					clear();
					lineStyle();
					beginFill(0xffffff, 0);
					moveTo(_ml, _mt);
					lineTo(w-_mr, _mt);
					lineTo(w-_mr, h-_mb);
					lineTo(_ml, h-_mb);
					endFill();
				}
			}
			
			// paint mask
			// covers padding and content
			if(mcMask)
			{
				// get padding edges
				var _pt = mt + $cssBorder.t.w;
				var _pr = mr + $cssBorder.r.w;
				var _pb = mb + $cssBorder.b.w;
				var _pl = ml + $cssBorder.l.w;
				
				with(mcMask) {
					clear();
					lineStyle();
					beginFill(0xff0000, 100);
					moveTo(_pl, _pt);
					lineTo(w-_pr, _pt);
					lineTo(w-_pr, h-_pb);
					lineTo(_pl, h-_pb);
					endFill();
				}
			
				// paint scrollers
				// (subject to change!)
				this.updateScrollers();
				if(mcScrollerTop) {
					if(contentHeight > calcContentHeight)
					{
						mcScrollerTop.clear();
						mcScrollerTop.paintFrame("outset", 2, 0xffffff, 0xcccccc, _pl, _pt, w-_pl-_pr, 14);
						mcScrollerTop.$scrollDelta = Math.round((contentHeight - calcContentHeight) / 30) + 5;
						
						var _xm = Math.round((w-_pl-_pr) / 2) + _pl;
						mcScrollerTop.lineStyle();
						mcScrollerTop.beginFill(0x333333, 100);
						mcScrollerTop.moveTo(_xm, _pt+4);
						mcScrollerTop.lineTo(_xm+4, _pt+9);
						mcScrollerTop.lineTo(_xm-4, _pt+9);
						mcScrollerTop.endFill();

						mcScrollerBottom.onMouseMove = function() {
							this.classRef.updateScrollers();
						}

						mcScrollerTop.onMouseDown = function() {
							if(this.classRef.$hoverTop) {
								this.onEnterFrame = function() {
									var _hso = this.classRef.$hscrollOffset;
									var _hsod = 0;
									if(_hso - this.$scrollDelta >= 0) {
										_hsod = -this.$scrollDelta;
									} else {
										_hsod = -_hso;
									}
									this.classRef.$hscrollOffset += _hsod;
									this.classRef.mcContent._y -= _hsod;
									this.classRef.updateScrollers();
								}
							}
						}
						mcScrollerTop.onMouseUp = function() {
							delete this.onEnterFrame;
						}
					} else {
						delete mcScrollerTop.onMouseMove;
						mcScrollerTop._alpha = 0;
						this.$hoverTop = false;
					}
				}
				if(mcScrollerBottom) {
					if(contentHeight > calcContentHeight)
					{
						mcScrollerBottom.clear();
						mcScrollerBottom.paintFrame("outset", 2, 0xffffff, 0xcccccc, _pl, h-_pb-14, w-_pl-_pr, 14);
						mcScrollerBottom.$scrollDelta = Math.round((contentHeight - calcContentHeight) / 30) + 5;
	
						var _xm = Math.round((w-_pl-_pr) / 2) + _pl;
						mcScrollerBottom.lineStyle();
						mcScrollerBottom.beginFill(0x333333, 100);
						mcScrollerBottom.moveTo(_xm, h-_pb-12+8);
						mcScrollerBottom.lineTo(_xm+4, h-_pb-12+3);
						mcScrollerBottom.lineTo(_xm-4, h-_pb-12+3);
						mcScrollerBottom.endFill();
	
						mcScrollerBottom.onMouseMove = function() {
							this.classRef.updateScrollers();
						}
						mcScrollerBottom.onMouseDown = function() {
							if(this.classRef.$hoverBottom) {
								this.onEnterFrame = function() {
									var _hso = this.classRef.$hscrollOffset;
									var _hsod = 0;
									if(_hso + this.$scrollDelta < this.classRef.contentHeight - this.classRef.calcContentHeight + 1) {
										_hsod = this.$scrollDelta;
									} else {
										_hsod = this.classRef.contentHeight - this.classRef.calcContentHeight + 1 - _hso;
									}
									this.classRef.$hscrollOffset += _hsod;
									this.classRef.mcContent._y -= _hsod;
									this.classRef.updateScrollers();
								}
							}
						}
						mcScrollerBottom.onMouseUp = function() {
							delete this.onEnterFrame;
						}
					} else {
						delete mcScrollerBottom.onMouseMove;
						mcScrollerBottom._alpha = 0;
						this.$hoverBottom = false;
					}
				}
			}
		}
		
		// paint children
		var _cno = childNodes[0];
		if(_cno) {
			do {
				_cno.paint();
			}
			while(_cno = _cno.nextSibling);
		}
	}
}


DENG.CWnd.prototype.updateScrollers = function()
{
	if(this.$hscrollOffset < (this.contentHeight - this.calcContentHeight + 1)) {
		this.mcScrollerBottom._visible = true;
		if(this.mcScrollerBottom.hitTest(_level0._xmouse, _level0._ymouse, false)) {
			//this.mcScrollerBottom._alpha = 75;
			this.$hoverBottom = true;
			this.mcScrollerBottom.onRelease = function() {};
		} else {
			this.mcScrollerBottom._alpha = (this.$cssOverflow == "scroll") ? 100 : 0;
			this.$hoverBottom = false;
			delete this.mcScrollerBottom.onRelease;
		}
	} else {
		this.mcScrollerBottom._alpha = 0;
		this.mcScrollerBottom._visible = false;
		this.$hoverBottom = false;
		delete this.mcScrollerBottom.onRelease;
	}
	if(this.$hscrollOffset > 0) {
		this.mcScrollerTop._visible = true;
		if(this.mcScrollerTop.hitTest(_level0._xmouse, _level0._ymouse, false)) {
			//this.mcScrollerTop._alpha = 75;
			this.$hoverTop = true;
			this.mcScrollerTop.onRelease = function() {};
		} else {
			this.mcScrollerTop._alpha = (this.$cssOverflow == "scroll") ? 100 : 0;
			this.$hoverTop = false;
			delete this.mcScrollerTop.onRelease;
		}
	} else {
		this.mcScrollerTop._alpha = 0;
		this.mcScrollerTop._visible = false;
		this.$hoverTop = false;
		delete this.mcScrollerTop.onRelease;
	}
}


DENG.CWnd.prototype.resolveCssProperty = function(name, doNotNormalize)
{
	with(this) {
		// check if property is cached
		var _val = cssPropCalculated[name];
		if(_val != undefined) {
			return _val;
		}
		var _cssDom = css.dom;
		// check inline stylesheet
		if(_cssDom.propertyTableInline[name] == undefined) {
			// property not defined in inline styles
			// try to resolve it from css dom
			_val = rootNode.css.resolveProperty(this, name);
			if(!_val) {
				// check attribute styles
				if(_cssDom.propertyTableAttr[name] == undefined) {
					// no value found
					// check inheritence
					if(!parentNode || !_cssDom.propertyDefs.propInherited[name]) {
						// we're either root or this property is not inherited
						// get the initial value
						//_val = (initialValue == undefined) ? rootNode.css.dom.propertyDefs.propInitial[name] : initialValue;
						_val = rootNode.css.dom.propertyDefs.propInitial[name];
					} else {
						// we're not root node and this property is inherited
						// inherit from parent element
						_val = this.parentNode.resolveCssProperty(name);
					}
				} else {
					_val = _cssDom.propertyTableAttr[name];
				}
			}
		} else {
			_val = _cssDom.propertyTableInline[name];
		}
		// normalize values
		// (where appropriate)
		if(doNotNormalize !== true && _val.length == 1) {
			switch(_val[0].type) {
				case 0: // dependent on other property
					_val = this.resolveCssProperty(_val[0].value);
					break;
				case 1: // number
				case 10: // px
				case 200: // string
				case 201: // ident
				case 210: // uri
				case 300: // color
					_val = _val[0].value;
					break;
				case 5: // percent
					if(!_val[0].value) { _val = 0; }
					break;
				case 11: // cm
					// 1px = 0.028cm
					_val = Math.round(_val[0].value * 35.7142857); // 1/0.028
					break;
				case 12: // mm
					// 1px = 0.28mm
					_val = Math.round(_val[0].value * 3.57142857); // 1/0.28
					break;
				case 13: // in
					// 1in = 25.4mm
					_val = Math.round(_val[0].value * 90.7142857); // 25.4/0.28
					break;
				case 14: // pt
					// 1pt = 1px at 96dpi
					// flash uses 72dpi, so adjust from 96dpi to 72dpi
					_val = Math.round(_val[0].value * 1.33333333); // 4/3
					break;
				case 15: // pc
					// 1pc = 12pt
					_val = Math.round(_val[0].value * 16); // (4/3) * 12
					break;
				case 20: // ems
					var _fs = (name != "fontsize") ? this.resolveCssProperty("fontsize") : this.parentNode.resolveCssProperty("fontsize");
					_val = Math.round(_val[0].value * _fs);
					break;
				case 25: // exs
					// we estimate 1exs = 0.75ems
					var _fs = (name != "fontsize") ? this.resolveCssProperty("fontsize") : this.parentNode.resolveCssProperty("fontsize");
					_val = Math.round(_val[0].value * _fs * .75); // x-height = .75 * height (estimated)
					break;
				default:
					break;
			}
		}
		// check inheritence
		if(_val == "inherit") {
			// this property's value is "inherit" of type ident
			if(!parentNode) {
				// we're root
				// get initial value
				_val = rootNode.css.dom.propertyDefs.propInitial[name];
			} else {
				// we're not root
				// inherit value from parent element
				_val = this.parentNode.resolveCssProperty(name);
			}
		}
		cssPropCalculated[name] = _val;
		//if(name == "fontsize") {
		//	mytrace(name + " <" + this.node.nodeName + "> " + _val, "CWnd", "resolveCssProperty");
		//}
		return _val;
	}
}

DENG.CWnd.prototype.resolveCssPropertyColor = function(name)
{
	var _val = this.resolveCssProperty(name);
	if(typeof _val == "string" && _val != "transparent" && _val != "none") {
		_val = DENG.CSS_PIDENT_COLOR[_val];
	}
	return _val;
}


DENG.CWnd.prototype.resolveCssPropertyPercentage = function(name, refererValue)
{
	var _val = this.resolveCssProperty(name);
	if(_val instanceof Array && _val.length == 1 && _val[0].type == 5) {
		_val = Math.round(_val[0].value * refererValue / 100);
	}
	return _val;
}



DENG.CWnd.prototype.getBorderCssProperties = function()
{
	with(this) {
		var _ts = this.resolveCssProperty("bordertopstyle");
		var _rs = this.resolveCssProperty("borderrightstyle");
		var _bs = this.resolveCssProperty("borderbottomstyle");
		var _ls = this.resolveCssProperty("borderleftstyle");
		var _tw, _rw, _bw, _lw, _tc, _rc, _bc, _lc;
		if(_ts != "none" && _ts != "hidden" && (_tw = this.resolveCssProperty("bordertopwidth"))) {
			_tc = this.resolveCssPropertyColor("bordertopcolor");
		}
		if(_rs != "none" && _rs != "hidden" && (_rw = this.resolveCssProperty("borderrightwidth"))) {
			_rc = this.resolveCssPropertyColor("borderrightcolor");
		}
		if(_bs != "none" && _bs != "hidden" && (_bw = this.resolveCssProperty("borderbottomwidth"))) {
			_bc = this.resolveCssPropertyColor("borderbottomcolor");
		}
		if(_ls != "none" && _ls != "hidden" && (_lw = this.resolveCssProperty("borderleftwidth"))) {
			_lc = this.resolveCssPropertyColor("borderleftcolor");
		}
		this.$cssbhorizontalwidth = _lw + _rw;
		this.$cssbverticalwidth = _tw + _bw;
		this.$cssBorder = {
			t: { w: _tw, s: _ts, c: _tc }, 
			r: { w: _rw, s: _rs, c: _rc }, 
			b: { w: _bw, s: _bs, c: _bc }, 
			l: { w: _lw, s: _ls, c: _lc },
			tr: this.resolveCssPropertyColor("bordertoprightradius"),
			br: this.resolveCssPropertyColor("borderbottomrightradius"),
			bl: this.resolveCssPropertyColor("borderbottomleftradius"),
			tl: this.resolveCssPropertyColor("bordertopleftradius")
		};
	}
}



DENG.CWnd.prototype.getCalculatedWidthHeight = function()
{
	with(this) {
		var _w = cbWidth;
		var _h = cbHeight;
		if(isBlockElement && this.cssPropCalculated.display != "table-row") {
			if(relPositioning) {
				// flow positioning:
				// css2, 10.3, 10.6 (visual formatting model details)
				// computing widths, heights and margins
				if(this.resolveCssProperty("left") == "auto") { cssPropCalculated.left = 0; }
				if(this.resolveCssProperty("right") == "auto") { cssPropCalculated.right = 0; }
				if(this.resolveCssProperty("top") == "auto") { cssPropCalculated.top = 0; }
				if(this.resolveCssProperty("bottom") == "auto") { cssPropCalculated.bottom = 0; }
				if(this.resolveCssProperty("margintop") == "auto") { cssPropCalculated.margintop = 0; }
				if(this.resolveCssProperty("marginbottom") == "auto") { cssPropCalculated.marginbottom = 0; }
				var _wMin = this.resolveCssPropertyPercentage("minwidth", cbWidth);
				var _wMax = this.resolveCssPropertyPercentage("maxwidth", cbWidth);
				if(_wMax != "none" && _wMin > _wMax) {
					var _tmp = _wMin;
					_wMin = _wMax;
					_wMax = _tmp;
				}
				if(this.cssPropCalculated.display == "table-cell") {
					_w = "auto";
				} else {
					_w = this.resolveCssPropertyPercentage("width", _w);
				}
				if(_w == "auto") {
					if(this.resolveCssProperty("marginleft") == "auto") { cssPropCalculated.marginleft = 0; }
					if(this.resolveCssProperty("marginright") == "auto") { cssPropCalculated.marginright = 0; }
					if(this.resolveCssProperty("paddingleft") == "auto") { cssPropCalculated.paddingleft = 0; }
					if(this.resolveCssProperty("paddingright") == "auto") { cssPropCalculated.paddingright = 0; }
					_w = cbWidth
						- this.resolveCssPropertyPercentage("marginleft", cbWidth)
						- this.resolveCssPropertyPercentage("marginright", cbWidth)
						- this.resolveCssPropertyPercentage("paddingleft", cbWidth)
						- this.resolveCssPropertyPercentage("paddingright", cbWidth)
						- $cssbhorizontalwidth;
					if(_w < _wMin) { _w = _wMin; } else if(_wMax != "none" && _w > _wMax) { _w = _wMax; }
				} else {
					if(_w < _wMin) { _w = _wMin; } else if(_wMax != "none" && _w > _wMax) { _w = _wMax; }
					cssPropCalculated.marginright = cbWidth 
															- _w
															- this.resolveCssPropertyPercentage("marginleft", cbWidth)
															- this.resolveCssPropertyPercentage("paddingleft", cbWidth)
															- this.resolveCssPropertyPercentage("paddingright", cbWidth)
															- $cssbhorizontalwidth;
				}
				var _htmp = this.resolveCssProperty("height");
				if(_htmp != "auto") {
					_h = _htmp
						+ this.resolveCssPropertyPercentage("margintop", _h)
						+ this.resolveCssPropertyPercentage("marginbottom", _h)
						+ this.resolveCssPropertyPercentage("paddingtop", _h)
						+ this.resolveCssPropertyPercentage("paddingbottom", _h)
						+ $cssbverticalwidth;
				}
			} else {
				// absolute positioning:
				var _lm = this.resolveCssPropertyPercentage("marginleft", _w) + $cssbleftwidth + this.resolveCssPropertyPercentage("paddingleft", _w);
				var _rm = this.resolveCssPropertyPercentage("marginright", _w) + $cssbrightwidth + this.resolveCssPropertyPercentage("paddingright", _w);
				var $l = this.resolveCssPropertyPercentage("left", _w);
				var $r = this.resolveCssPropertyPercentage("right", _w);
				var $w = this.resolveCssPropertyPercentage("width", _w);
				var $la = ($l == "auto");
				var $ra = ($r == "auto");
				var $wa = ($w == "auto");
				if($la && $ra && $wa) {
					if(this.resolveCssProperty("direction") == "rtl") {
						$r = cbWidth - $w - mc._x;
						$ra = false;
					} else {
						$l = mc._x;
						$la = false;
					}
				}
				if(!$la && !$ra && !$wa) {
					$r = cbWidth - $w - lm - rm - $l;
				} else if($la && !$ra && $wa) {
					$l = 0;
					$w = cbWidth - lm - rm - $r;
				} else if($la && $ra && !$wa) {
					// 'left' and 'right' are 'auto' and 'width' is not 'auto', then if 'direction' is 'ltr' set 'left'
					// to the "static-position" and solve for right, otherwise set 'right' to the "static-position"
					// and solve for left.
					if(this.resolveCssProperty("direction") == "rtl") {
						$r = cbWidth - $w - mc._x;
						$l = cbWidth - $w - lm - rm - $r;
					} else {
						$l = mc._x;
						$r = cbWidth - $w - lm - rm - $l;
					}
					$l = 0;
				} else if(!$la && $ra && $wa) {
					$r = 0;
					$w = cbWidth - lm - rm - $l;
				} else if($la) {
					$l = cbWidth - $w - lm - rm - $r;
				} else if($ra) {
					$r = cbWidth - $w - lm - rm - $l;
				} else if($wa) {
					$w = cbWidth - lm - rm - $l - $r;
				}
				cssPropCalculated.right = $r;
				cssPropCalculated.left = $l;
				_w = $w;
			}
		}
		return { width:_w, height:_h };
	}
}



DENG.CWnd.prototype.getInitialContainingBlock = function()
{
	// more info:
	// css 2.1 specification
	// 9.1.2. Containing blocks
	var _p = this.xmlDomRef.pos;
	var _w = this.resolveCssPropertyPercentage("width", _p.width);
	var _h = this.resolveCssPropertyPercentage("height", _p.height);
	if(_w == "auto") { _w = _p.width; }
	if(_h == "auto") { _h = _p.height; }
	return { x:_p.x, y:_p.y, width:_w, height:_h };
}



DENG.CWnd.prototype.getContainingBlock = function()
{
	// more info:
	// css 2.1 specification
	// 10.1. Definition of "containing block"
	var cbt;
	var obj = this.rootNode;
	var mc = this.xmlDomRef.mc;
	if(this.parentNode)
	{
		// this is not root:
		// get "position" property
		var p = this.resolveCssProperty("position");
		switch(p)
		{
			case "relative":
			case "static":
				// 2. If the element's position is 'relative' or 'static', the containing block 
				// is formed by the content edge of the nearest block-level, table cell or 
				// inline-block ancestor box.
				var _obj = this.getNearestAnchestor("display", ["block","inline-block","list-item","table","run-in","table-cell"]);
				if(_obj) {
					cbt = 0; // content edge
					obj = _obj;
					mc = obj.mcContent;
				} else {
					// get initial cb
					cbt = 1; // initial cb
				}
				break;
			case "fixed":
				// 3. If the element has 'position: fixed', the containing block is established by 
				// the viewport
				cbt = 2; // viewport
				break;
			case "absolute":
				// 4. If the element has 'position: absolute', the containing block is established 
				// by the nearest ancestor with a 'position' of 'absolute', 'relative' or 'fixed'
				_obj = this.getNearestAnchestor("position", ["absolute","relative","fixed"]);
				if(_obj) {
					mc = obj.mcContent;
					obj = _obj;
					if(_obj.isBlockElement) {
						// 4.1. In the case that the ancestor is block-level, the containing 
						// block is formed by the padding edge of the ancestor.
						cbt = 3; // padding edge
					} else {
						// 4.2. In the case that the ancestor is inline-level, the containing block 
						// depends on the 'direction' property of the ancestor [..]
						// !DIFF! we take the content edge of the ancestors nearest block 
						// element anchestor
						cbt = 0; // content edge
					}
				} else {
					cbt = 0; // content edge
				}
				break;
			default:
				//mytrace("invalid position attribute", "CWnd", "getContainingBlock");
				break;
		}
	}
	else
	{
		// this is root:
		// get initial cb
		cbt = 1; // initial cb
	}
	return [cbt,obj,mc];
}



DENG.CWnd.prototype.getNearestAnchestor = function(property, valueArr)
{
	// returns the nearest anchestor element object with its css
	// property [property] set to one of the values in [valueArr]
	if(this.parentNode) {
		var v = this.parentNode.resolveCssProperty(property);
		for(var i in valueArr) {
			if(v == valueArr[i]) {
				return this.parentNode;
			}
		}
		return this.parentNode.getNearestAnchestor(property, valueArr);
	} else {
		return null;
	}
}




DENG.CWnd.prototype.getTextField = function()
{
	if(this.$tfCreate) {
		// create a new textfield under this element's movieclip (containing block)
		var _tf = this.mcContent.createTextFieldExt();
		_tf.$cb = this;
		_tf.$changed = false;
		_tf.$height = 0;
		_tf.autoSize = "left";
		_tf.html = true;
		_tf.multiline = true;
		_tf.wordWrap = true;
		_tf.selectable = true;
		_tf._visible = false;
		_tf.embedFonts = false;
		// reset $tfCreate to disable creation of new textfields for this element
		this.$tfCreate = false;
		//mytrace(_tf, "CWnd");
		//this.tfList.push(_tfRet);
		return { tfRef:_tf, tfActive:true };
	} else {
		// use current textfield in block anchestor
		// (repeated inline element)
		return { tfRef:this.mcContent.$tfActive, tfActive:false };
	}
}



DENG.CWnd.prototype.toString = function()
{
	return "<" + this.node.nodeName + ">";
}

DENG.CWnd.prototype.getBaseUrl = function()
{
	return this.xmlDomRef.getBaseUrl();
}

DENG.CWnd.prototype.setBaseUrl = function(base)
{
	return this.xmlDomRef.setBaseUrl(base);
}





// ===========================================================================================
//   pseudo classes/elements
// ===========================================================================================

DENG.CWnd.prototype.checkPseudos = function(ss)
{
	var _pcName = ss.name.split("-").join("").toLowerCase();
	if(this.cssPseudoClass == undefined && this.cssActivePseudoClasses[_pcName] == undefined) {
		this.cssActivePseudoClasses[_pcName] = true;
		return this["checkPseudos_" + _pcName](ss, true);
	} else {
		return this["checkPseudos_" + _pcName](ss, false);
	}
}


// ===========================================================================================
//   pseudo element handlers
// ===========================================================================================

DENG.CWnd.prototype.checkPseudos_before = function(ss, initial)
{
	if(initial) {
		new DENG.CElemPseudoBefore().regChildnode(this, this.node, 0);;
	}
	return (this.cssPseudoClass == "before");
}

DENG.CWnd.prototype.checkPseudos_after = function(ss, initial)
{
	if(initial) {
		new DENG.CElemPseudoAfter().regChildnode(this, this.node);
	}
	return (this.cssPseudoClass == "after");
}


// ===========================================================================================
//   pseudo class handlers
// ===========================================================================================

// -------------------------------------------------------------------------------------------
// 6.6.1 Dynamic pseudo-classes
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_link = function()
{
	return (this.resolveCssProperty("link") != "none");
}

DENG.CWnd.prototype.checkPseudos_visited = function()
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_hover = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_active = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_focus = function(ss, initial)
{
	return false; // todo
}

// -------------------------------------------------------------------------------------------
// 6.6.2 The target pseudo-class :target
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_target = function(ss, initial)
{
	return false; // todo
}

// -------------------------------------------------------------------------------------------
// 6.6.3 The language pseudo-class :lang
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_lang = function(ss, initial)
{
	return false; // todo
}

// -------------------------------------------------------------------------------------------
// 6.6.4 The UI element states pseudo-classes
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_enabled = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_disabled = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_checked = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_indeterminate = function(ss, initial)
{
	return false; // todo
}

// -------------------------------------------------------------------------------------------
// 6.6.5 Structural pseudo-classes
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_root = function()
{
	return (this.parentNode == null);
}

DENG.CWnd.prototype.checkPseudos_nthchild = function(ss, initial)
{
	var _ret = false;
	var _node = this.node.parentNode.firstChild;
	var i = 0;
	while(_node && _node != this.node) {
		_node = _node.nextSibling;
		i++
	}
	if(ss.farg == "odd") {
		_ret = (i % 2) == 1;
	} else if(ss.farg == "even") {
		_ret = (i % 2) == 0;
	}
	return _ret;
}

DENG.CWnd.prototype.checkPseudos_nthlastchild = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_nthoftype = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_nthlastoftype = function(ss, initial)
{
	return false; // todo
}

DENG.CWnd.prototype.checkPseudos_firstchild = function()
{
	var _ret = true;
	var _node = this.node;
	do {
		if(_node = _node.previousSibling) {
			// breaks the loop if node is an element
			_ret = (_node.nodeType == 3);
		} else {
			break;
		}
	} while(_ret);
	return _ret;
}

DENG.CWnd.prototype.checkPseudos_lastchild = function()
{
	var _ret = true;
	var _node = this.node;
	do {
		if(_node = _node.nextSibling) {
			// breaks the loop if node is an element
			_ret = (_node.nodeType == 3);
		} else {
			break;
		}
	} while(_ret);
	return _ret;
}

DENG.CWnd.prototype.checkPseudos_firstoftype = function()
{
	var _ret = true;
	var _thisnode = this.node;
	var _node = _thisnode;
	do {
		if(_node = _node.previousSibling) {
			// breaks the loop if node is an element and the type matches the subjects type
			_ret = (_node.nodeType == 3 || _node.nsNodeName != _thisnode.nsNodeName || _node.nsUri != _thisnode.nsUri);
		} else {
			break;
		}
	} while(_ret);
	return _ret;
}

DENG.CWnd.prototype.checkPseudos_lastoftype = function()
{
	var _ret = true;
	var _thisnode = this.node;
	var _node = _thisnode;
	do {
		if(_node = _node.nextSibling) {
			// breaks the loop if node is an element and the type matches the subjects type
			_ret = (_node.nodeType == 3 || _node.nsNodeName != _thisnode.nsNodeName || _node.nsUri != _thisnode.nsUri);
		} else {
			break;
		}
	} while(_ret);
	return _ret;
}

DENG.CWnd.prototype.checkPseudos_onlychild = function()
{
	return (this.checkPseudos_firstchild() && this.checkPseudos_lastchild());
}

DENG.CWnd.prototype.checkPseudos_onlyoftype = function()
{
	return (this.checkPseudos_firstoftype() && this.checkPseudos_lastoftype());
}

DENG.CWnd.prototype.checkPseudos_empty = function()
{
	return (this.node.childNodes.length == 0);
}

// -------------------------------------------------------------------------------------------
// 6.6.6 Content pseudo-class
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_contains = function(ss)
{
	return (this.node.toStringExt("characterData").indexOf(ss.farg) >= 0);
}

// -------------------------------------------------------------------------------------------
// 6.6.7 The negation pseudo-class
// -------------------------------------------------------------------------------------------

DENG.CWnd.prototype.checkPseudos_not = function(ss)
{
	return !this.xmlDomRef.uiDom.css.matchSimpleSelector(this, ss.farg);
}


// -------------------------------------------------------------------------------------------
// regChildnode
// -------------------------------------------------------------------------------------------
// registers this object as child of ui wrapper [obj].
// [pos] is optional and specifies the position in the childNodes array (default: append).
// -------------------------------------------------------------------------------------------
// parameters:
// - obj:
//   reference to this object's new parent
// - node:
//   the parent XMLNode object (used for resolving css properties)
// - idx:
//   undefined: append to childnodes array
//   0..n: index in childnodes array
// -------------------------------------------------------------------------------------------
// NOTE: be careful with this method as it may crew up with the ui dom!
//       this method is currently only used for creating ::before and ::after pseudo elements
//       (see above: checkPseudos_before and checkPseudos_after)
// -------------------------------------------------------------------------------------------
// todo:
// - if this object is already connected to the ui dom, disconnect it from the old context 
//   and clean up before attaching it to the new parent.
// - a zillion of other things
// -------------------------------------------------------------------------------------------
DENG.CWnd.prototype.regChildnode = function(obj, node, idx)
{
	var _pcna = obj.childNodes;
	if(idx === undefined) {
		// append
		_pcna.push(this);
		idx = _pcna.length - 1;
	} else {
		// insert at given index
		if(idx > _pcna.length) {
			idx = _pcna.length;
		}
		_pcna.splice(idx, 0, this);
	}

	this.parentNode = obj;
	this.rootNode = obj.rootNode;

	this.nextSibling = this.previousSibling = null;
	if(_pcna.length > 1) {
		if(idx > 0) {
			var _ps = _pcna[idx-1];
			this.previousSibling = _ps;
			_ps.nextSibling = this;
		}
		if(idx < _pcna.length - 1) {
			var _ns = _pcna[idx-(-1)];
			this.nextSibling = _ns;
			_ns.previousSibling = this;
		}
	}

	if (this.childNodes == undefined) this.childNodes = [];

	// reference to xmldom
	this.xmlDomRef = obj.xmlDomRef;
	// reference to corresponding xmlnode object
	this.node = node;
	// create css object for this element
	if (this.css == undefined) this.css = new DENG.CCss(this);
	// initialize calculated values object
	if (this.cssPropCalculated == undefined) this.cssPropCalculated = {};
	// initialize pseudo class hooks
	if (this.cssPseudoClasses == undefined) this.cssPseudoClasses = {};
}


// -------------------------------------------------------------------------------------------
// moveChildnode
// -------------------------------------------------------------------------------------------
DENG.CWnd.prototype.moveChildnode = function(oldIdx, targetObj, targetNode, targetIdx)
{
	var _tcna = this.childNodes;
	var _tcnal = _tcna.length-1;
	var _node = _tcna[oldIdx];
	if(_tcnal > 1) {
		switch(oldIdx) {
			case 0:
				_tcna[1].previousSibling = null;
				break;
			case _tcnal:
				_tcna[_tcnal-1].nextSibling = null;
				break;
			default:
				_tcna[oldIdx-1].nextSibling = _tcna[oldIdx+1];
				_tcna[oldIdx+1].previousSibling = _tcna[oldIdx-1];
				break;
		}
	}
	this.childNodes.splice(oldIdx, 1);
	
	if(targetNode == undefined || targetNode == null) {
		targetNode = _node.node;
	}
	_node.regChildnode(targetObj, targetNode, targetIdx);
}

// -------------------------------------------------------------------------------------------
// insertAfter
// -------------------------------------------------------------------------------------------
DENG.CWnd.prototype.insertAfter = function(targetObj, targetNode)
{
	this.childNodes = targetObj.childNodes;
	delete targetObj.childNodes;
	targetObj.childNodes = [];

	for(var i in this.childNodes) {
		this.childNodes[i].parentNode = this;
	}
	
	this.parentNode = targetObj.parentNode;
	this.rootNode = targetObj.rootNode;

	this.regChildnode(targetObj, targetNode);
}


DENG.CElemPseudoAfter.prototype.regSibling = function(obj, pos)
{
}



// ===========================================================================================
//   hyperlink handlers
// ===========================================================================================

DENG.CWnd.prototype.registerClickHandler = function(clickHandlerObj)
{
	var _xmlDOMRef = this.xmlDomRef;
	// register clickHandler:
	// push clickHandler object in $clickHandlers array
	if(_xmlDOMRef.$clickHandlers == undefined) {
		_xmlDOMRef.$clickHandlers = [clickHandlerObj];
	} else {
		_xmlDOMRef.$clickHandlers.push(clickHandlerObj);
	}
	//for(var i in _xmlDOMRef.$clickHandlers) {
	//	mytrace(i + " " + _xmlDOMRef.$clickHandlers[i] + " " + typeof i + " " + System.capabilities.version, "CWnd", "onClickHandler");
	//}
	if(typeof this.mcContent.onClickHandler != "function") {
		// create the onClickHandler function on this.mcContent
		// this function will be called by the asfunction in the textfield
		// it redirects the call back to this wrapper object
		// the argument is the clickHandlerID that is created below
		this.mcContent.onClickHandler = function(args) {
			this.classRef.onClickHandler.apply(this.classRef, args.split(","));
		}
	}
	// return this clickHandler's id 
	// (the $clickHandlers array index)
	return _xmlDOMRef.$clickHandlers.length - 1;
}

DENG.CWnd.prototype.onClickHandler = function(clickHandlerID)
{
	// get the registered clickHandler object
	var _clhObj = this.xmlDomRef.$clickHandlers[Number(clickHandlerID)];

	var _u = new DENG.CUri(_clhObj.uri, this.getBaseUrl());
	if(_u.isBaseUrl() && typeof _u.$fragment != "undefined" && _u.$fragment != "" && (_clhObj.targetName == "none" || _clhObj.targetName == "_self")) {
		var _node = this.xmlDomRef[_u.$fragment];
		if(typeof _node != "undefined") {
			// url only differs from baseurl by fragment identifier:
			// calculate the y position of the target element
			var containingBlockObj = _node.obj.isBlockElement ? _node.obj : _node.obj.getContainingBlock()[1];
			var p = { x:0, y:containingBlockObj.mc._y };
			containingBlockObj.mc._parent.localToGlobal(p);
			_node._xmlDomCallback.uiDom.mc.globalToLocal(p);
			// fire component event onScroll
			this.xmlDomRef.onScroll(_clhObj.obj, p.y);
			// bail out
			return;
		}
	}
	// fire component event onClickHandler
	this.xmlDomRef.onClickHandler(_clhObj.obj, _clhObj.uri, _clhObj.targetStyle, _clhObj.targetPosition, _clhObj.targetName);
}

DENG.CWnd.prototype.privateOnRelease = function()
{
	if(this.mc.hitTest(_level0._xmouse, _level0._ymouse, true)) {
		//trace(this.toString() + " privateOnRelease ");
	}
}

DENG.CWnd.prototype.privateOnReleaseOutside = function()
{
	if(this.mc.hitTest(_level0._xmouse, _level0._ymouse, true)) {
		//trace(this.toString() + " privateOnReleaseOutside ");
	}
}

DENG.CWnd.prototype.privateOnPress = function()
{
	//trace(this.toString() + " privateOnPress ");
}

DENG.CWnd.prototype.privateOnRollOver = function()
{
	//trace(this.toString() + " privateOnRollOver ");
}

DENG.CWnd.prototype.privateOnRollOut = function()
{
	//trace(this.toString() + " privateOnRollOut ");
}






// this is under construction and not supposed to work yet
DENG.CWnd.prototype.cleanUp = function()
{
	with(this) {
		var _cno = childNodes[0];
		if(_cno) {
			do {
				_cno.cleanUp();
				var _cnons = _cno.nextSibling;
				delete _cno;
				_cno = _cnons;
			}
			while(_cno);
		}
	}
	this.css.cleanUp();
	delete this.css;
	delete this.parentNode;
	delete this.rootNode;
	delete this.nextSibling;
	delete this.previousSibling;
	delete this.childNodes;
	delete this.xmlDomRef;
	delete this.node;
	delete this.cssPropCalculated;
	delete this.cbObj;
	delete this.cbMC;
	delete this.mc.classRef;
	delete this.mc;
	delete this.$cssOverflow;
	delete this.mcContent.classRef;
	delete this.mcContent;
	delete this.mcMask;
	delete this.mcScrollerTop.classRef;
	delete this.mcScrollerTop.onMouseMove;
	delete this.mcScrollerTop.onMouseDown;
	delete this.mcScrollerTop.onMouseUp;
	delete this.mcScrollerTop.onEnterFrame;
	delete this.mcScrollerTop;
	delete this.mcScrollerBottom.classRef;
	delete this.mcScrollerBottom.onMouseMove;
	delete this.mcScrollerBottom.onMouseDown;
	delete this.mcScrollerBottom.onMouseUp;
	delete this.mcScrollerBottom.onEnterFrame;
	delete this.mcScrollerBottom;
	delete this.$cssBorder;

}


