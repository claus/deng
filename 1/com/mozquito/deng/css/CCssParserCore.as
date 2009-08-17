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
//   class DENG.CCssParserCore
// ===========================================================================================

DENG.CCssParserCore = function(src)
{
	this.a = src.split("\012");
	this.p = this.i = 0;
	this.eof = false;
	this.report = [];

	// initialize substring length array:
	this.b = [];
	for(var i in this.a) {
		this.b[i] = this.a[i].length;
	}
}


DENG.CCssParserCore.prototype.getChar = function()
{
	return this.eof ? undefined : this.a[this.i].charAt(this.p);
}


DENG.CCssParserCore.prototype.getCharCode = function()
{
	return this.eof ? undefined : this.a[this.i].charCodeAt(this.p);
}


DENG.CCssParserCore.prototype.checkChar = function(c)
{
	with(this) {
		if(eof) {
			return false;
		} else {
			if(a[i].charCodeAt(p) == c) {
				if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
				return true;
			} else {
				return false;
			}
		}
	}
}


DENG.CCssParserCore.prototype.skipWhite = function()
{
	with(this) {
		// check for eof
		if(eof) { return; }
		// while char is whitespace
		while(b[i] == 0 || DENG._iss[a[i].charCodeAt(p)]) {
			// skip one char
			if(++p >= b[i]) { /* newline */ p = 0; if(++i == a.length) { this.eof = true; break; } }
		}
	}
}


DENG.CCssParserCore.prototype.skipWhiteAndComments = function()
{
	with(this) {
		// check for eof
		if(eof) { return false; }
		var _c, _p, _i;
		// while char is whitespace or "/"
		while(DENG._issc[_c = a[i].charCodeAt(p)] || b[i] == 0) {
			// skip to next char
			if(++p >= b[i]) {
				// newline
				if(_c == 0x2f) {
					// we found a "/" followed by a newline
					// reset p
					p--;
					// and we're done
					return;
				} else {
					p = 0; 
					if(++i == a.length) { eof = true; return; }
				}
			} else {
				// no linefeed, check for "/*"
				if(_c == 0x2f) {
					if(a[i].charCodeAt(p) == 0x2a) {
						// start of comment found "/*"
						// skip to next char
						if(++p >= b[i]) { p = 0; if(++i == a.length) { eof = true; return; } }
						// now search for matching "*/"
						var _pn;
						while((_pn = a[i].indexOf("*/", p)) < 0) {
							if(++i == a.length) { eof = true; return; }
							p = 0;
						}
						p = _pn + 2;
						if(p >= b[i]) { p = 0; if(++i == a.length) { eof = true; return; } }
					} else {
						// reset p
						p--;
						// and we're done (we found "/")
						return;
					}
				} else if(_c == 0x3c) {
					// "<" found, check for CDO ("<!--")
					if(a[i].indexOf("!--", p) != p) {
						return;
					} else {
						p += 3;
						if(p >= b[i]) { p = 0; if(++i == a.length) { eof = true; } }
					}
				} else if(_c == 0x2d) {
					// "-" found, check for CDC ("-->")
					if(a[i].indexOf("->", p) != p) {
						return;
					} else {
						p += 2;
						if(p >= b[i]) { p = 0; if(++i == a.length) { eof = true; } }
					}
				}
			}
		}
	}
}


DENG.CCssParserCore.prototype.skipRuleSet = function(bInsideDeclarations)
{
	with(this) {
		var c;
		var _p;
		var _ec = []; 
		_ec[0x7b]=true; 
		if(bInsideDeclarations == undefined || bInsideDeclarations == false) { _ec[0x3b]=true; }
		_ec[0x7d]=true;
		var _parenthesisLevel = 1;
		// check for eof
		if(eof) { return false; }
		// loop until either "{", "}" or ";" is found
		while(!_ec[(c = a[i].charCodeAt(p))]) {
			// skip one char
			if(++p >= b[i]) {
				// linefeed
				_p = p;
				p = 0;
				if(++i == a.length) {
					// eof
					eof = true;
					// report warning: eof after escape char 
					report.push({ type:0, code:0, line:i-1, position:_p });
					return false;
				}
			}
			if(c == 0x5c) {
				// skip the backslash
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
				// get escaped char (add escaped crlf)
				getEscapedChar(false);
			}
		}
		if(c == 0x3b) {
			// ";" found: skip this char, and we're done
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; } }
		} else if(c == 0x7d) {
			// "}" found: skip this char, and we're done
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; } }
		} else if(c == 0x7b) {
			// "{" found: skip this char, and search for matching "}"
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
			// loop until "}" is found
			while(!eof) {
				c = a[i].charCodeAt(p);
				// skip one char
				if(++p >= b[i]) {
					// linefeed
					_p = p;
					p = 0;
					if(++i == a.length) {
						// eof
						eof = true;
						// report warning: eof after escape char 
						report.push({ type:0, code:0, line:i-1, position:_p });
						return false;
					}
				}
				if(c == 0x7b) {
					_parenthesisLevel++;
				} else if(c == 0x7d) {
					if(--_parenthesisLevel == 0) {
						break;
					}
				} else if(c == 0x5c) {
					// get escaped char (add escaped crlf)
					getEscapedChar(false);
				}
			}
		}
		return true;
	}
}


DENG.CCssParserCore.prototype.skipDeclaration = function()
{
	with(this) {
		var _c;
		// check for eof
		if(eof) { return false; }
		// loop until ";" is found
		while((_c = a[i].charCodeAt(p)) != 0x3b && _c != 0x7d) {
			// skip one char
			if(++p >= b[i]) {
				// linefeed
				if(++i == a.length) {
					// eof
					eof = true;
					// report warning: eof after escape char 
					report.push({ type:0, code:0, line:i-1, position:p });
					return false;
				}
				p = 0;
			}
			if(_c == 0x5c) {
				// skip the backslash
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
				// get escaped char (add escaped crlf)
				getEscapedChar(false);
			}
		}
		return true;
	}
}


// atrule: @<ident>
DENG.CCssParserCore.prototype.getAtSym = function()
{
	with(this) {
		// check for eof
		if(eof) { return false; }
		// check for "@"
		if(a[i].charCodeAt(p) == 0x40) {
			// skip one char
			if(++p == b[i]) {
				// linefeed
				var _p = p-1;
				p = 0;
				// check end of file condition
				eof = (++i == a.length);
				// report warning: linefeed after @
				report.push({ type:CSS_REPORT_TYPE_WARNING, code:CSS_REPORT_CODE_UNEXPECTED_CRLF, module:"CCssParserCore", method:"getAtSym", line:i-1, position:_p });
				// skip it and return false
				skipRuleSet();
				return false;
			}
			// get atrule identifier
			var _p = p;
			var _i = i;
			if(getIdent()) {
				return true;
			} else {
				// report warning: illegal atrule
				report.push({ type:CSS_REPORT_TYPE_WARNING, code:CSS_REPORT_CODE_ILLEGAL_ATSYM, module:"CCssParserCore", method:"getAtSym", line:i-1, position:_p });
				skipRuleSet();
				return false;
			}
		} else {
			return false;
		}
	}
}


// num: [0-9]+ | [0-9]* "." [0-9]+
DENG.CCssParserCore.prototype.getNum = function()
{
	this.s = "";
	with(this) {
		var c;
		// check for eof
		if(eof) { return false; }
		var _i = i;
		var _p = p;
		while(DENG._isnum[c = a[i].charCodeAt(p)]) {
			s += String.fromCharCode(c);
			// skip one char
			if(++p == b[i]) {
				// linefeed 
				p = 0;
				if(++i == a.length) { eof = true; }
				return (s != "");
			}
		}
		if(c == 0x2e) {
			// "." detected:
			// get fractional part
			// skip the "."
			if(++p == b[i]) {
				// linefeed 
				// this is no number, this is just a "."
				// reset indices and return false
				p = _p; i = _i;
				return false;
			}
			s += ".";
			var _hasFract = false;
			while(DENG._isnum[c = a[i].charCodeAt(p)]) {
				_hasFract = true;
				s += String.fromCharCode(c);
				// skip one char
				if(++p == b[i]) {
					// linefeed 
					p = 0; i++;
					if(++i == a.length) { eof = true; }
					break;
				}
			}
			if(!_hasFract) {
				if(s == ".") {
					// this is no number, this is just a "."
					// reset indices and return null
					p = _p; i = _i;
					eof = false;
					return false;
				} else {
					// report warning: fractional part missing after "."
					report.push({ type:CSS_REPORT_TYPE_WARNING, code:CSS_REPORT_CODE_MISSING_FRACT, module:"CCssParserCore", method:"getNum", line:_i, position:_p });
					return false;
				}
			}
		}
		return (s != "");
	}
}


// "url(" {w} {string} {w} ")"
// "url(" {w} {url} {w} ")"
DENG.CCssParserCore.prototype.getUri = function()
{
	this.s = "";
	with(this) {
		// check for eof
		if(eof) { return false; }
		// check for "url("
		if(a[i].substr(p,4) == "url(") {
			p += 4;
			if(p == b[i]) {
				// linefeed 
				p = 0;
				if(++i == a.length) { 
					eof = true;
					// report error: eof after "url("
					return false;
				}
			}
			skipWhite();
			if(getString() || getUrl()) {
				if(a[i].charCodeAt(p) == 0x29) {
					// skip one char
					if(++p == b[i]) {	/* linefeed */ p = 0; if(++i == a.length) { eof = true; } }
					return true;
				} else {
					// report error: ")" expected
					return false;
				}
			}
		}
		return false;
	}
}


// url:      ([!#$%&*-~] | {nonascii} | {escape})*
// nonascii: [^\0-\177]
// escape:   {unicode} | \\[ -~\200-\4177777]
// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
DENG.CCssParserCore.prototype.getUrl = function()
{
	this.s = "";
	with(this) {
		var c;
		// check for eof
		if(eof) { return false; }
		while(DENG._isurl[c = a[i].charCodeAt(p)] || c == 0x5c) {
			if(c != 0x5c) {
				// char was not escaped
				s += String.fromCharCode(c);
				// skip one char
				if(++p == b[i]) {
					// linefeed 
					p = 0;
					if(++i == a.length) { eof = true; }
					return true;
				}
			} else {
				// skip one char
				if(++p == b[i]) {
					// linefeed
					var _p = p;
					p = 0;
					if(++i == a.length) {
						// eof
						eof = true;
						// report warning: eof after escape char 
						report.push({ type:0, code:0, line:i-1, position:_p });
						return false;
					}
				}
				// get escaped char (add escaped crlf)
				s += getEscapedChar(false);
			}
		}
		return (s != "");
	}
}


// string:   {string1} | {string2}
// string1:  \"([\t !#$%&(-~] | \\{nl} | \’ | {nonascii} | {escape})*\"
// string2:  \’([\t !#$%&(-~] | \\{nl} | \" | {nonascii} | {escape})*\’
// nonascii: [^\0-\177]
// escape:   {unicode} | \\[ -~\200-\4177777]
// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
DENG.CCssParserCore.prototype.getString = function()
{
	this.s = "";
	with(this) {
		// check for eof
		if(eof) { return false; }
		// is first char a single/double quote?
		var _quote = DENG._isquote[a[i].charCodeAt(p)];
		if(_quote) {
			// skip it
			if(++p == b[i]) {
				// linefeed
				// report warning: string not terminated
				report.push({ type:0, code:0, line:i, position:p });
				p = 0;
				if(++i == a.length) { eof = true; }
				return false;
			}
			var c;
			var _allowedQuote = (_quote == 1) ? 0x27 : 0x22;
			while(DENG._isstring[c = a[i].charCodeAt(p)] || c == _allowedQuote || c == 0x5c) {
				if(c != 0x5c) {
					// char was not escaped
					s += String.fromCharCode(c);
					// skip one char
					if(++p == b[i]) {
						// linefeed 
						// report warning: string not terminated
						report.push({ type:0, code:0, line:i, position:p });
						p = 0;
						if(++i == a.length) { eof = true; }
						return false;
					}
				} else {
					// skip one char
					if(++p == b[i]) {
						// linefeed
						var _p = p;
						p = 0;
						if(++i == a.length) {
							// eof
							eof = true;
							// report warning: string not terminated
							report.push({ type:0, code:0, line:i-1, position:_p });
							break;
						}
					}
					// get escaped char (omit escaped crlf)
					s += getEscapedChar(true);
				}
			}
			if(eof) {
				// report warning: string not terminated, eof
				report.push({ type:0, code:0, line:i-1, position:b[i-1] });
				return false;
			} else if(DENG._isquote[a[i].charCodeAt(p)] == _quote) {
				// correct quote found: skip it
				if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
				return true;
			} else {
				// report warning: string not terminated, illegal char in string
				report.push({ type:0, code:0, line:i, position:p });
				return false;
			}
		} else {
			return false;
		}
	}
}


// ident:    {nmstart}{nmchar}*
// nmstart:  [_a-zA-Z] | {nonascii} | {escape}
// nmchar:   [_a-zA-Z0-9-] | {nonascii} | {escape}
// nonascii: [^\0-\177]
// escape:   {unicode} | \\[ -~\200-\4177777]
// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
DENG.CCssParserCore.prototype.getIdent = function()
{
	this.s = "";
	with(this) {
		// check for eof
		if(eof) { return false; }
		// get first char
		var c = a[i].charCodeAt(p);
		// does it match nmstart?
		if(DENG._isnmstart[c]) {
			this.s = String.fromCharCode(c);
			// skip one char
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; }; return false; }
		} else if(c == 0x5c) {
			// this char is escaped
			// skip the backslash
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
			// get the escaped character (add escaped crlf)
			this.s = getEscapedChar(false);
		} else {
			return false;
		}
		while(DENG._isnmchar[c = a[i].charCodeAt(p)] || c == 0x5c) {
			if(c != 0x5c) {
				// char was not escaped
				this.s += String.fromCharCode(c);
				// skip one char
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
			} else {
				// skip one char
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
				// get escaped char (add escaped crlf)
				this.s += getEscapedChar(false);
			}
		}
		return true;
	}
}


// name:     {nmchar}+
// nmchar:   [_a-zA-Z0-9-] | {nonascii} | {escape}
// nonascii: [^\0-\177]
// escape:   {unicode} | \\[ -~\200-\4177777]
// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
DENG.CCssParserCore.prototype.getName = function()
{
	this.s = "";
	with(this) {
		// check for eof
		if(eof) { return false; }
		var c;
		while(DENG._isnmchar[c = a[i].charCodeAt(p)] || c == 0x5c) {
			if(c != 0x5c) {
				// char was not escaped
				s += String.fromCharCode(c);
				// skip one char
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
			} else {
				// skip one char
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
				// get escaped char (add escaped crlf)
				s += getEscapedChar(false);
			}
		}
		return (s.length > 0);
	}
}


// element_name: {ident} | '*'
// identical to getIdent except for the parts marked with "!!!"
DENG.CCssParserCore.prototype.getElementName = function()
{
	this.s = "";
	with(this) {
		// check for eof
		if(eof) { return false; }
		// get first char
		var c = a[i].charCodeAt(p);
		if(c == 0x2a) { // !!!
			s = "*"; // !!!
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; }; } // !!!
			return true; // !!!
		} else if(DENG._isnmstart[c]) { // !!!
			// matches nmstart
			s = String.fromCharCode(c);
			// skip one char
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; }; return false; }
		} else if(c == 0x5c) {
			// this char is escaped
			// skip the backslash
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
			// get the escaped character (add escaped crlf)
			s = getEscapedChar(false);
		} else {
			return false;
		}
		while(DENG._isnmchar[c = a[i].charCodeAt(p)] || c == 0x5c) {
			if(c != 0x5c) {
				// char was not escaped
				s += String.fromCharCode(c);
				// skip one char
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
			} else {
				// skip one char
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; return false; } }
				// get escaped char (add escaped crlf)
				s += getEscapedChar(false);
			}
		}
		return true;
	}
}


// hexcolor:  {hash} S*
DENG.CCssParserCore.prototype.getHexcolor = function()
{
	this.s = "";
	with(this) {
		// check for "#"
		if(a[i].charCodeAt(p) == 0x23) {
			var _c;
			var _p = p;
			var _i = i;
			// skip it
			if(++p == b[i]) {
				--p;
				return false;
			}
			if(DENG._ishex[_c = a[i].charCodeAt(p)]) {
				// char is hexadecimal
				// get up to 6 hex numbers
				var _count = 0;
				do {
					_count++;
					s += String.fromCharCode(_c);
					if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; break; } }
				} while(DENG._ishex[_c = a[i].charCodeAt(p)]);
				if(_count == 3) {
					var _n1 = s.charAt(0);
					var _n2 = s.charAt(1);
					var _n3 = s.charAt(2);
					s = _n1+_n1+_n2+_n2+_n3+_n3;
					return true;
				} else if(_count == 6) {
					return true;
				} else {
					p = _p; i = _i;
				}
			}
		}
		return false;
	}
}


// escape:   {unicode} | \\[ -~\200-\4177777]
// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
DENG.CCssParserCore.prototype.getEscapedChar = function(inString)
{
	with(this) {
		var c = a[i].charCodeAt(p);
		if(p == 0) {
			// char is a linefeed
			// (skipped by default)
			// return 10/undefined (ident/string)
			return inString ? undefined : "\012";
		} else if(DENG._ishex[c]) {
			// char is hexadecimal
			// get up to 6 hex numbers
			var count = 6;
			var h = "";
			do {
				h += String.fromCharCode(c);
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; break; } }
			} while(DENG._ishex[c = a[i].charCodeAt(p)] && --count);
			// ignore an eventually following whitespace
			if(p && DENG._iss[c]) {
				// skip it
				if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; break; } }
			}
			// convert hex to int and return the char
			return String.fromCharCode(parseInt(h, 16));
		} else if(c == 13) {
			// char is a carriage return
			// skip it and return 13/undefined (ident/string)
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; break; } }
			return inString ? undefined : "\015";
		} else {
			// any other char
			// skip 
			if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; break; } }
			if(c != 127 && c >= 32 && c <= 1114111) {
				// if c in [32..126, 128..1114111]
				// return that char
				return String.fromCharCode(c);
			} else {
				// char not escapable, ignore
				// report warning: illegal escape
				report.push({ type:0, code:0, line:i, position:p });
				return undefined;
			}
		}
	}
}


// simple_selector:    [ {namespace_selector}? {element_name} ]? [{hash}|{class}|{attrib}|{pseudo}]* S*
// namespace_selector: {element_name}? '|'
// element_name:       {ident} | '*'
// hash:               '#' {name}
// class:              '.' {ident}
// attrib:             '[' S* {namespace_selector}? {ident} S* [ ['='|{includes}|{dashmatch}] S* [{ident}|{string}] S* ]? ']'
// pseudo:             ':' [ {ident} | {ident} '(' S* {ident} S* ')' ]
//
// simpleselector is an array of 
DENG.CCssParserCore.prototype.getSimpleSelector = function()
{
	delete this.ss;
	this.ss = [];
	with(this) {
		var _ssns = null;
		var _ssname = null;
		var _subSelectorsExpected = false;
		if(getElementName()) {
			_ssname = s;
		}
		// check for "|"
		if(a[i].charCodeAt(p) == 0x7c) {
			if(++p == b[i]) { 
				/* linefeed */
				p = 0; 
				if(++i == a.length) { eof = true; }
				// problem: element name expected after | in a simple selector
				// ignore ruleset
				return false;
			}
			if(getElementName()) {
				_ssns = _ssname;
				_ssname = s;
			} else {
				// problem: element name expected after | in a simple selector
				// ignore ruleset
				return false;
			}
			// element with namespace
			ss.push({ type:1, prefix:_ssns, name:_ssname });
		} else {
			if(_ssname == null) {
				// * without namespace
				ss.push({ type:0, prefix:null, name:"*" });
				_subSelectorsExpected = true;
			} else {
				// element without namespace
				ss.push({ type:0, prefix:null, name:_ssname });
			}
		}
		
		var _loop = true;
		while(_loop)
		{
			switch(a[i].charCodeAt(p))
			{
				case 0x2e: // "."
					if(++p == b[i]) { 
						p = 0; if(++i == a.length) { eof = true; } // linefeed
						// problem: class name expected after "." in a simple selector
						// ignore ruleset
						return false;
					}
					if(getIdent()) {
						// class selector
						ss.push({ type:10, class:s });
					} else {
						// problem: class name expected after "." in a simple selector
						// ignore ruleset
						return false;
					}
					break;

				case 0x5b: // "["
					// '[' S* {namespace_selector}? {ident} S* [ ['='|'~='|'|='] S* [{ident}|{string}] S* ]? ']'
					if(++p == b[i]) { p = 0; if(++i == a.length) { eof = true; return false; } }
								// problem: unexpected eof
								// ignore ruleset
					var _c;
					var _ssans = null;
					var _ssaname = null;
					var _ssaobj = { type:11, operator:0 };
					// skip whitespaces
					skipWhite();
					if(getElementName()) {
						_ssaname = s;
					}
					
					// check for "|" (and not "|=") -> namespaced attribute
					if(a[i].charCodeAt(p) == 0x7c && a[i].charCodeAt(p+1) != 0x3d) {
						if(++p == b[i]) { 
							/* linefeed */
							p = 0; 
							if(++i == a.length) { eof = true; }
							// problem: element name expected after | in a simple selector
							// ignore ruleset
							return false;
						}
						if(getIdent()) {
							_ssans = _ssaname;
							_ssaname = s;
						} else {
							// problem: element name expected after | in a simple selector
							// ignore ruleset
							return false;
						}
						_ssaobj.prefix = _ssans;
						_ssaobj.name = _ssaname;
					} else {
						_ssaobj.prefix = _ssans;
						_ssaobj.name = (_ssaname == null) ? "*" : _ssaname;
					}
					
					// skip whitespaces
					skipWhite();
					if((_c = a[i].charCodeAt(p)) == 0x3d) {
						// "="
						_ssaobj.operator = 1;
					} else if(_c == 0x5d) {
						// "]"
						// skip one character
						if(++p == b[i]) { 
							/* linefeed */
							p = 0; 
							if(++i == a.length) { 
								eof = true;
								// problem: eof after simple selector
								// ignore ruleset
								return false;
							}
						}
						//if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; } }
						// register object in dom
						ss.push(_ssaobj);
						//skipWhiteAndComments();
						break;
					} else {
						var _op;
						switch(_c) {
							case 0x7e: // "~"
								_ssaobj.operator = 2; break;
							case 0x7c: // "|"
								_ssaobj.operator = 3; break;
							case 0x5e: // "^" (CSS3)
								_ssaobj.operator = 4; break;
							case 0x24: // "$" (CSS3)
								_ssaobj.operator = 5; break;
							case 0x2a: // "*" (CSS3)
								_ssaobj.operator = 6; break;
						}
						// skip one character
						if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; }
							// problem: "=" expected after "~" in dashmatch operator
							// ignore ruleset
							return false;
						}
						if(a[i].charCodeAt(p) != 0x3d) {
							// problem: "=" expected after "~" in includes operator
							// ignore ruleset
							return false;
						}
					}
					// skip one character
					if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; } }
					// skip whitespaces
					skipWhite();
					if(getIdent() || getString()) {
						_ssaobj.expr = s;
						// skip whitespaces
						skipWhite();
						if(a[i].charCodeAt(p) == 0x5d) {
							// "]"
							// register object in dom
							ss.push(_ssaobj);
							// skip char
							if(++p == b[i]) { /* linefeed */ p = 0; if(++i == a.length) { eof = true; } }
						}
					}
					break;

				case 0x3a: // ":"
					var _ssptype = 12; // pseudo class
					if(++p == b[i]) { 
						p = 0; if(++i == a.length) { eof = true; } // linefeed
						// problem: pseudo element expected after ":" in a simple selector
						// ignore ruleset
						return false;
					}
					if(a[i].charCodeAt(p) == 0x3a) {
						// css3 pseudo element? ("::")
						if(++p == b[i]) { 
							p = 0; if(++i == a.length) { eof = true; } // linefeed
							// problem: css3 pseudo element expected after "::" in a simple selector
							// ignore ruleset
							return false;
						}
						_ssptype = 20; // pseudo-element
					}
					var _ssparg = null;
					var _sspname = null;
					if(getIdent()) {
						_sspname = s;
						if(DENG._iscss2pseudoelement[s]) {
							_ssptype = 20; // pseudo element
						}
						var _c = a[i].charCodeAt(p);
						if(_c == 0x28) {
							// "(" found, skip it
							if(++p == b[i]) { p = 0; if(++i == a.length) { eof = true; return false; } }
									// problem: unexpected eof
									// ignore ruleset
							// skip whitspaces
							skipWhite();
							// try to get the function's argument
							if(_ssptype == 20) {
								// for pseudo elements, only idents are allowed
								if(getIdent()) {
									// argument found
									_ssparg = s;
									// skip whitespaces
									skipWhite();
								} else {
									_ssparg = "";
								}
							} else {
								// pseudo classes allow "IDENT | STRING | NUMBER | expression"
								// (or "negation_arg" for negation pseudo classes)
								if(_sspname != "not") {
									// todo: expression
									if(getIdent() || getString() || getNum()) {
										_ssparg = s;
										// skip whitespaces
										skipWhite();
									} else {
										return false;
									}
								} else {
									// the negation pseudo class takes a simple selector as argument
									// (we have to save this.ss temporarily because the recursive call will overwrite it)
									var _ss = ss;
									if(getSimpleSelector()) {
										_ssparg = ss;
									} else {
										return false;
									}
									this.ss = _ss;
								}
							}
							if(a[i].charCodeAt(p) == 0x29) {
								// ")" found, skip it
								if(++p == b[i]) { p = 0; if(++i == a.length) { eof = true; } }
								// DONE
							} else {
								// problem: ")" expected in function
								// ignore ruleset
								return false;
							}
						} else {
							// DONE
						}
					} else {
						// problem: pseudo element expected after ":" in a simple selector
						// ignore ruleset
						return false;
					}
					ss.push({ type:_ssptype, name:_sspname, farg:_ssparg });
					break;

				case 0x23: // "#"
					if(++p == b[i]) { 
						p = 0; if(++i == a.length) { eof = true; } // linefeed
						// problem: hash expected after "#" in a simple selector
						// ignore ruleset
						return false;
					}
					if(getName()) {
						ss.push({ type:13, id:s });
					} else {
						// problem: class name expected after "." in a simple selector
						// ignore ruleset
						return false;
					}
					break;

				default:
					_loop = false;
					break;
			}
		}
		
		skipWhiteAndComments();
		return (ss.length > (_subSelectorsExpected) ? 1 : 0);
	}
}


// '!' S* "important" S*
DENG.CCssParserCore.prototype.getPrio = function()
{
	this.$prio = false;
	with(this) {
		if(eof) {
			return false;
		} else {
			// check for "!"
			if(a[i].charCodeAt(p) == 0x21) {
				// "!" found, skip it
				if(++p == b[i]) { p = 0; if(++i == a.length) { eof = true; } }
				// skip whitespaces
				skipWhite();
				// check for "important"
				if(a[i].indexOf("important", p) == p) {
					// skip whitespaces
					skipWhite();
				} else {
					// problem: "important" expected after "!"
					return false;
				}
			} else {
				// problem: "!" expected in function
				// todo: ignore declaration
				return false;
			}
			
		}
	}
}


// '+' S* | '>' S* | /* empty */
DENG.CCssParserCore.prototype.getCombinator = function()
{
	this.s = "";
	with(this) {
		if(eof) {
			return false;
		} else {
			var _r = true;
			var _c = a[i].charCodeAt(p);
			switch(_c) {
				case 0x2b:
					s = "+";
					if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
					break;
				case 0x3e:
					s = ">";
					if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
					break;
				case 0x7e:
					s = "~";
					if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
					break;
				case 0x2a:
					s = "*";
					if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
					if(p && !eof && !_iss[a[i].charCodeAt(p)]) {
						s = " ";
						--p;
					}
					break;
				default:
					if(DENG._isnmstart[_c] || _c == 0x2a || _c == 0x5c || _c == 0x7c) {
						s = " ";
					} else {
						_r =  false;
					}
					break;
			}
			return _r;
		}
	}
}


// the expr object is an array of term objects
// term object structure:
// operator - operator succeeding this term
//        0 (or undefined) no operator (last term in expr)
//        1 " "
//        2 "/"
//        3 ","
// type - datatype of this term
//        1 (number)
//        5 (percentage)
//       10 (length/px)
//       11 (length/cm)
//       12 (length/mm)
//       13 (length/in)
//       14 (length/pt)
//       15 (length/pc)
//       20 (ems)
//       25 (exs)
//       30 (angle/deg)
//       31 (angle/rad)
//       32 (angle/grad)
//       40 (time/s)
//       41 (time/ms)
//       50 (freq/kHz)
//       51 (freq/Hz)
//       60 (dimen)
//      100 [function]
//      200 [string]
//      201 [ident]
//      210 [uri]
//      300 [hexcolor]
//      400 [unicoderange]
// value - the main data, mixed type depending on term type
// dimen - string (the dimen identifier)
// expr - expr object (the function expression), an array of term objects
// --------------------------------------------------------------------------------------
// expr:         {term} [ {operator} {term} ]*
// term:         {unary_operator}?
//                  [ NUMBER S* | PERCENTAGE S* | LENGTH S* | EMS S* | EXS S* | ANGLE S* | TIME S* | FREQ S* | function ]
//                  | {string} S*
//                  | {ident} S*
//                  | {uri} S*
//                  | {unicoderange} S*
//                  | {hexcolor}
// unicoderange: 'U\+' [0-9A-F?]{1,6} [ '-' [0-9A-F]{1,6} ]?
// function:     {ident} '(' S* {expr} ')' S*
DENG.CCssParserCore.prototype.getExpr = function(oExpr, oParentTerm)
{
	var _oExpr = oExpr;
	if(_oExpr == undefined) {
		this.oExpr = _oExpr = [];
	}
	with(this) {
		if(eof) {
			return false;
		} else {
			var _loop = true;
			do
			{
				var _oTerm = { operator:0 };
				var _u, _c;
				// test for unary operator
				if(_u = DENG._isunary[a[i].charCodeAt(p)]) {
					// skip char
					if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; }
						// problem: number or function expected after unary operator
						return false;
					}
				}
				if(getNum()) {
					// check for number
					if(_u == -1) {
						_oTerm.value = -parseFloat(s);
					} else {
						_oTerm.value = parseFloat(s);
					}
					// check num suffix
					if(a[i].charCodeAt(p) == 0x25) {
						// percentage
						_oTerm.type = 5;
						// skip char
						if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
					} else if(getIdent()) {
						if(_u = DENG._isnumsuffix["_"+s.toLowerCase()]) {
							_oTerm.type = _u;
						} else {
							_oTerm.type = 60;
							_oTerm.dimen = s;
						}
					} else {
						_oTerm.type = 1;
					}
				} else if(getUri()) {
					if(_u) {
						// problem: no unary operator allowed before uri
						return false;
					}
					_oTerm.value = s;
					_oTerm.type = 210;
				//} else if(getUnicodeRange()) {
				// todo!
				//	_oTerm.value = s;
				} else if(getIdent()) {
					_oTerm.value = s.toLowerCase();
					// this may be a function: check for "("
					if(a[i].charCodeAt(p) == 0x28) {
						// this is a function:
						_oTerm.type = 100;
						// skip char
						if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
						// skip whitespaces
						skipWhite();
						// check for ")"
						if(a[i].charCodeAt(p) == 0x29) {
							// skip char
							if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
							// empty function,
							// we're done
						} else {
							// create new expr object
							var _oNewExpr = [];
							// parse function argument (expression)
							// -> recursive call!
							if(getExpr(_oNewExpr, true)) {
								// skip whitespaces
								skipWhite();
								// check for ")"
								if(a[i].charCodeAt(p) == 0x29) {
									// skip char
									if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
									// okay we're almost done,
									// just check for rgb() function
									if(_oTerm.value == "rgb") {
										if(_oNewExpr.length == 3) {
											var _rgb = 0;
											for(var _i = 0; _i < 3; _i++) {
												var _oe = _oNewExpr[_i];
												if(_oe.operator != 3 && _i != 2) {
													// problem: arguments must be separated by "," in reserved function rgb
													return false;
												}
												var _v = _oe.value;
												if(_oe.unary == -1) { _v = 0; }
												if(_oe.type == 5) {
													// we have to round the value of _v to get rid of rounding errors
													_v = Math.round(_v * 2.55);
												} else if(_oe.type != 1) {
													// problem: arguments must be of type number (1) or percentage (5)
													return false;
												}
												if(_v > 255) { _v = 255; }
												_rgb = (_rgb << 8) + _v;
											}
											_oTerm.type = 300;
											_oTerm.value = _rgb;
										} else {
											// problem: wrong number of arguments in reserved function rgb
											return false;
										}
									} else {
										_oTerm.expr = _oNewExpr;
									}
									// we're done
								} else {
									// problem: ")" expected
									return false;
								}
							} else {
								// problem: syntax error in function argument
								return false;
							}
						}
					} else if(!_u) {
						_oTerm.type = 201;
					} else {
						// problem: no unary operator allowed before ident
						return false;
					}
				} else if(getHexcolor()) {
					if(_u) {
						// problem: no unary operator allowed before hexcolor
						return false;
					}
					_oTerm.type = 300;
					_oTerm.value = parseInt(s, 16);
				} else if(getString()) {
					if(_u) {
						// problem: no unary operator allowed before uri
						return false;
					}
					_oTerm.type = 200;
					_oTerm.value = s;
				} else {
					// problem: syntax error in expression
					return false;
				}
				// skip whitespaces
				skipWhite();
				// check for  ";", "}", ")" or eof (indicate end of expression)
				if(eof || DENG._iseoexpr[_c = a[i].charCodeAt(p)]) {
					// don't skip
					// we are done
					// break while loop
					_loop = false;
				} else if(_u = DENG._isoperator[_c]) {
					_oTerm.operator = _u;
					// skip char
					if(++p == b[i]) { /* newline */ p = 0; if(++i == a.length) { eof = true; } }
					// skip whitespaces
					skipWhite();
				} else {
					_oTerm.operator = 1;
				}
				// push term object into expr array
				_oExpr.push(_oTerm);
			}
			while(_loop);
			return true;
		}
	}
}



//
DENG._iss = []; // [ \t\r\n\f]
DENG._issc = []; // [ \t\r\n\f] | {comment}
DENG._isquote = []; // ["']
DENG._isunary = []; // [+-]
DENG._iseoexpr = []; // [)};]
DENG._isoperator = []; // [,/]
DENG._isnmstart = []; // [_a-zA-Z] | {nonascii}
DENG._isnmchar = []; // [_a-zA-Z0-9-] | {nonascii}
DENG._isstring = []; // [\t !#$%&(-~] | {nonascii}
DENG._ishex = []; // [a-fA-F0-9]
DENG._isurl = []; // [!#$%&*-~] | {nonascii}
DENG._isnum = []; // [0-9]
// initialize S hash ("isWhitespace"):
DENG._iss[9] = DENG._iss[10] = DENG._iss[12] = DENG._iss[13] = DENG._iss[32] = true;
DENG._issc[9] = DENG._issc[10] = DENG._issc[12] = DENG._issc[13] = DENG._issc[32] = DENG._issc[45] = DENG._issc[47] = DENG._issc[60] = true;
// initialize quote hash:
DENG._isquote[0x22] = 1; // double
DENG._isquote[0x27] = 2; // single
// initialize hash for unary operator:
DENG._isunary[0x2b] = 1; // "+"
DENG._isunary[0x2d] = -1; // "-"
// initialize hash for end-of-expression
DENG._iseoexpr[0x3b] = DENG._iseoexpr[0x7d] = DENG._iseoexpr[0x29] = true;
// initialize hash for operator
DENG._isoperator[0x2f] = 2;
DENG._isoperator[0x2c] = 3;
// numeric units
DENG._isnumsuffix = { _px:10, _cm:11, _mm:12, _in:13, _pt:14, _pc:15, _em:20, _ex:21, _deg:30, _rad:31, _grad:32, _s:40, _ms:41, _khz:50, _hz:51 };

for(i = 0x80; i <= 0xff; i++) { DENG._isnmstart[i] = DENG._isnmchar[i] = DENG._isstring[i] = true; } // {nonascii}
for(i = 0x41; i <= 0x5a; i++) { DENG._isnmstart[i] = DENG._isnmchar[i] = true; } // A-Z
for(i = 0x41; i <= 0x46; i++) { DENG._ishex[i] = true; } // A-F
for(i = 0x61; i <= 0x7a; i++) { DENG._isnmstart[i] = DENG._isnmchar[i] = true; } // a-z
for(i = 0x61; i <= 0x66; i++) { DENG._ishex[i] = true; } // a-f
for(i = 0x30; i <= 0x39; i++) { DENG._isnmchar[i] = DENG._ishex[i] = DENG._isnum[i] = true; } // 0-9
for(i = 0x20; i <= 0x7e; i++) { DENG._isstring[i] = DENG._isurl[i] = true; } // space - "~"
DENG._isstring[9] = true; // tab
DENG._isstring[0x22] = DENG._isstring[0x27] = false; // " '
DENG._isurl[0x20] = DENG._isurl[0x22] = DENG._isurl[0x27] = DENG._isurl[0x28] = DENG._isurl[0x29] = false; // space " ' ( )
DENG._isnmstart[0x5f] = DENG._isnmchar[0x5f] = true; // _
DENG._isnmchar[0x2d] = true; // -

// css2 pseudo elements
DENG._iscss2pseudoelement = { before:true, after:true };
DENG._iscss2pseudoelement["first-line"] = true;
DENG._iscss2pseudoelement["first-letter"] = true;
