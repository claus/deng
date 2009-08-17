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
//   class DENG.CElemPseudo_Text
// ===========================================================================================

DENG.CElemPseudo_Text = function() { super(); }

DENG.CElemPseudo_Text.prototype = new DENG.CElemText();

DENG.CElemPseudo_Text.prototype.content = "???";
DENG.CElemPseudo_Text.prototype.cssPseudoClass = "_text";


DENG.CElemPseudo_Text.prototype.getCharacterData = function()
{
	var _p = this.parentNode;
	if(_p.cssPseudoClass == "before" || _p.cssPseudoClass == "after") {
		var _content = _p.resolveCssProperty("content", true);
		var _newContent = "";
		var _contentLength = _content.length;
		for(var _i = 0; _i < _contentLength; _i++) {
			var _term = _content[_i];
			switch(_term.type) {
				case 100:
					// function
					// may be counter(), counters() or attr()
					switch(_term.value) {
						case "attr":
							_newContent += this.node.attributes[_term.expr[0].value];
							break;
						case "counter":
							var _cName = _term.expr[0].value;
							_newContent += this.xmlDomRef.counters[_cName][this.xmlDomRef.counters[_cName].length-1];
							break;
						case "counters":
							_newContent += this.xmlDomRef.counters[_term.expr[0].value].join(_term.expr[1].value);
							break;
					}
					break;
				case 200:
					// string
					if(_term.value == "\n") {
						_newContent += "<br>";
					} else {
						_newContent += _term.value.split("\n").join("<br>");
					}
					break;
				case 201:
					// ident
					switch(_term.value) {
						case "open-quote":
							_newContent += "\"";
							break;
						case "close-quote":
							_newContent += "\"";
							break;
						case "no-open-quote":
							break;
						case "no-close-quote":
							break;
					}
					break;
				case 210:
					// uri
				default:
					break;
			}
		}
		if(_newContent.substr(_newContent.length-4) == "<br>") {
			_newContent += "&nbsp;";
		}
		return _newContent;
	} else {
		return this.content;
	}
}

DENG.CElemPseudo_Text.prototype.position = function()
{
	with(this) {
		if(parentNode.isMarker) {
			tf._x = cbObj.calcContentX - 1;
			tf._y = cbObj.calcContentY - 2;
			return (this.contentHeight = tf.textHeight);
		} else {
			return super.position();
		}
	}
}

DENG.CElemPseudo_Text.prototype.toString = function()
{
	return "<" + this.node.nodeName + "::after/text>";
}

