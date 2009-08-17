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
//   class DENG.CElemText
// ===========================================================================================

DENG.CElemText = function()
{
	super();
}

DENG.CElemText.prototype = new DENG.CWnd();


DENG.CElemText.prototype.getCharacterData = function()
{
	return this.node.nodeValue;
}

DENG.CElemText.prototype.create = function()
{
	this.cbObj = (this.parentNode.isBlockElement || this.parentNode.isMarker) ? this.parentNode : this.parentNode.cbObj;

	// get/create textfield
	var _tfr = this.cbObj.getTextField();
	this.tf = _tfr.tfRef;
	this.tfActive = _tfr.tfActive;
	
	var _value = this.getCharacterData().split("\015\012").join("\012").split("\015").join("").split("<").join("&lt;").split(">").join("&gt;");
	
	var _parentNode = this.parentNode;
	var _fs = _parentNode.resolveCssProperty("fontstyle");
	var _fw = _parentNode.resolveCssProperty("fontweight");
	var _td = _parentNode.resolveCssProperty("textdecoration");
	var _tt = _parentNode.resolveCssProperty("texttransform");
	var _ws = _parentNode.resolveCssProperty("whitespace");
	var _li = _parentNode.resolveCssProperty("link");
	var _col = _parentNode.resolveCssPropertyColor("color");
	//mytrace(_col + " " + _fw);
	
	// whitespace handling
	switch(_ws) {
		case "pre":
			break;
		case "nowrap":
			break;
		default:
			// "normal": condense whitespace
			_level0.__$DENG_TF$__.htmlText = _value.split("&").join("&amp;");
			_value = _level0.__$DENG_TF$__.text;
			// remove first whitespace in a block element
			if(typeof this.tf.htmlTextRaw == "undefined") {
				var c = _value.charAt(0);
				if(c == " " || c == "\015" || c == "\t" || c == "\014") {
					_value = _value.substr(1);
				}
			}
			break;
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
		/*
		case "l33t":
			_value = _value.toLowerCase();
			_value = _value.split("a").join("4").split("e").join("3").split("g").join("6").split("i").join("!");
			_value = _value.split("l").join("1").split("o").join("0").split("s").join("5").split("t").join("7").split("z").join("2");
			break;
		case "blob":
			var _vNew = "";
			var _c;
			var _vLen = _value.length;
			var _blobTransTable = [
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,111,46,176,176,46,
				111,46,176,176,111,46,46,60,46,62,46,64,111,48,48,48,111,48,48,48,
				111,48,48,48,48,48,111,48,48,48,48,111,48,48,48,48,48,46,46,
				46,176,46,176,48,111,111,111,48,111,111,111,48,111,111,111,111,111,48,111,
				111,111,111,111,48,111,111,111,111,111,46,46,46,46,32
			];
			for(var _i = 0; _i < _vLen; _i++) {
				_c = _blobTransTable[_value.charCodeAt(_i)];
				if(_c >= 32) {
					_vNew += String.fromCharCode(_c);
				} else {
					_vNew += "°";
				}
			}
			_value = _vNew;
			break;
		*/
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
			var __tmp = {
				obj: this,
				uri: new DENG.CUri(_href, this.getBaseUrl()).getAbsolute(),
				targetStyle: _parentNode.resolveCssProperty("targetstyle"),
				targetPosition: _parentNode.resolveCssProperty("targetposition"),
				targetName: _parentNode.resolveCssProperty("targetname")
			};
			// register the click handler on the containing block element's wrapper
			var _clhID = this.cbObj.registerClickHandler(__tmp);
			// set the a href for the textfield
			_value = '<a href="asfunction:onClickHandler,' + _clhID.toString() + '">' + _value + '</a>';
		}
	}
	
	// get the font family
	var _ff = DENG.$getFont(_parentNode.resolveCssProperty("fontfamily"), this.tf, this.tfActive);
	
	// get the text color
	var _zf = "000000";
	_col = _col.toString(16);
	_col = _zf.substr(_col.length) + _col;

	this.tf.htmlTextRaw += "<font"
									+ " face=\"" + _ff.family + "\""
									+ " size=\"" + _parentNode.resolveCssProperty("fontsize") + "\""
									+ " color=\"#" + _col + "\">" + _value + "</font>";
}



DENG.CElemText.prototype.size = function()
{
	if(this.tfActive && this.tf.htmlTextRaw != undefined) {
		// get text-align property
		var _ta = this.parentNode.resolveCssProperty("textalign");
		// populate textfield
		// 2004/06/14 cw: 
		// <p> in input fields causes unwanted linefeed
		// so we have to filter input fields here:
		if(this.tf.type == "input") {
			this.tf.htmlText = this.tf.htmlTextRaw;
		} else {
			this.tf.htmlText = '<TEXTFORMAT leading="0"><P align="' + _ta + '">' + this.tf.htmlTextRaw + '</P></TEXTFORMAT>';
		}
		delete this.tf.htmlTextRaw;
	}
}


DENG.CElemText.prototype.position = function()
{
	with(this) {
		if(tfActive) {
			tf._width = cbObj.calcContentWidth;
			tf._x = cbObj.calcContentX - 1;
			tf._y = cbObj.calcContentY + cbObj.flowOffset - 2;
			this.contentHeight = tf.textHeight;
			cbObj.flowOffset += contentHeight;
			//trace("#"+cbObj.flowOffset);
		} else {
			this.contentHeight = 0;
		}
		return contentHeight;
	}
}


DENG.CElemText.prototype.paint = function()
{
	if(this.tfActive) {
		this.tf._visible = true;
	}
}

