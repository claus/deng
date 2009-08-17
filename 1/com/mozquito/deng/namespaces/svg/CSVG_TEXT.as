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
//   class DENG.CSVG_TEXT
// ===========================================================================================

DENG.CSVG_TEXT = function()
{
	super();
	
	this.cssPropAttr = {
		x: true,
		y: true,
		dx: true,
		dy: true,
		rotate: true,
		textLength: true,
		lengthAdjust: true,
		transform: true
	};
}

DENG.CSVG_TEXT.prototype = new DENG.CSVGWnd();

DENG.CSVG_TEXT.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// initialize default styles
	// this.css.dom.propertyTableAttr.targetname = xxx;
}

DENG.CSVG_TEXT.prototype.create = function()
{
	// create mc
	this.mc = this.mcContent = this.parentNode.mcContent.createEmptyMovieClipExt();
	this.mc.classRef = this.mcContent.classRef = this; // callback to this object

	super.create();

	// subject to change
	this.$tfCreate = true;
	this.tf = this.getTextField().tfRef;
	this.tf._x = this.resolveCssProperty("x") + this.resolveCssProperty("dx");
	this.tf._y = this.resolveCssProperty("y") + this.resolveCssProperty("dy");
	this.tf._alpha = this.resolveCssProperty("opacity") * 100;
	this.tf._visible = true;
	this.tf.multiline = false;
	this.tf.wordWrap = false;

	var _value = this.node.firstChild.nodeValue.split("\015\012").join("\012").split("\015").join("").split("<").join("&lt;").split(">").join("&gt;");

	_level0.__$DENG_TF$__.htmlText = _value.split("&").join("&amp;");
	_value = _level0.__$DENG_TF$__.text;

	var _fs = this.resolveCssProperty("fontstyle");
	var _fw = this.resolveCssProperty("fontweight");
	var _td = this.resolveCssProperty("textdecoration");
	var _tt = this.resolveCssProperty("texttransform");
	var _li = this.resolveCssProperty("link");
	var _col = this.resolveCssPropertyColor("fill");
	if(_col == "currentColor") {
		_col = this.resolveCssPropertyColor("color");
	}
	
	// text transformations
	switch(_tt) {
		case "none":
			break;
		case "uppercase":
		case "capitalize":
			_value = _value.toUpperCase();
			break;
		case "lowercase":
			_value = _value.toLowerCase();
			break;
	}
	if(_fw == "bold") {
		_value = "<b>" + _value + "</b>";
	}
	if(_td == "underline") {
		_value = "<u>" + _value + "</u>";
	}
	if(_fs == "italic") {
		_value = "<i>" + _value + "</i>";
	}
	if(_li != "none") {
		// link is defined
		var _href;
		if(typeof _li == "string") {
			_href = _li;
		} else {
			var _li0 = _li[0];
			if(_li0.type == 100) {
				if(_li0.value == "attr") {
					_href = this.node.parentNode.attributes[_li0.expr[0].value];
					// todo: namespaced elements?
				} else if(_li0.value == "content") {
					_href = this.node.parentNode.firstChild.nodeValue;
					// todo: support elements that contain childnodes
				}
			}
		}
		if(_href != undefined) {
			// register the click handler on the containing block element's wrapper
			var _clhID = this.cbObj.registerClickHandler(
				{
					obj: this,
					uri: new DENG.CUri(_href, this.getBaseUrl()).getAbsolute(),
					targetStyle: this.resolveCssProperty("targetstyle"),
					targetPosition: this.resolveCssProperty("targetposition"),
					targetName: this.resolveCssProperty("targetname")
				}
			);
			// set the a href for the textfield
			_value = '<a href="asfunction:onClickHandler,' + _clhID.toString() + '">' + _value + '</a>';
		}
	}
	
	// get the font family
	var _ff = DENG.$getFont(this.resolveCssProperty("fontfamily"), this.tf, true);
	
	// get the text color
	var _zf = "000000";
	_col = _col.toString(16);
	_col = _zf.substr(_col.length) + _col;

	this.tf.htmlText = "<font"
								+ " face=\"" + _ff.family + "\""
								+ " size=\"" + this.resolveCssProperty("fontsize", _ff.defaultSize) + "\""
								+ " color=\"#" + _col + "\">" + _value + "</font>";
}

DENG.CSVG_TEXT.prototype.position = null;
DENG.CSVG_TEXT.prototype.size = null;
DENG.CSVG_TEXT.prototype.paint = null;

