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
//   XMLNode Prototypes
// ===========================================================================================

XMLNode.prototype.createElementWrapper = function(p)
{
	with(this) {
		if(p == undefined) {
			this._xmlDomCallback = parentNode;
		} else {
			this._xmlDomCallback = parentNode._xmlDomCallback;
		}
		if(nodeType == 3) {
			// text node:
			// create wrapper
			this.obj = new DENG[DENG.$getTextElementWrapperClassName(parentNode.nsUri)]();
			// initialize wrapper
			this.obj.initialize(this, p);
		} else {
			// xml node:
			// get namespaces
			resolveNamespaces();
			// create wrapper
			this.obj = new DENG[DENG.$getElementWrapperClassName(this.nsUri, nsNodeName)]();
			// initialize wrapper
			this.obj.initialize(this, p);
			// create children
			var _cn = firstChild;
			while(_cn) {
				// create child wrapper (recurse)
				// and add to childNodes array
				this.obj.childNodes.push(_cn.createElementWrapper(this.obj));
				// repeat for next sibling
				_cn = _cn.nextSibling;
			}
		}
		return this.obj;
	}
}

XMLNode.prototype.resolveNamespaces = function()
{
	with(this) {
		// loop all attributes
		for(var _attrName in attributes) {
			// if we're dealing with an "xmlns" attribute
			if(_attrName.indexOf("xmlns") == 0) {
				// copy parent node's namespaces
				if(this.$xmlns == undefined && parentNode) {
					var _pns = parentNode.$xmlns;
					this.$xmlns = {};
					for(var j in _pns) {
						this.$xmlns[j] = _pns[j];
					} 
				}
				// get namespace identifier/uri
				var _nsid = _attrName.substr(6);
				var _nsuri = attributes[_attrName];
				if(_nsid == "") {
					// default namespace
					_nsid = "0";
				}
				if(_nsuri == "") {
					// clear ns definition
					mytrace("namespace cleared: " + _nsid, "XMLNode", "resolveNamespaces");
					delete this.$xmlns[_nsid];
				} else {
					mytrace("namespace registered: " + _nsid + " [" + _nsuri + "]", "XMLNode", "resolveNamespaces");
					this.$xmlns[_nsid] = _nsuri;
				}
			}
		}
		// if no namespace definitions were found,
		// copy parent node's namespace definitions
		if(this.$xmlns == undefined) {
			this.$xmlns = parentNode ? parentNode.$xmlns : {};
		}
		// split nodename, get namespace identifier/uri
		var _nn = nodeName.split(":");
		if(_nn[1] != undefined) {
			this.nsIdent = _nn[0];
			this.nsNodeName = _nn[1];
			this.nsUri = $xmlns[nsIdent];
		} else {
			this.nsIdent = "0";
			this.nsNodeName = _nn[0];
			this.nsUri = $xmlns["0"];
		}
	}
}

XMLNode.prototype.getSource = function(level)
{
	var _src = "";
	/*
	var _lvl = (level == undefined) ? 0 : level;
	with(this) {
		if(nodeType == 1) {
			var _children = "";
			var _cn = firstChild;
			while(_cn) {
				_children += _cn.getSource(_lvl+1);
				_cn = _cn.nextSibling;
			}
			var _tfopen = "<textformat blockIndent=\"" + (_lvl*20) + "\"><p><font face=\"_typewriter\" color=\"#0000ff\">";
			var _tfopen1 = "<textformat blockIndent=\"" + ((_lvl+1)*20) + "\"><p><font face=\"_typewriter\" color=\"#0000ff\">";
			var _tfclose = "</font></p></textformat>";
			var _node = ((nsIdent != "0") ?  "<b>"+nsIdent+":</b>" : "") + nsNodeName;
			var _attribs = "";
			for(var i in attributes) {
				_attribs += "&nbsp;<font color=\"#880088\">" + i + "</font>=\"" + attributes[i] + "\"";
			}
			if(_attribs.length) {
				_attribs = "<font color=\"#008800\">" + _attribs + "</font>";
			}
			if(_children.length) {
				if(childNodes.length == 1 && firstChild.nodeType == 3) {
					_src += _tfopen
							+ "&lt;" + _node + _attribs + "&gt;"
							+ _children
							+ "&lt;/" + _node + "&gt;"
							+ _tfclose;
				} else {
					_src += _tfopen
							+ "&lt;" + _node + _attribs + "&gt;"
							+ _tfclose
							+ _tfopen1
							+ _children
							+ _tfclose
							+ _tfopen
							+ "&lt;/" + _node + "&gt;"
							+ _tfclose;
				}
			} else {
				_src += _tfopen
							+ "&lt;" + _node + _attribs + " /&gt;"
							+ _tfclose;
			}
		} else {
			_src = '<font color="#000000">'
					+ nodeValue.trim().split("&").join("&amp;").split("<").join("&amp;lt;").split(">").join("&amp;gt;")
					+ '</font>';
			if(parentNode.childNodes.length > 1) { _src += "<br>"; }
		}
	}
	*/
	return _src;
}


XMLNode.prototype.toStringExt = function(mode)
{
	if(mode === undefined) {
		return this.toString();
	}
	with(this) {
		var _str = "";
		var _cno = childNodes[0];
		if(_cno) {
			do {
				switch(mode) {
					case "characterData":
						if(_cno.nodeType == 3) {
							_str += _cno.nodeValue;
						} else {
							_str += _cno.toStringExt(mode);
						}
						break;
				}
			}
			while(_cno = _cno.nextSibling);
		}
		return _str;
	}
}


XMLNode.prototype.cleanUp = function()
{
	var _cn = firstChild;
	while(_cn) {
		_cn.cleanUp();
		_cn = _cn.nextSibling;
	}
	delete this.obj;
	delete this.$xmlns;
	delete this.nsIdent;
	delete this.nsNodeName;
	delete this.nsUri;
	delete this._xmlDomCallback;
}

ASSetPropFlags(XMLNode.prototype, "createElementWrapper,cleanUp,getSource,toStringExt,resolveNamespaces", 1);

