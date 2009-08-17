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
//   class DENG.CSVGWnd
// ===========================================================================================

DENG.CSVGWnd = function()
{
	super();
}

DENG.CSVGWnd.prototype = new DENG.CWnd();

DENG.CSVGWnd.prototype.initCSSAttr = function() { super.initCSSAttr(); };
DENG.CSVGWnd.prototype.initStyleAttr = function() { super.initStyleAttr(); };
DENG.CSVGWnd.prototype.resolveCssProperty = function(name) { return super.resolveCssProperty(name); };
DENG.CSVGWnd.prototype.resolveCssPropertyColor = function(name) { return super.resolveCssPropertyColor(name); };
DENG.CSVGWnd.prototype.resolveCssPropertyPercentage = function(name, refererValue) { return super.resolveCssPropertyPercentage(name, refererValue); };
DENG.CSVGWnd.prototype.getInitialContainingBlock = function() { return super.getInitialContainingBlock(); };
DENG.CSVGWnd.prototype.getContainingBlock = function() { return super.getContainingBlock(); };
DENG.CSVGWnd.prototype.getNearestAnchestor = function(property, valueArr) { return super.getNearestAnchestor(property, valueArr); };

DENG.CSVGWnd.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// if the style attribute is set (inline styles)
	if(this.node.attributes.style != undefined) {
		// add inline styles to queue
		this.xmlDomRef.cssParseQueue.push({ type: 2, css: this.node.attributes.style, obj: this });
	}
}

DENG.CSVGWnd.prototype.create = function()
{
	var _trans = this.resolveCssProperty("transform");
	if(_trans) {
		// apply transformations
		// (skewing functions by Ivan Dembicki, dembicki@narod.ru)
		var _tl = _trans.length;
		for(var i = 0; i < _tl; i++) {
			if(_trans[i].type = 100) {
				var _expr = _trans[i].expr;
				var _value = _trans[i].value;
				// for each transformation, create a new movieclip
				this.mcContent = this.mcContent.createEmptyMovieClipExt();
				switch(_value) {
					case "translate":
						this.mcContent._x += _expr[0].value;
						if(_expr.length > 1) {
							this.mcContent._y += _expr[1].value;
						}
						break;
					case "scale":
						var _sx = _expr[0].value;
						this.mcContent._xscale *= _sx;
						this.mcContent._yscale *= (_expr.length > 1) ? _expr[1].value : _sx;
						break;
					case "rotate":
						if(_expr.length == 3) {
							// translate/rotate/translate
							this.mcContent._x += _expr[1].value;
							this.mcContent._y += _expr[2].value;
							this.mcContent = this.mcContent.createEmptyMovieClipExt();
							this.mcContent._rotation = _expr[0].value;
							this.mcContent = this.mcContent.createEmptyMovieClipExt();
							this.mcContent._x -= _expr[1].value;
							this.mcContent._y -= _expr[2].value;
						} else {
							this.mcContent._rotation = _expr[0].value;
						}
						break;
					case "skewx":
						var rad = Math.PI / 180;
						var sin45 = Math.sin(45 * rad);
						var ang_x = -_expr[0].value;
						var rang_x = ang_x * rad;
						var parent_mc = this.mcContent;
						this.mcContent = parent_mc.createEmptyMovieClipExt();
						this.mcContent._rotation = -45;
						parent_mc._rotation = ang_x / 2 + 45;
						parent_mc._xscale = 100 * Math.cos(rang_x) / Math.sin((ang_x / 2 + 45) * rad) * sin45;
						parent_mc._yscale = 100 * (Math.sin(rang_x) + 1) / Math.sin((ang_x / 2 + 45) * rad) * sin45;
						break;
					case "skewy":
						var rad = Math.PI / 180;
						var sin45 = Math.sin(45 * rad);
						var ang_y = _expr[0].value;
						var rang_y = ang_y * rad;
						var parent_mc = this.mcContent;
						this.mcContent = parent_mc.createEmptyMovieClipExt();
						this.mcContent._rotation = -45;
						parent_mc._rotation = ang_y / 2 + 45;
						parent_mc._xscale = 100 * (Math.sin(rang_y) + 1) / Math.sin((ang_y / 2 + 45) * rad) * sin45;
						parent_mc._yscale = 100 * Math.cos(rang_y) / Math.sin((ang_y / 2 + 45) * rad) * sin45;
						break;
					case "matrix":
						// todo
						break;
				}
			}
		}
	}
	
	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.create();
		}
		while(_cno = _cno.nextSibling);
	}
}

DENG.CSVGWnd.prototype.size = function()
{
	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.size();
		}
		while(_cno = _cno.nextSibling);
	}
}

DENG.CSVGWnd.prototype.position = null;

DENG.CSVGWnd.prototype.paint = function()
{
	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.paint();
		}
		while(_cno = _cno.nextSibling);
	}
}



