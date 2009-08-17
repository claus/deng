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
//   class DENG.CCssProperties
// ===========================================================================================

DENG.CCssProperties = function(callback)
{
	// callback : CCss
	// callback.callback : CElem
	if(callback) {
		this.callback = callback;
		this.initialValuesNode = callback.callback.nodeRoot;
		this.initialized = false;
		// property inheritance
		this.propInherited = this.getInherited();
	}
}


DENG.CCssProperties.prototype.init = function(isRootNodeCSS)
{
	with(this) {
		if(!initialized) {
			// no need to inizialize twice
			initialized = true;
			// shorthand properties
			this.propShorthand = this.getShorthand();
			// are we root?
			if(isRootNodeCSS) {
				// yes: set initial values
				this.propInitial = this.getInitial();
			}
		}
	}
}


DENG.CCssProperties.prototype.getShorthand = function()
{
	return {
		background: "getShorthandBackground",
		border: "getShorthandBorder",
		bordercolor: "getShorthandBorderColor",
		borderstyle: "getShorthandBorderStyle",
		bordertop: "getShorthandBorderTop",
		borderright: "getShorthandBorderRight",
		borderbottom: "getShorthandBorderBottom",
		borderleft: "getShorthandBorderLeft",
		borderwidth: "getShorthandBorderWidth",
		borderradius: "getShorthandBorderRadius",
		font: "getShorthandFont",
		liststyle: "getShorthandListStyle",
		margin: "getShorthandMargin",
		outline: "getShorthandOutline",
		padding: "getShorthandPadding",
		target: "getShorthandTarget"
	};
}

DENG.CCssProperties.prototype.getInherited = function()
{
	return {
		bordercollapse: true,
		borderspacing: true,
		captionside: true,
		color: true,
		cursor: true,
		direction: true,
		emptycells: true,
		fontfamily: true,
		fontsize: true,
		fontsizeadjust: true,
		fontstyle: true,
		fontstretch: true,
		fontvariant: true,
		fontweight: true,
		letterspacing: true,
		lineheight: true,
		link: true,
		liststyleimage: true,
		liststyleposition: true,
		liststyletype: true,
		orphans: true,
		page: true,
		pagebreakinside: true,
		quotes: true,
		targetname: true,
		targetposition: true,
		targetstyle: true,
		textalign: true,
		textdecoration: true,
		textindent: true,
		texttransform: true,
		whitespace: true,
		widows: true,
		wordspacing: true
	};
}

DENG.CCssProperties.prototype.getInitial = function()
{
	return {
		backgroundattachment: "scroll",
		backgroundcolor: "transparent",
		backgroundimage: "none",
		backgroundopacity: 1,
		backgroundposition: [{operator:1, type:5, value:0}, {type:5, value:0}],
		backgroundrepeat: "repeat",
		bordercollapse: "collapse",
		borderspacing: 0,
		bordertopcolor: [{type:0, value:"color"}],
		borderrightcolor: [{type:0, value:"color"}],
		borderbottomcolor: [{type:0, value:"color"}],
		borderleftcolor: [{type:0, value:"color"}],
		bordertopstyle: "none",
		borderrightstyle: "none",
		borderbottomstyle: "none",
		borderleftstyle: "none",
		bordertopwidth: 2, //"medium",
		borderrightwidth: 2, //"medium",
		borderbottomwidth: 2, //"medium",
		borderleftwidth: 2, //"medium",
		bordertoprightradius: 0,
		borderbottomrightradius: 0,
		borderbottomleftradius: 0,
		bordertopleftradius: 0,
		bottom: "auto",
		captionside: "top",
		clear: "none",
		clip: "auto",
		color: 0,
		content: "",
		counterincrement: "none",
		counterreset: "none",
		cursor: "auto",
		direction: "ltr",
		display: "inline",
		emptycells: "show",
		float: "none",
		fontfamily: [{type:200, value:"Arial"},{type:200, value:"Helvetica"},{type:200, value:"sans-serif"}],
		fontsize: 12,
		fontsizeadjust: "none",
		fontstyle: "normal",
		fontstretch: "normal",
		fontvariant: "normal",
		fontweight: "normal",
		height: "auto",
		left: "auto",
		letterspacing: "normal",
		lineheight: "normal",
		link: "none",
		liststyleimage: "none",
		liststyleposition: "outside",
		liststyletype: "disc",
		marginright: 0,
		marginleft: 0,
		margintop: 0,
		marginbottom: 0,
		markeroffset: "auto",
		marks: "none",
		maxheight: "none",
		maxwidth: "none",
		minheight: 0,
		minwidth: 0,
		orphans: 2,
		outlinecolor: "invert",
		outlinestyle: "none",
		outlinewidth: "medium",
		overflow: "visible",
		paddingtop: 0,
		paddingright: 0,
		paddingbottom: 0,
		paddingleft: 0,
		page: "auto",
		pagebreakafter: "auto",
		pagebreakbefore: "auto",
		pagebreakinside: "auto",
		position: "static",
		quotes: "none",
		right: "auto",
		size: "auto",
		tablelayout: "auto",
		targetname: "none",
		targetposition: "current",
		targetstyle: "auto",
		textalign: "left", //[{type:0, value:"getPropertyTextAlign"}],
		textdecoration: "none",
		textindent: 0,
		textshadow: "none",
		texttransform: "none",
		top: "auto",
		unicodebidi: "normal",
		verticalalign: "baseline",
		visibility: "inherit",
		whitespace: "normal",
		widows: 2,
		width: "auto",
		wordspacing: "normal",
		zindex: "auto"
	};
}



// ===========================================================================================
// ===  converters for shorthand properties                                                ===
// ===========================================================================================
//  valid for all shorthand property converters:
// -------------------------------------------------------------------------------------------
//  parameters:
//  oDeclaration [object] - declaration object (contains shorthand property declaration)
// -------------------------------------------------------------------------------------------
//  returns [array]
//  array of non-shorthand declaration objects
// -------------------------------------------------------------------------------------------


// font: [ [ <'font-style'> || <'font-variant'> || <'font-weight'> ]?
//         <'font-size'> [ "/" <'line-height'> ]? <'font-family'> ]
//       | caption | icon | menu | message-box | small-caption | status-bar | inherit 
// font-style   : normal | italic | oblique | inherit 
// font-variant : normal | small-caps | inherit 
// font-weight  : normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | inherit
// font-size    : xx-small | x-small | small | medium | large | x-large | xx-large | larger | smaller | inherit
//                | <length> | <percentage>

DENG.CCssProperties.prototype.getShorthandFont = function(oDeclaration)
{
	// set initial values
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	var _fontList = [];
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// "font: inherit;"
		// set "inherit" on all font properties (all font properties 
		// are inherited from the anchestor node's font properties)
		_decl = [ 
			{ property:"fontfamily", expr:_expr, prio:_prio },
			{ property:"fontsize", expr:_expr, prio:_prio },
			{ property:"fontsizeadjust", expr:_expr, prio:_prio },
			{ property:"fontstretch", expr:_expr, prio:_prio },
			{ property:"fontstyle", expr:_expr, prio:_prio },
			{ property:"fontvariant", expr:_expr, prio:_prio },
			{ property:"fontweight", expr:_expr, prio:_prio },
			{ property:"lineheight", expr:_expr, prio:_prio }
		];
	} else {
		var _initValuesObj = this.initialValuesNode.obj.css.dom.propertyDefs.propInitial;
		// set initial values
		_decl = [ 
			{ property:"fontsize", expr:null, prio:_prio }, // mandatory
			{ property:"fontfamily", expr:null, prio:_prio }, // mandatory
			{ property:"fontsizeadjust", expr:_initValuesObj.fontsizeadjust, prio:_prio },
			{ property:"fontstretch", expr:_initValuesObj.fontstretch, prio:_prio },
			{ property:"fontstyle", expr:_initValuesObj.fontstyle, prio:_prio },
			{ property:"fontvariant", expr:_initValuesObj.fontvariant, prio:_prio },
			{ property:"fontweight", expr:_initValuesObj.fontweight, prio:_prio },
			{ property:"lineheight", expr:_initValuesObj.lineheight, prio:_prio }
		];
		// overwrite specified values
		var _bstretch = false, _bsizeadjust = false, _bstyle = false, _bvariant = false, _bweight = false, _bsize = false, _blineheight = false, _bfamily = false;
		for(var i = 0; i < _exprLen; i++)
		{
			var _etype = _expr[i].type;
			var _evalue = _expr[i].value;
			if (!_bsize && _etype == 201 && DENG.CSS_PIDENT_FONTSIZE[_evalue]) {
			    _bsize = true;
			    _decl[0].expr = [_expr[i]];
			} else if (!_bsize && (_etype == 5 || (_etype > 9 && _etype < 26))) {
			    _bsize = true;
			    _decl[0].expr = [_expr[i]];
			} else if (!b_sizeadjust && _etype == 201 && DENG.CSS_PIDENT_FONTSIZEADJUST[_evalue]) {
				_bsizeadjust = true;
				_decl[2].expr = [_expr[i]];
			} else if (!_bstretch && _etype == 201 && DENG.CSS_PIDENT_FONTSTRETCH[_evalue]) {
				_bstretch = true;
				_decl[3].expr = [_expr[i]];
			} else if(!_bstyle && _etype == 201 && DENG.CSS_PIDENT_FONTSTYLE[_evalue]) {
				_bstyle = true;
				_decl[4].expr = [_expr[i]];
			} else if(!_bvariant && _etype == 201 && DENG.CSS_PIDENT_FONTVARIANT[_evalue]) {
				_bvariant = true;
				_decl[5].expr = [_expr[i]];
			} else if(!_bweight && ((_etype == 201 && DENG.CSS_PIDENT_FONTWEIGHT[_evalue]) || _etype == 1)) {
				_bweight = true;
				_decl[6].expr = [_expr[i]];
			} else if (_etype == 201 || _etype == 200) {
			  	/* Assume all other idents and strings are font-families, save these in read order */
			  	_bfamily = true;
				_fontList.push(_expr[i]);
			}
			/*
			   Not implementing line-height for now.  I'm a bit confused about the syntax
			   for it, since it also accepts number and length (possibly obscured by 
			   font-weight and font-size?)  I'm reading the W3 recommendations first.
			   
			   - Jim <jim@psalterego.com>
		    */
			else {
				mytrace("unknown value [type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandFont", 2);
				return null;
			}
		}
		/* Write out the font families if any were found */
		if (_fontList.length) { _decl[1].expr = _fontList; }
		if (!_bsize || !_bfamily) {
		   mytrace("font-size and font-family are mandatory for CSS font shorthand", "CCssProperties", "getShorthandFont", 1);
		}
	}
	return _decl;
}




// -------------------------------------------------------------------------------------------
// DENG.CCssProperties.getShorthandBackground
// converts "background" shorthand property
// -------------------------------------------------------------------------------------------
// background : [ <'background-color'> || <'background-image'> || <'background-repeat'> || 
//                <'background-attachment'> || <'background-position'> ] | inherit 
// border-width : thin | medium | thick | <length> | inherit
// border-style : none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset | inherit
// border-color : transparent | <color> | inherit
// -------------------------------------------------------------------------------------------
DENG.CCssProperties.prototype.getShorthandBackground = function(oDeclaration)
{
	// set initial values
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// "background: inherit;"
		// set "inherit" on all background properties (all background properties 
		// are inherited from the anchestor node's background properties)
		_decl = [ 
			{ property:"backgroundcolor", expr:_expr, prio:_prio },
			{ property:"backgroundimage", expr:_expr, prio:_prio },
			{ property:"backgroundrepeat", expr:_expr, prio:_prio },
			{ property:"backgroundattachment", expr:_expr, prio:_prio },
			{ property:"backgroundposition", expr:_expr, prio:_prio }
		];
	} else if(_exprLen <= 5) {
		var _initValuesObj = this.initialValuesNode.obj.css.dom.propertyDefs.propInitial;
		// set initial values
		_decl = [ 
			{ property:"backgroundcolor", expr:_initValuesObj.backgroundcolor, prio:_prio },
			{ property:"backgroundimage", expr:_initValuesObj.backgroundimage, prio:_prio },
			{ property:"backgroundrepeat", expr:_initValuesObj.backgroundrepeat, prio:_prio },
			{ property:"backgroundattachment", expr:_initValuesObj.backgroundattachment, prio:_prio },
			{ property:"backgroundposition", expr:_initValuesObj.backgroundposition, prio:_prio }
		];
		// overwrite specified values
		var _bcolor = false, _bimage = false, _brepeat = false, _battachment = false, _bposition = false;
		for(var i = 0; i < _exprLen; i++)
		{
			if(_expr[i].operator > 1) {
				mytrace("unknown operator [op:" + _expr[i].operator + ", type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBackground", 2);
				return null;
			}
			var _etype = _expr[i].type;
			var _evalue = _expr[i].value;
			if(!_bcolor && ((_etype == 201 && (DENG.CSS_PIDENT_BACKGROUNDCOLOR[_evalue] || DENG.CSS_PIDENT_COLOR[_evalue] != undefined)) || _etype == 300)) {
				_bcolor = true;
				_decl[0].expr = [_expr[i]];
			} else if(!_bimage && ((_etype == 201 && DENG.CSS_PIDENT_BACKGROUNDIMAGE[_evalue]) || _etype == 210)) {
				_bimage = true;
				_decl[1].expr = [_expr[i]];
			} else if(!_brepeat && _etype == 201 && DENG.CSS_PIDENT_BACKGROUNDREPEAT[_evalue]) {
				_brepeat = true;
				_decl[2].expr = [_expr[i]];
			} else if(!_battachment && _etype == 201 && DENG.CSS_PIDENT_BACKGROUNDATTACHMENT[_evalue]) {
				_battachment = true;
				_decl[3].expr = [_expr[i]];
			} else if(!_bposition && ((_etype > 0 && _etype < 30) || (_etype == 201 && DENG.CSS_PIDENT_BACKGROUNDPOSITION[_evalue]))) {
				_bposition = true;
				i++;
				_etype = _expr[i].type;
				_evalue = _expr[i].value;
				if(i < _exprLen && _expr[i].operator <= 1 && ((_etype > 0 && _etype < 30) || (_etype == 201 && _evalue != "inherit" && DENG.CSS_PIDENT_BACKGROUNDPOSITION[_evalue]))) {
					_decl[4].expr = [_expr[i-1],_expr[i]];
				} else {
					_decl[4].expr = [_expr[--i]];
				}
			} else {
				mytrace("unknown value [type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBackground", 2);
				return null;
			}
		}
	} else {
		mytrace("unknown value [type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBackground", 2);
		return null;
	}
	return _decl;
}


// -------------------------------------------------------------------------------------------
// DENG.CCssProperties.getShorthandBorder
// converts "border" shorthand property
// -------------------------------------------------------------------------------------------
// border : [ <border-width> || <border-style> || <border-color> ] | inherit
// border-width : thin | medium | thick | <length> | inherit
// border-style : none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset | inherit
// border-color : transparent | <color> | inherit
// -------------------------------------------------------------------------------------------
DENG.CCssProperties.prototype.getShorthandBorder = function(oDeclaration)
{
	// set initial values
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// "border: inherit;"
		// set "inherit" on all border properties (all border properties 
		// are inherited from the anchestor node's border properties)
		_decl = [ 
			{ property:"bordertopcolor", expr:_expr, prio:_prio },
			{ property:"borderrightcolor", expr:_expr, prio:_prio },
			{ property:"borderbottomcolor", expr:_expr, prio:_prio },
			{ property:"borderleftcolor", expr:_expr, prio:_prio },
			{ property:"bordertopstyle", expr:_expr, prio:_prio },
			{ property:"borderrightstyle", expr:_expr, prio:_prio },
			{ property:"borderbottomstyle", expr:_expr, prio:_prio },
			{ property:"borderleftstyle", expr:_expr, prio:_prio },
			{ property:"bordertopwidth", expr:_expr, prio:_prio },
			{ property:"borderrightwidth", expr:_expr, prio:_prio },
			{ property:"borderbottomwidth", expr:_expr, prio:_prio },
			{ property:"borderleftwidth", expr:_expr, prio:_prio }
		];
	} else if(_exprLen <= 3) {
		var _initValuesObj = this.initialValuesNode.obj.css.dom.propertyDefs.propInitial;
		// set initial values
		_decl = [ 
			{ property:"bordertopcolor", expr:_initValuesObj.bordertopcolor, prio:_prio },
			{ property:"borderrightcolor", expr:_initValuesObj.borderrightcolor, prio:_prio },
			{ property:"borderbottomcolor", expr:_initValuesObj.borderbottomcolor, prio:_prio },
			{ property:"borderleftcolor", expr:_initValuesObj.borderleftcolor, prio:_prio },
			{ property:"bordertopstyle", expr:_initValuesObj.bordertopstyle, prio:_prio },
			{ property:"borderrightstyle", expr:_initValuesObj.borderrightstyle, prio:_prio },
			{ property:"borderbottomstyle", expr:_initValuesObj.borderbottomstyle, prio:_prio },
			{ property:"borderleftstyle", expr:_initValuesObj.borderleftstyle, prio:_prio },
			{ property:"bordertopwidth", expr:_initValuesObj.bordertopwidth, prio:_prio },
			{ property:"borderrightwidth", expr:_initValuesObj.borderrightwidth, prio:_prio },
			{ property:"borderbottomwidth", expr:_initValuesObj.borderbottomwidth, prio:_prio },
			{ property:"borderleftwidth", expr:_initValuesObj.borderleftwidth, prio:_prio }
		];
		// overwrite specified values
		var _bwidth = false, _bstyle = false, _bcolor = false;
		for(var i = 0; i < _exprLen; i++) {
			if(_expr[i].operator > 1) {
				mytrace("unknown operator [op:" + _expr[i].operator + ", type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBorder", 2);
				return null;
			}
			var _etype = _expr[i].type;
			var _evalue = _expr[i].value;
			var _exprNew = [_expr[i]];
			if(!_bwidth && ((_etype == 201 && DENG.CSS_PIDENT_BORDERWIDTH[_evalue]) || (_etype > 0 && _etype < 30))) {
				_bwidth = true;
				_decl[8].expr = _decl[9].expr = _decl[10].expr = _decl[11].expr = _exprNew;
			} else if(!_bstyle && _etype == 201 && DENG.CSS_PIDENT_BORDERSTYLE[_evalue]) {
				_bstyle = true;
				_decl[4].expr = _decl[5].expr = _decl[6].expr = _decl[7].expr = _exprNew;
			} else if(!_bcolor && ((_etype == 201 && (DENG.CSS_PIDENT_BORDERCOLOR[_evalue] || DENG.CSS_PIDENT_COLOR[_evalue] != undefined)) || _etype == 300)) {
				_bcolor = true;
				_decl[0].expr = _decl[1].expr = _decl[2].expr = _decl[3].expr = _exprNew;
			} else {
				mytrace("unknown value [type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBorder", 2);
				return null;
			}
		}
	} else {
		mytrace("unknown value [type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBorder", 2);
		return null;
	}
	return _decl;
}


// -------------------------------------------------------------------------------------------
// DENG.CCssProperties.getShorthandBorderTop/Right/Bottom/Left
// converts the shorthand properties "border-top", "border-right", "border-bottom" 
// and "border-left"
// -------------------------------------------------------------------------------------------
// border-top, border-right, border-bottom, border-left :
// [<border-width> || <border-style> || <border-color>] | inherit
// -------------------------------------------------------------------------------------------
DENG.CCssProperties.prototype.getShorthandBorderTop = 
DENG.CCssProperties.prototype.getShorthandBorderRight = 
DENG.CCssProperties.prototype.getShorthandBorderLeft = 
DENG.CCssProperties.prototype.getShorthandBorderBottom = function(oDeclaration)
{
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	var _type = oDeclaration.property.substr(6);
	
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// eg. "border-top: inherit;"
		// set "inherit" on all border properties (all border properties 
		// are inherited from the anchestor node's border properties)
		_decl = [ 
			{ property:"border" + _type + "color", expr:_expr, prio:_prio },
			{ property:"border" + _type + "style", expr:_expr, prio:_prio },
			{ property:"border" + _type + "width", expr:_expr, prio:_prio }
		];
	} else if(_exprLen <= 3) {
		// set initial values
		var _initValuesObj = this.initialValuesNode.obj.css.dom.propertyDefs.propInitial;
		_decl = [ 
			{ property:"border" + _type + "color", expr:_initValuesObj["border" + _type + "color"], prio:_prio },
			{ property:"border" + _type + "style", expr:_initValuesObj["border" + _type + "style"], prio:_prio },
			{ property:"border" + _type + "width", expr:_initValuesObj["border" + _type + "width"], prio:_prio }
		];
		// overwrite specified values
		var _bwidth = false, _bstyle = false, _bcolor = false;
		for(var i = 0; i < _exprLen; i++) {
			if(_expr[i].operator > 1) {
				mytrace("unknown operator [property:border-" + _type + ", op:" + _expr[i].operator + ", type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBorderTop/Right/Bottom/Left", 2);
				return null;
			}
			var _etype = _expr[i].type;
			var _evalue = _expr[i].value;
			var _exprNew = [_expr[i]];
			if(!_bwidth && ((_etype == 201 && DENG.CSS_PIDENT_BORDERWIDTH[_evalue]) || (_etype > 0 && _etype < 30))) {
				_bwidth = true;
				_decl[2].expr = _exprNew;
			} else if(!_bstyle && _etype == 201 && DENG.CSS_PIDENT_BORDERSTYLE[_evalue]) {
				_bstyle = true;
				_decl[1].expr = _exprNew;
			} else if(!_bcolor && ((_etype == 201 && (DENG.CSS_PIDENT_BORDERCOLOR[_evalue] || DENG.CSS_PIDENT_COLOR[_evalue] != undefined)) || _etype == 300)) {
				_bcolor = true;
				_decl[0].expr = _exprNew;
			} else {
				mytrace("unknown value [property:border-" + _type + ", type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBorderTop/Right/Bottom/Left", 2);
				return null;
			}
		}
	} else {
		mytrace("unknown value [property:border-" + _type + ", type:" + _etype + ", value:" + _evalue + "]", "CCssProperties", "getShorthandBorderTop/Right/Bottom/Left", 2);
		return null;
	}
	return _decl;
}


// -------------------------------------------------------------------------------------------
// DENG.CCssProperties.getShorthandBorderRadius
// converts the shorthand property "border-radius"
// -------------------------------------------------------------------------------------------
// border-radius :
// [<length> <length>?] | inherit
// -------------------------------------------------------------------------------------------
DENG.CCssProperties.prototype.getShorthandBorderRadius = function(oDeclaration)
{
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// eg. "border-radius: inherit;"
		// set "inherit" on all border radius properties (all border 
		// radius properties are inherited from the anchestor node's 
		// border radius properties)
		_decl = [ 
			{ property:"bordertoprightradius", expr:_expr, prio:_prio },
			{ property:"borderbottomrightradius", expr:_expr, prio:_prio },
			{ property:"borderbottomleftradius", expr:_expr, prio:_prio },
			{ property:"bordertopleftradius", expr:_expr, prio:_prio }
		];
	} else {
		// set initial values
		var _initValuesObj = this.initialValuesNode.obj.css.dom.propertyDefs.propInitial;
		switch(_exprLen) {
			case 1:
			case 2:
				_decl = [ 
					{ property:"bordertoprightradius", expr:_expr, prio:_prio },
					{ property:"borderbottomrightradius", expr:_expr, prio:_prio },
					{ property:"borderbottomleftradius", expr:_expr, prio:_prio },
					{ property:"bordertopleftradius", expr:_expr, prio:_prio }
				];
				break;
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			default:
				// todo: allow more than 2 border-radius expressions
				mytrace("illegal number of expressions [property:border-radius]", "CCssProperties", "getShorthandBorderRadius", 2);
				return null;
		}
	}
	return _decl;
}


// -------------------------------------------------------------------------------------------
// DENG.CCssProperties.getShorthandBorderColor/Style/Width
// converts the shorthand properties border-color, border-style and border-width
// -------------------------------------------------------------------------------------------
// border-color : [<color>|transparent]{1,4} | inherit
// border-style : <border-style>{1,4} | inherit
// border-width : <border-width>{1,4} | inherit
// -------------------------------------------------------------------------------------------
DENG.CCssProperties.prototype.getShorthandBorderColor = 
DENG.CCssProperties.prototype.getShorthandBorderStyle = 
DENG.CCssProperties.prototype.getShorthandBorderWidth = function(oDeclaration)
{
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	var _type = oDeclaration.property.substr(6);
	
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// eg. "border-color: inherit;"
		// set "inherit" on all border-color properties (all border-color 
		// properties are inherited from the anchestor node's border-color properties)
		_decl = [ 
			{ property:"bordertop" + _type, expr:_expr, prio:_prio },
			{ property:"borderright" + _type, expr:_expr, prio:_prio },
			{ property:"borderbottom" + _type, expr:_expr, prio:_prio },
			{ property:"borderleft" + _type, expr:_expr, prio:_prio }
		];
	} else {
		switch(_exprLen) {
			case 1:
				// [top/bottom/right/left]
				var _exprNew = [_expr[0]];
				_decl = [ 
					{ property:"bordertop" + _type, expr:_exprNew, prio:_prio },
					{ property:"borderright" + _type, expr:_exprNew, prio:_prio },
					{ property:"borderbottom" + _type, expr:_exprNew, prio:_prio },
					{ property:"borderleft" + _type, expr:_exprNew, prio:_prio }
				];
				break;
			case 2:
				// [top/bottom] [right/left]
				_decl = [ 
					{ property:"bordertop" + _type, expr:[_expr[0]], prio:_prio },
					{ property:"borderright" + _type, expr:[_expr[1]], prio:_prio },
					{ property:"borderbottom" + _type, expr:[_expr[0]], prio:_prio },
					{ property:"borderleft" + _type, expr:[_expr[1]], prio:_prio }
				];
				break;
			case 3:
				// [top] [right/left] [bottom]
				_decl = [ 
					{ property:"bordertop" + _type, expr:[_expr[0]], prio:_prio },
					{ property:"borderright" + _type, expr:[_expr[1]], prio:_prio },
					{ property:"borderbottom" + _type, expr:[_expr[2]], prio:_prio },
					{ property:"borderleft" + _type, expr:[_expr[1]], prio:_prio }
				];
				break;
			case 4:
				// [top] [right] [bottom] [left]
				_decl = [ 
					{ property:"bordertop" + _type, expr:[_expr[0]], prio:_prio },
					{ property:"borderright" + _type, expr:[_expr[1]], prio:_prio },
					{ property:"borderbottom" + _type, expr:[_expr[2]], prio:_prio },
					{ property:"borderleft" + _type, expr:[_expr[3]], prio:_prio }
				];
				break;
			default:
				mytrace("border-" + _type + ": illegal number of terms in expression", "CCssProperties", "getShorthandBorderColor/Style/Width", 2);
				return null;
		}
	}
	return _decl;
}


// -------------------------------------------------------------------------------------------
// DENG.CCssProperties.getShorthandMargin/Padding
// converts the shorthand properties margin and padding
// -------------------------------------------------------------------------------------------
// margin  : <margin-width>{1,4} | inherit 
// padding : <padding-width>{1,4} | inherit 
// -------------------------------------------------------------------------------------------
DENG.CCssProperties.prototype.getShorthandMargin = 
DENG.CCssProperties.prototype.getShorthandPadding = function(oDeclaration)
{
	var _decl;
	var _prio = oDeclaration.prio;
	var _expr = oDeclaration.expr;
	var _exprLen = _expr.length;
	var _type = oDeclaration.property;
	
	if(_exprLen == 1 && _expr[0].type == 201 && _expr[0].value == "inherit") {
		// eg. "margin: inherit;"
		// set "inherit" on all margin properties (all margin properties are 
		// inherited from the anchestor node's margin properties)
		_decl = [ 
			{ property:_type + "top", expr:_expr, prio:_prio },
			{ property:_type + "right", expr:_expr, prio:_prio },
			{ property:_type + "bottom", expr:_expr, prio:_prio },
			{ property:_type + "left", expr:_expr, prio:_prio }
		];
	} else {
		switch(_exprLen) {
			case 1:
				// [top/bottom/right/left]
				var _exprNew = [_expr[0]];
				_decl = [ 
					{ property:_type + "top", expr:_exprNew, prio:_prio },
					{ property:_type + "right", expr:_exprNew, prio:_prio },
					{ property:_type + "bottom", expr:_exprNew, prio:_prio },
					{ property:_type + "left", expr:_exprNew, prio:_prio }
				];
				break;
			case 2:
				// [top/bottom] [right/left]
				_decl = [ 
					{ property:_type + "top", expr:[_expr[0]], prio:_prio },
					{ property:_type + "right", expr:[_expr[1]], prio:_prio },
					{ property:_type + "bottom", expr:[_expr[0]], prio:_prio },
					{ property:_type + "left", expr:[_expr[1]], prio:_prio }
				];
				break;
			case 3:
				// [top] [right/left] [bottom]
				_decl = [ 
					{ property:_type + "top", expr:[_expr[0]], prio:_prio },
					{ property:_type + "right", expr:[_expr[1]], prio:_prio },
					{ property:_type + "bottom", expr:[_expr[2]], prio:_prio },
					{ property:_type + "left", expr:[_expr[1]], prio:_prio }
				];
				break;
			case 4:
				// [top] [right] [bottom] [left]
				_decl = [ 
					{ property:_type + "top", expr:[_expr[0]], prio:_prio },
					{ property:_type + "right", expr:[_expr[1]], prio:_prio },
					{ property:_type + "bottom", expr:[_expr[2]], prio:_prio },
					{ property:_type + "left", expr:[_expr[3]], prio:_prio }
				];
				break;
			default:
				if(_type == "margin")
				mytrace(_type + ": illegal number of terms in expression", "CCssProperties", (_type == "margin") ? "getShorthandMargin" : "getShorthandPadding", 2);
				return null;
		}
	}
	return _decl;
}


// ===========================================================================================
// ===  some lookup tables for property ident values etc                                  ===
// ===========================================================================================

DENG.CSS_PIDENT_FONTSTYLE = { normal:true, oblique:true, italic:true, inherit:true };
DENG.CSS_PIDENT_FONTVARIANT = { normal:true, inherit:true }; DENG.CSS_PIDENT_FONTVARIANT["small-caps"] = true;
DENG.CSS_PIDENT_FONTWEIGHT = { normal:true, bold:true, bolder:true, lighter:true, inherit:true };
DENG.CSS_PIDENT_FONTSIZE = { small:true, medium:true, large:true, larger:true, smaller:true, inherit:true };
DENG.CSS_PIDENT_FONTSIZE["xx-small"] = DENG.CSS_PIDENT_FONTSIZE["x-small"] = DENG.CSS_PIDENT_FONTSIZE["x-large"] = DENG.CSS_PIDENT_FONTSIZE["xx-large"] = true;
DENG.CSS_PIDENT_FONTSIZEADJUST = { z:true, none:true, inherit:true };
DENG.CSS_PIDENT_FONTSTRETCH = { normal:true, wider:true, narrower:true, condensed:true, expanded:true, inherit:true};
DENG.CSS_PIDENT_FONTSTRETCH["ultra-condensed"] = DENG.CSS_PIDENT_FONTSTRETCH["extra-condensed"] = DENG.CSS_PIDENT_FONTSTRETCH["semi-condensed"] = true;
DENG.CSS_PIDENT_FONTSTRETCH["semi-expanded"] = DENG.CSS_PIDENT_FONTSTRETCH["extra-expanded"] = DENG.CSS_PIDENT_FONTSTRETCH["ultra-expanded"] = true;
DENG.CSS_PIDENT_BACKGROUNDCOLOR = { transparent:true, inherit:true };
DENG.CSS_PIDENT_BACKGROUNDIMAGE = { none:true, inherit:true };
DENG.CSS_PIDENT_BACKGROUNDREPEAT = { repeat:true, inherit:true };
DENG.CSS_PIDENT_BACKGROUNDREPEAT["repeat-x"] = true;
DENG.CSS_PIDENT_BACKGROUNDREPEAT["repeat-y"] = true;
DENG.CSS_PIDENT_BACKGROUNDREPEAT["no-repeat"] = true;
DENG.CSS_PIDENT_BACKGROUNDATTACHMENT = { scroll:true, fixed:true, inherit:true };
DENG.CSS_PIDENT_BACKGROUNDPOSITION = { top:true, center:true, bottom:true, left:true, right:true, inherit:true };
DENG.CSS_PIDENT_BORDERWIDTH = { thin:1, medium:2, thick:4, inherit:-1 };
DENG.CSS_PIDENT_BORDERSTYLE = { none:true, hidden:true, dotted:true, dashed:true, solid:true, double:true, groove:true, ridge:true, inset:true, outset:true, inherit:true };
DENG.CSS_PIDENT_BORDERCOLOR = { transparent:true, inherit:true };
DENG.CSS_PIDENT_COLOR = {
	inherit: -1,
	// css 2 core color idents
	black: 0x000000, 
	gray: 0x808080, 
	silver: 0xC0C0C0, 
	white: 0xFFFFFF, 
	red: 0xFF0000, 
	green: 0x008000, 
	blue: 0x0000FF, 
	yellow: 0xFFFF00, 
	aqua: 0x00FFFF, 
	fuchsia: 0xFF00FF, 
	lime: 0x00FF00, 
	maroon: 0x800000, 
	navy: 0x000080, 
	olive: 0x808000, 
	purple: 0x800080, 
	teal: 0x008080, 
	// css 2 system ui color idents
	activeborder: 0x000000, 
	activecaption: 0x0A246A, 
	appworkspace: 0xcccccc, 
	background: 0xDDDDDD, 
	buttonface: 0xD4D0C8, 
	buttonhighlight: 0xFFFFFF, 
	buttonshadow: 0x000000, 
	buttontext: 0x000000, 
	captiontext: 0xFFFFFF, 
	graytext: 0x808080, 
	highlight: 0xD4D0C8, 
	highlighttext: 0x000000, 
	inactiveborder: 0x000000, 
	inactivecaption: 0xB7B7B7,
	inactivecaptiontext: 0xFFFFFF,
	infobackground: 0xFFFFE1, 
	infotext: 0x000000, 
	menu: 0xD4D0C8, 
	menutext: 0x000000, 
	scrollbar: 0xD4D0C8, 
	threeddarkshadow: 0x000000, 
	threedface: 0xD4D0C8, 
	threedhighlight: 0xD4D0C8, 
	threedlightshadow: 0xFFFFFF, 
	threedshadow: 0x000000, 
	window: 0xF4F4F4, 
	windowframe: 0x000000, 
	windowtext: 0x000000
}; 


