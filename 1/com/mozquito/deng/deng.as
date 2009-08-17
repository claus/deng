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

// -------------------------------------------------------------------------------------------
// _global.DENG - default DENG namespace object
// -------------------------------------------------------------------------------------------
// properties:
// $version [int] - version number
// $minor [int] - minor version number
// $build [int] - build number
// $fonts [object] - system fonts lookup table
// $ns [object] - private property, holds references to the namespace objects,
//                associated via uri
// $isWin [boolean] - true if on a Windows os
// $isMac [boolean] - true if on a Macintosh os
// $isLnx [boolean] - true if on a One True Os
// -------------------------------------------------------------------------------------------
_global.DENG = {
	$version: 1, 
	$minor: 0,
	$build: 47,
	$fonts: {},
	$ns: {},
	$nsDelay: {}
};

System.security.allowDomain(_parent._url);
//_level0.debug = "1";

// ===========================================================================================
// ===  Includes                                                                           ===
// ===========================================================================================

// include core prototypes
#include "com/mozquito/deng/protos/protoXML.as"
#include "com/mozquito/deng/protos/protoMovieClip.as"
#include "com/mozquito/deng/protos/protoFunction.as"

// include helpers
#include "com/mozquito/deng/helpers/CUri.as"
#include "com/mozquito/deng/helpers/CQueue.as"

// include css parser
#include "com/mozquito/deng/css/CCss.as"

// include core components
#include "com/mozquito/deng/core/CWnd.as"
#include "com/mozquito/deng/core/CElemText.as"
#include "com/mozquito/deng/core/CDom.as"

#include "com/mozquito/deng/core/wrappers/CTableWrapper.as"

#include "com/mozquito/deng/core/pseudos/CElemPseudo_Text.as"
#include "com/mozquito/deng/core/pseudos/CElemPseudoBefore.as"
#include "com/mozquito/deng/core/pseudos/CElemPseudoAfter.as"


// -------------------------------------------------------------------------------------------
// DENG.$configure
// -------------------------------------------------------------------------------------------
// parameters: none
// -------------------------------------------------------------------------------------------
// returns nothing
// -------------------------------------------------------------------------------------------
DENG.$configure = function()
{
	if(DENG.$isConfigured == undefined || DENG.$isConfigured == false)
	{
		// snoop platform
		var _platform = System.capabilities.version.substr(0,3).toLowerCase();
		var _knownPlatforms = [ "Win", "Lnx", "Mac" ];
		for(var _i in _knownPlatforms) {
			DENG["is"+_knownPlatforms[_i]] = (_platform == _knownPlatforms[_i].toLowerCase());
		}
		
		// initialize screenweaver
		swInterface.init();
		
		// initialize DENG.$fonts 
		// currently crashes on linux with r69 and r79, see also $getFont()
		if (!DENG.isLnx) {
			var _fontList = TextField.getFontList();
			for(var _i in _fontList) {
				DENG.$fonts[_fontList[_i]] = false;
			}
		}

		// create DENG.$tf
		// textfield for whitespace handling in CElemText etc
		if(_level0.__$DENG_TF$__ == undefined) {
			_level0.createTextField("__$DENG_TF$__", 51423, -1000, -1000, 4, 4);
			var _tf = _level0.__$DENG_TF$__;
			_tf._visible = false;
			_tf.condenseWhite = true;
			_tf.html = true;
		}

		// initialize DENG.$baseurl
		DENG.$baseurl = (swApplication.getCmdLineArg(0) != undefined) ? "file://" + swApplication.getCmdLineArg(0) : _url;
		
		// initialize DENG.$basedomain
		var _bu = new DENG.CUri(DENG.$baseurl);
		if(_bu.$scheme != "file") {
			var _baseDomain = _bu.$authority;
			/*
			var __sdif = _baseDomain.indexOf(".");
			var __sdil = _baseDomain.lastIndexOf(".");
			while(__sdif != __sdil) {
				_baseDomain = _baseDomain.substr(__sdif + 1);
				__sdif = _baseDomain.indexOf(".");
				__sdil = _baseDomain.lastIndexOf(".");
			}
			*/
			DENG.$basedomain = _baseDomain.toLowerCase();
		}
		
		// done configuring
		DENG.$isConfigured = true;
	}
}

DENG.$configure();


DENG.CSS_FONT_GENERIC = { serif: "_serif", cursive: "_sans", fantasy: "_sans", monospace: "_typewriter" };
DENG.CSS_FONT_GENERIC["sans-serif"] = "_sans";


// ===========================================================================================
// ===  private methods                                                                    ===
// ===========================================================================================


// -------------------------------------------------------------------------------------------
// DENG.$getFont
// -------------------------------------------------------------------------------------------
// parameters:
// value [object] - font-family property value
// -------------------------------------------------------------------------------------------
// returns [string] - name of matching font
// -------------------------------------------------------------------------------------------
DENG.$getFont = function(value, tf, tfActive)
{
	if(typeof value != "string") {
		var _fn;
		var _family = "_sans"
		var _embedded = false;
		var _defaultSize = -1;
		var _i = 0;
		var _vl = value.length;
		while(_i < _vl) {
			_fn = value[_i].value;
			while(value[_i++].operator == 1) {
				_fn += " " + value[_i].value;
			}
			var _fng = DENG.CSS_FONT_GENERIC[_fn];
			if(_fng != undefined) {
				_family = _fng;
				break;
			}
			if (!DENG.isLnx) {
			    // default code, currently OK on all platforms but linux
				var _fe = DENG.$fonts[_fn];
				if(_fe != undefined) {
					_family = _fn;
					_embedded = (_fe != 0);
					_defaultSize = _fe;
					break;
				}
			} else {
				// linux-only workaround until MM fixes the TextField.getFontList() bug
				_family = _fn;
				_embedded = false;
				// the first one always matches!!
				break;
			}
		}
	} else {
		var _fng = DENG.CSS_FONT_GENERIC[value];
		if(_fng != undefined) {
			_family = _fng;
		}
		if (!DENG.isLnx) {
			// default code, currently OK on all platforms but linux
			var _fe = DENG.$fonts[value];
			if(_fe != undefined) {
				_family = value;
				_embedded = (_fe != 0);
				_defaultSize = _fe;
			}
		} else {
			// linux-only workaround until MM fixes the TextField.getFontList() bug
			_family = value;
			_embedded = false;
		}
	}
	if(tfActive) {
		if(tf.embedFonts = _embedded) {
			tf.$embedFontFamily = _family;
		}
	} else {
		if(tf.embedFonts ^ _embedded) {
			if(_embedded = tf.embedFonts) {
				_family = tf.$embedFontFamily;
			}
		}
	}
	return { family: _family, defaultSize: (_defaultSize > 0) ? _defaultSize : undefined };
}


// -------------------------------------------------------------------------------------------
// DENG.$registerNamespace
// -------------------------------------------------------------------------------------------
// parameters:
// id [string] - namespace identifier, eg. "XForms"
// uri [string] - namespace uri, eg. "http://www.w3.org/2002/xforms/cr"
// version [float] - required deng version, eg. 1.0
// -------------------------------------------------------------------------------------------
// returns nothing
// -------------------------------------------------------------------------------------------
DENG.$registerNamespace = function(id, uri, version)
{
	if(version > DENG.$version) {
		mytrace("versions do not match (DENG: " + DENG.$version + ", " + id + ": " + version + ")", "DENG", "$registerNamespace", 2);
	}
	//mytrace(id + " [" + uri + "]", "DENG", "$registerNamespace");
	DENG.$ns[uri] = id;
}


// -------------------------------------------------------------------------------------------
// DENG.$setRenderDelay
// -------------------------------------------------------------------------------------------
// parameters:
// id [string] - namespace identifier, eg. "XForms"
// delay [int] - delay in ms (0: no delay)
// -------------------------------------------------------------------------------------------
// returns nothing
// -------------------------------------------------------------------------------------------
DENG.$setRenderDelay = function(id, delay)
{
	//mytrace(id, "DENG", "$setRenderDelay");
	for(var i in DENG.$ns) {
		if(DENG.$ns[i] == id) {
			DENG.$nsDelay[i] = delay;
			break;
		}
	}
}


// -------------------------------------------------------------------------------------------
// DENG.$addDefaultStylesheet
// -------------------------------------------------------------------------------------------
// parameters:
// id [string] - namespace identifier, eg. "XForms"
// css [string] - the stylesheet
// -------------------------------------------------------------------------------------------
// returns nothing
// -------------------------------------------------------------------------------------------
DENG.$addDefaultStylesheet = function(id, css)
{
	//mytrace(id, "DENG", "$addDefaultStylesheet");
	if(!DENG.$nsDefaultCSS) {
		DENG.$nsDefaultCSS = {};
	}
	if(!DENG.$nsDefaultCSS[id]) {
		DENG.$nsDefaultCSS[id] = { delay: 30 };
	}
	DENG.$nsDefaultCSS[id].active = false;
	DENG.$nsDefaultCSS[id].css = css;
}


// -------------------------------------------------------------------------------------------
// DENG.$getElementWrapperClassName
// determines the name of the element wrapper class for the provided node name and 
// namespace uri. if such a class is undefined, default to "DENG.CElem"
// -------------------------------------------------------------------------------------------
// parameters:
// nsUri [string] - namespace uri, eg. "http://www.w3.org/2002/xforms/cr"
// nsNodeName [string] - node name, eg. "repeat"
// -------------------------------------------------------------------------------------------
// returns [string] - name of the class
// -------------------------------------------------------------------------------------------
DENG.$getElementWrapperClassName = function(nsUri, nsNodeName)
{
	var _className = "C" + DENG.$ns[nsUri] + "_" + nsNodeName.toUpperCase();
	if(typeof DENG[_className] == "function") {
		return _className;
	}
	_className = "C" + DENG.$ns[nsUri] + "Wnd";
	if(typeof DENG[_className] == "function") {
		return _className;
	}
	return "CWnd";
}


// -------------------------------------------------------------------------------------------
// DENG.$getTextElementWrapperClassName
// determines the name of the wrapper class for anonymous text elements
// if such a class is undefined, default to "DENG.CElemText"
// -------------------------------------------------------------------------------------------
// parameter:
// nsUri [string] - namespace uri, eg. "http://www.w3.org/2002/xforms/cr"
// -------------------------------------------------------------------------------------------
// returns [string] - name of the class
// -------------------------------------------------------------------------------------------
DENG.$getTextElementWrapperClassName = function(nsUri)
{
	var _className = "C" + DENG.$ns[nsUri] + "ElemText";
	if(typeof DENG[_className] == "function") {
		return _className;
	}
	return "CElemText";
}


// -------------------------------------------------------------------------------------------
// DENG.$getCssPropertiesClassName
// determines the name of the css-properties class for the provided namespace uri. 
// if such a class is undefined, default to "DENG.CCssProperties"
// -------------------------------------------------------------------------------------------
// parameters:
// nsNodeName [string] - node name, eg. "repeat"
// nsUri [string] - namespace uri, eg. "http://www.w3.org/2002/xforms/cr"
// -------------------------------------------------------------------------------------------
// returns [string] - name of the class
// -------------------------------------------------------------------------------------------
DENG.$getCssPropertiesClassName = function(nsUri)
{
	var _nsIdent = DENG.$ns[nsUri];
	var _className = "C" + _nsIdent + "CssProperties";
	DENG.$nsDefaultCSS[_nsIdent].active = true;
	if(typeof DENG[_className] == "function") {
		return _className;
	}
	return "CCssProperties";
}






// ===========================================================================================
//   Debugging stuff
// ===========================================================================================
/*
_global.mytraceAllow = { init:1,DENG:1,XMLNode:1,CWnd:1,CTableWrapper:1,CDom:1,CCss:1,CCssParser:1,CCssProperties:1,CElem:1,CXHTML:1,CXForms:1 };
_global.mytrace = function(t, x, m, c) {
	if(_level0.debug == "1" || _level0.ugodebug == "1") {
		var tx = "";
		var txplain = "";
		var colon = (t == "") ? " " : ": ";
		if(m == undefined) { m = ""; } else { m = "." + m; }
		if(_level0.ugodebug == "1") {
			var ts, ts2, ts3 = "";
			var te = "";
		} else {
			var ts1 = "<font color=\"#ff0000\">ERROR: ";
			var ts2 = "<font color=\"#0000ff\">WARNING: ";
			var ts3 = "<font color=\"#555555\">";
			var te = "</font>";
		}
		if(mytraceAllow[x] == 1) {
			switch(c) {
				case 1:
					tx = x + m + colon + ts1 + t + te; 
					txplain = x + m + colon + "ERROR: " + t;
					break;
				case 2:
					tx = x + m + colon + ts2 + t + te;
					txplain = x + m + colon + "WARNING: " + t;
					break;
				default:
					tx = x + m + colon + ts3 + t + te;
					txplain = x + m + colon + t;
					break;
			}
		} else {
			tx = t;
		}
		if(tx != "") {
			trace(txplain);
			if (typeof(com.codeazur.ugo.debug) != "undefined") {
				com.codeazur.ugo.debug.writeln(tx);
			} else if (typeof(_level0.ugodebug) != "undefined" && _level0.ugodebug == "1") {
				getURL("javascript:com.codeazur.ugo.debug.writeln('" +tx +"')");
			} else {
				_level0.deb_txt.htmlText += "<textformat leading=\"1\"><p><font face=\"_sans\">" + tx + "</font></p></textformat>";
				_level0.deb_txt.scroll = _level0.deb_txt.maxscroll;
			}
		}
	}
}

_global.traceDeclaration = function(_decl)
{
	var s = _decl.property + " ";
	var _de = _decl.expr;
	var _del = _de.length;
	for(var i = 0; i < _del; i++) {
		s += traceExpression(_de[i]);
	}
	return s;
}

_global.traceSelector = function(_sel)
{
	var s = "[" + _sel.specificity;
	if(_sel.hasPseudoElements) { 	s += "/PE"; }
	if(_sel.hasPseudoClasses) { 	s += "/PC"; }
	s += "] ";
	if(_sel.simpleselectors) {
		var _sl = _sel.simpleselectors.length;
		for(var i = 0; i < _sl; i++) {
			var _ss = _sel.simpleselectors[i];
			var _comb = _ss.combinator;
			s += traceSimpleSelector(_ss.simpleselector) + ((_comb != " ") ? " "+_comb+" " : " ");
		}
	}
	return s + traceSimpleSelector(_sel.root);
}

_global.traceSimpleSelector = function(_ss)
{
	var s = "";
	var _ssl = _ss.length;
	for(var j = 0; j < _ssl; j++) {
		var _sso = _ss[j];
		switch(_sso.type) {
			case 0: s += _sso.name; break;
			case 1: s += _sso.prefix + "|" + _sso.name; break;
			case 10: s += "." + _sso.class; break;
			case 11: 
				s += "[" + ((_sso.prefix != null) ? _sso.prefix + "|" : "") + _sso.name;
				switch(_sso.operator) {
					case 0: s += "]"; break;
					case 1: s += "=\"" + _sso.expr + "\"]"; break;
					case 2: s += "~=\"" + _sso.expr + "\"]"; break;
					case 3: s += "|=\"" + _sso.expr + "\"]"; break;
					case 4: s += "^=\"" + _sso.expr + "\"]"; break;
					case 5: s += "$=\"" + _sso.expr + "\"]"; break;
					case 6: s += "*=\"" + _sso.expr + "\"]"; break;
				}
				break;
			case 12: 
				s += ":" + _sso.name;
				if(_sso.farg) {
					s += "(" + ((typeof _sso.farg == "object") ? traceSimpleSelector(_sso.farg) : _sso.farg) + ")";
				}
				break;
			case 13: s += "#" + _sso.id; break;
			case 20: s += "::" + _sso.name + ((_sso.farg) ? "(" + _sso.farg + ")" : ""); break;
			default: s += "???"; break;
		}
	}
	return s;
}

_global.traceExpression = function(_expr)
{
	var s;
	var op = " ";
	switch(_expr.operator) {
		case 2: op = "/"; break;
		case 3: op = ", "; break;
	}
	switch(_expr.type) {
		case 0: s = _expr.value + "() [handler]"; break;
		case 1: s = _expr.value + " [num]"; break;
		case 5: s = _expr.value + " [percent]"; break;
		case 10: s = _expr.value + " [px]"; break;
		case 11: s = _expr.value + " [cm]"; break;
		case 12: s = _expr.value + " [mm]"; break;
		case 13: s = _expr.value + " [in]"; break;
		case 14: s = _expr.value + " [pt]"; break;
		case 15: s = _expr.value + " [pc]"; break;
		case 20: s = _expr.value + " [ems]"; break;
		case 25: s = _expr.value + " [exs]"; break;
		case 30: s = _expr.value + " [deg]"; break;
		case 31: s = _expr.value + " [rad]"; break;
		case 32: s = _expr.value + " [grad]"; break;
		case 40: s = _expr.value + " [s]"; break;
		case 41: s = _expr.value + " [ms]"; break;
		case 50: s = _expr.value + " [khz]"; break;
		case 51: s = _expr.value + " [hz]"; break;
		case 60: s = _expr.value + " [\"" + _expr.dimen + "\"]"; break;
		case 100: s = _expr.value + " [function]"; break;
		case 200: s = "\"" + _expr.value + "\" [string]"; break;
		case 201: s = "\"" + _expr.value + "\" [ident]"; break;
		case 210: s = "\"" + _expr.value + "\" [uri]"; break;
		case 300: s = "0x" + _expr.value.toString(16) + " [color]"; break;
		case 400: s = _expr.value + " [unicoderange]"; break;
		default: s = "???"; break;
	}
	return s + op;
}
*/
