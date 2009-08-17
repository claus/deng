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
//   class DENG.CUri
// ===========================================================================================

DENG.CUri = function(uri, baseuri)
{
	this.baseuri = baseuri;
	var _uri = uri.split(String.fromCharCode(92)).join("/");
	if(_uri.indexOf(":/") == 1) {
		_uri = "file:///" + _uri.charAt(0) + "|" + _uri.substr(2);
	}
	super(_uri);
	this.parse();
}

DENG.CUri.prototype = new String();

DENG.CUri.prototype.getAbsolute = function(query, fragment)
{
	var r = "";
	var _pathSplitTmp = [];
	var _psl = this.$pathSplit.length;
	for(var i = 0; i < _psl; i++) {
		var _p = this.$pathSplit[i];
		switch(_p) {
			case ".": break;
			case "..": _pathSplitTmp.pop(); break;
			default: _pathSplitTmp.push(_p); break;
		}
	}
	if(this.$scheme != undefined) { r += this.$scheme + "://"; }
	r += this.$authority + _pathSplitTmp.join("/") + this.$filename;
	if(this.$querySplit != undefined && (query == undefined || query === true)) { r += "?" + this.$querySplit; }
	if(this.$fragment != undefined && (fragment == undefined || fragment === true)) { r += "#" + this.$fragment; }
	return r;
}

DENG.CUri.prototype.getRelative = function(query, fragment)
{
	var _pathSplitTmp = [];
	var _psl = this.$pathSplit.length;
	for(var i = 0; i < _psl; i++) {
		var _p = this.$pathSplit[i];
		switch(_p) {
			case ".": break;
			case "..": _pathSplitTmp.pop(); break;
			default: _pathSplitTmp.push(_p); break;
		}
	}
	var r = _pathSplitTmp.join("/") + this.$filename;
	if(this.$querySplit != undefined && (query == undefined || query === true)) { r += "?" + this.$querySplit; }
	if(this.$fragment != undefined && (fragment == undefined || fragment === true)) { r += "#" + this.$fragment; }
	return r;
}

DENG.CUri.prototype.addQueryVar = function(varName, varValue)
{
	if(this.$querySplit == undefined) {
		this.$querySplit = new LoadVars();
	}
	this.$querySplit[varName] = varValue;
}

DENG.CUri.prototype.parse = function()
{
	var r = true;
	this.$isRelative = false;
	if(this == undefined) {
		r = false;
	} else {
		var _iP = this.indexOf("://");
		if(_iP != -1) {
			// protocol defined: absolute url
			this.$scheme = this.substr(0, _iP);
			var _iD = this.indexOf("/", _iP+3);
			/*
			if(_iD == -1) {
				_iD = this.indexOf("?", _iP+3);
				if(_iD == -1) {
					_iD = this.indexOf("#", _iP+3);
				}
			}
			*/
			if(_iD != -1) {
				this.$authority = this.substring(_iP+3, _iD);
				var _iF = this.lastIndexOf("/");
				if(_iF != -1 && _iF > iD) {
					this.$path = this.substring(_iD, _iF+1);
					if(this.$path.charAt(2) == "|" && this.$authority == "") {
						this.$authority = this.$path.substring(0,3);
						this.$path = this.$path.substring(3);
					}
					this.$filename = this.substring(_iF+1);
				} else {
					this.$path = "/";
					this.$filename = this.substring(_iD+1);
				}
			} else {
				this.$authority = this.substring(_iP+3);
			}
		} else {
			this.$isRelative = true;
			// no protocol defined: relative url
			var _u = new DENG.CUri((this.baseuri != undefined) ? this.baseuri : DENG.$baseurl);
			this.$scheme = _u.$scheme;
			this.$authority = _u.$authority;
			if(this.charAt(0) == "#") {
				this.$path = _u.$path;
				this.$filename = _u.$filename + this;
			} else {
				var _iF = this.lastIndexOf("/");
				if(_iF != -1) {
					if(this.charAt(0) == "/") {
						this.$path = this.substring(0, _iF+1);
						this.$filename = this.substring(_iF+1);
					} else {
						this.$path = _u.$path + this.substring(0, _iF+1);
						this.$filename = this.substring(_iF+1);
					}
				} else {
					this.$path = _u.$path;
					this.$filename = this;
				}
				if(this.$path.charAt(0) != "/") {
					this.$path = "/" + this.$path;
				}
			}
		}
		var _iQ = this.$filename.indexOf("?");
		if(_iQ != -1) {
			this.$query = this.$filename.substring(_iQ+1);
			var _iF = this.$query.lastIndexOf("#");
			if(_iF != -1) {
				this.$fragment = this.$query.substring(_iF+1);
				this.$query = this.$query.substring(0, _iF);
			}
			this.$filename = this.$filename.substring(0, _iQ);
		} else {
			var _iF = this.$filename.lastIndexOf("#");
			if(_iF != -1) {
				this.$fragment = this.$filename.substring(_iF+1);
				this.$filename = this.$filename.substring(0, _iF);
			}
		}
		if(this.$query != undefined) {
			this.$querySplit = new LoadVars();
			this.$querySplit.decode("&" + this.$query);
		}
		this.$pathSplit = this.$path.split("/");
	}
	return r;
}

DENG.CUri.prototype.getLocator = function()
{
	if(DENG.$basedomain == undefined) {
		return this.getAbsolute();
	} else {
		return this.getAbsolute();
		/*
		var _d = this.$authority;
		if(_d.substr(_d.length - DENG.$basedomain.length).toLowerCase() == DENG.$basedomain && DENG.$forceProxy != true) {
			return this.getAbsolute();
		} else if(DENG.$redirecturl != undefined && DENG.$redirecturl != "") {
			// use proxy script to load external documents
			// clear the caching variable "c" if present
			var _c;
			if(this.$querySplit != undefined) {
				_c = this.$querySplit.c;
				delete this.$querySplit.c;
				if(this.$querySplit.toString() == "") {
					delete this.$querySplit;
				}
			}
			var _docurl = this.getAbsolute();
			if(_c != undefined && _c != "") {
				this.$querySplit.c = _c;
			}
			return DENG.$redirecturl + escape(_docurl);
		} else {
		    // no $redirecturl specified
			return null;
		}
		*/
	}
};

DENG.CUri.prototype.isBaseUrl = function()
{
	return this.getAbsolute(true, false) == this.baseuri;
}

DENG.CUri.prototype.toString = function()
{
	var deb = "--------\n";
	deb += "url: " + this + newline;
	deb += "isRelative: " + this.$isRelative + newline;
	deb += "scheme: " + this.$scheme + newline;
	deb += "authority: " + this.$authority + newline;
	deb += "path: " + this.$path + newline;
	deb += "pathSplit: " + this.$pathSplit.toString() + newline;
	deb += "filename: " + this.$filename + newline;
	deb += "query: " + this.$query + newline;
	deb += "querySplit: " + this.$querySplit + newline;
	deb += "fragment: " + this.$fragment + newline;
	deb += "absolute url: " + this.getAbsolute() + newline;
	deb += "relative url: " + this.getRelative() + newline;
	return deb;
}


