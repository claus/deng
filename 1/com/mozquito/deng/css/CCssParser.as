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
//   class DENG.CCssParser
// ===========================================================================================

_global.CSS_ATIMPORT_STATUS_IGNORE = 0;
_global.CSS_ATIMPORT_STATUS_WAITING = 1;
_global.CSS_REPORT_TYPE_ERROR = 0;
_global.CSS_REPORT_TYPE_WARNING = 1;
_global.CSS_REPORT_CODE_UNEXPECTED_CRLF = 100;
_global.CSS_REPORT_CODE_ILLEGAL_ATSYM = 500;
_global.CSS_REPORT_CODE_MISSING_FRACT = 1000;

DENG.CSSPARSER_SELECTOR_COUNT = 0;
DENG.CSSPARSER_DECLARATION_COUNT = 0;

DENG.CCssParser = function(callback, dom, parent, media)
{
	this.dom = (dom) ? dom : {};
	if(this.dom.import == undefined) { this.dom.import = []; }
	this.media = (media == undefined) ? { all:true, screen:true } : media;
	if(parent == undefined || !parent) {
		this.parent = null;
		this.domRoot = this.dom;
		this.callback = callback;
	} else {
		this.parent = parent;
		this.domRoot = parent.domRoot;
		this.callback = parent.callback;
	}
}


DENG.CCssParser.prototype.cleanUp = function()
{
	trace("CCssParser.prototype.cleanUp");
	for(i in this.dom.import) {
		this.dom.import[i].obj.cleanUp();
		delete this.dom.import[i].obj;
	}
	//this.dom.rulesets.cleanUp();
	delete this.dom.rulesets;
	delete this.$css.callback;
	delete this.$css.onData;
	delete this.$css;
	delete this.media;
	delete this.parent;
	delete this.domRoot;
	delete this.callback;

}


DENG.CCssParser.prototype.load = function(uri)
{
	// uri transformation
	var _u = new DENG.CUri(uri, this.callback.callback.xmlDomRef.getBaseUrl());
	this.baseUrl = _u.getAbsolute();
	mytrace(this.baseUrl, "CCssParser", "load");
	// create xml object
	if(this.$css == undefined) {
		this.$css = new XML();
		this.$css.callback = this;
		this.$css.onData = function(src) { this.callback.onLoad(src); };
	}
	var _us = _u.getLocator();
	if(_us == null) {
		this.onLoad();
		return;
	}
	// load css
	mytrace(unescape(_us), "CCssParser", "load");
	this.$css.load(_us);
}

DENG.CCssParser.prototype.onLoad = function(src)
{
	if(mytrace) { mytrace("", "CCssParser", "onLoad");	} else { _level0.debug.text += "CSS onLoad " + this.baseUrl + "\n"; }
	if(src != undefined) {
		this.parse(src);
	} else {
		// todo: load error
		// notify parent
		mytrace("loading failed, " + this.baseUrl + " not found", "CCssParser", "onLoad", 1);
		this.onParse(false);
	}
}

DENG.CCssParser.prototype.onParse = function(success)
{
	if(this.parent) {
		this.parent.parseStyleSheet();
	} else {
		mytrace("parsing done [success:" + success + "]", "CCssParser", "onParse");
	}
}

DENG.CCssParser.prototype.parse = function(src)
{
	mytrace("parsing [size:" + src.length + "b]", "CCssParser", "parse");

	if(this.baseUrl == undefined) {
		this.baseUrl = this.callback.callback.xmlDomRef.getBaseUrl();
	}

	this.$t = this.$td = getTimer();

	// create string array (split on "\n")
	this.css = new DENG.CCssParserCore(src);

	this._atNamespaceAllowed = this._atImportAllowed = true;

	with(this) {
		var _p = css.p;
		var _i = css.i;
		// check for "@charset" rule
		// (has to appear at the very top of the document)
		if(css.getAtSym()) {
			if(css.s == "charset") {
				parseAtCharset();
			} else {
				// reset pointers
				css.p = _p;
				css.i = _i;
			}
		}

		css.skipWhiteAndComments();

		if(dom.import == undefined) { dom.import = []; }
		if(dom.namespace == undefined) { dom.namespace = {}; }
		if(dom.rulesets == undefined) { dom.rulesets = []; }

		// enter main parsing loop
		parseStyleSheet();
	}
}


DENG.CCssParser.prototype.parseInline = function(src)
{
	//mytrace("parsing [size:" + src.length + "b] " + src, "CCssParser", "parseInline");
	//this.$t = this.$td = getTimer();

	// create string array etc
	this.css = new DENG.CCssParserCore(src + " ");

	with(this) {
		// initialize ruleset object (we only need declarations,
		// we don't have selectors in inline styles)
		var oRuleSet = { declarations:[] };
		// parse the declarations
		while(parseDeclaration(oRuleSet)) {
			// skip next char if ";"
			// otherwise break (must be eof then)
			if(!css.checkChar(0x3b)) {
				break;
			} else {
				// skip following whitespace
				css.skipWhiteAndComments();
			}
		}
		// register lookup table
		registerRuleSetInline(oRuleSet);
	}
}


DENG.CCssParser.prototype.parseInlineAttr = function(queue)
{
	this.css = new DENG.CCssParserCore();

	// initialize ruleset object (we only need declarations,
	// we don't have selectors in inline attribute styles)
	var oRuleSet = { declarations:[] };

	var _css = this.css;
	var _nval = queue.length;
	// loop all attribute property definitions
	for(var i = 0; i < _nval; i++) {
		var _expr = [];
		var _qi = queue[i];
		delete _css.a;
		delete _css.b;
		_css.a = [_qi.value + " "];
		_css.b = [_qi.value.length + 1];
		_css.p = _css.i = 0;
		_css.eof = false;
		// parse the value
		if(_css.getExpr(_expr)) {
			// add to declaration, if syntactically correct
			oRuleSet.declarations.push({ property:_qi.name, expr:_expr });
		}
	}
	// register lookup table
	this.registerRuleSetAttr(oRuleSet);
}

function mysort(a, b) {
	//mytrace("##### "+Number(a)+" "+Number(b), "CCssParser", "parseStyleSheet");
	// workaround array bug in fp7beta
	// (first array index is "-" instead of "0")
	return ((a=="-") ? 0 : a) - ((b=="-") ? 0 : b);
}


DENG.CCssParser.prototype.parseStyleSheet = function()
{
	with(this) {
		var _t;
		var _atImportWaiting = false;
		if($parseStyleSheetIntervalID != undefined) {
			clearInterval($parseStyleSheetIntervalID);
			delete $parseStyleSheetIntervalID;
			$td = getTimer();
		}
		while(!css.eof && !_atImportWaiting) {
			_t = getTimer();
			// check for standard ruleset
			if(parseRuleSet()) {
				// after the first ruleset
				// all @import or @charset are ignored
				_atImportAllowed = false;
				_atNamespaceAllowed = false;
			} else {
				// check for @rule
				if(css.getAtSym()) {
					switch(css.s) {
						case "import":
							if(_atImportAllowed && parseAtImport()) {
								// this.$tmpAtImportObj is created by parseAtImport()
								// and holds a reference to the current @import dom object
								// if that object's member "status" is not CSS_ATIMPORT_STATUS_IGNORE:
								// break this loop (by setting _atImportWaiting to true),
								// create a new CCssParser object,
								// load and parse that stylesheet,
								// and continue parsing here.
								_atImportWaiting = ($tmpAtImportObj.status != CSS_ATIMPORT_STATUS_IGNORE);

								// debug only:
								if(!_atImportWaiting) {
									mytrace("@import ignored (media types don't match)", "CCssParser", "parseStyleSheet");
								}

							} else {
								mytrace("@import ignored", "CCssParser", "parseStyleSheet");
								css.skipRuleSet();
							}
							break;
						case "charset":
							// charset already processed (see this.parse)
							// skip it
							mytrace("@charset ignored", "CCssParser", "parseStyleSheet");
							css.skipRuleSet();
							break;
						case "namespace":
							if(_atNamespaceAllowed) {
								parseAtNamespace();
							} else {
								mytrace("@namespace ignored", "CCssParser", "parseStyleSheet");
								css.skipRuleSet();
							}
							_atImportAllowed = false;
							break;
						case "media":
						case "page":
						case "font-face":
						default:
							// not (yet) supported at-rule
							// skip it
							mytrace("unknown at-rule @" + css.s + " found and ignored", "CCssParser", "parseStyleSheet");
							_atImportAllowed = false;
							_atNamespaceAllowed = false;
							css.skipRuleSet();
							break;
					}
					_atCharsetAllowed = false;
				} else {
					mytrace("illegal character. parse aborted.", "CCssParser", "parseStyleSheet", 2);
					// todo: report error
					break;
				}
			}
			css.skipWhiteAndComments();

			_$t += getTimer() - _t;

			if(!_atImportWaiting && (getTimer()-$td) > 0) {
				this.$parseStyleSheetIntervalID = setInterval(this, "parseStyleSheet", 1);
				return;
			}
		}

		if(_atImportWaiting)
		{
			// create new CCssParser object
			$tmpAtImportObj.obj = new DENG.CCssParser(null, null, this, $tmpAtImportObj.media);
			// load stylesheet
			$tmpAtImportObj.obj.load(new DENG.CUri($tmpAtImportObj.uri, this.baseUrl).getAbsolute());
			// we are not done yet..
			// wait for new object
		}
		else
		{
			//if(!parent) {
				var _pt = this.domRoot.propertyTable;
				for(var y in _pt) {

					// sort specificity object
					var indices = [];
					var objOld = _pt[y];
					for(var i in objOld) indices.push(i);
					indices.sort(mysort);
					var iLen = indices.length;
					var objNew = {};
					for(var j = 0; j < iLen; j++) {
						objNew[indices[j]] = objOld[indices[j]];
						delete objOld[indices[j]];
					};
					_pt[y] = objNew;
				}
			//}
			onParse(true);
		}
	}
}

DENG.CCssParser.prototype.parseAtCharset = function()
{
	with(this) {
		css.skipWhiteAndComments();
		// get the charset string
		if(css.getString()) {
			css.skipWhiteAndComments();
			// skip next char if ";"
			if(css.checkChar(0x3b)) {
				// ok we're done
				mytrace("@charset ok [" + css.s + "]", "CCssParser", "parseAtCharset");
				// register charset string
				dom.charset = css.s;
				// and return true
				return true;
			} else {
				// todo: report error
				css.skipRuleSet();
			}
		} else {
			// todo: report error
			css.skipRuleSet();
		}
		mytrace("@charset corrupt", "CCssParser", "parseAtCharset");
		return false;
	}
}

DENG.CCssParser.prototype.parseAtImport = function()
{
	with(this) {
		css.skipWhiteAndComments();
		// get the url
		if(css.getUri() || css.getString()) {
			var _status = CSS_ATIMPORT_STATUS_IGNORE;
			var _uri = css.s;
			var _media = { };
			while(!css.eof) {
				css.skipWhite();
				if(css.getIdent()) {
					// medium ident found
					_media[css.s] = true;
					// check if medium matches
					if(css.s == "all" || media[css.s]) {
						_status = CSS_ATIMPORT_STATUS_WAITING;
					}
					// check for ","
					css.skipWhiteAndComments();
					if(!css.checkChar(0x2c)) {
						// no "," found
						// break loop and check for ";"
						break;
					}
				} else {
					// no medium ident found
					// default to "all"
					_media.all = true;
					_status = CSS_ATIMPORT_STATUS_WAITING;
					// break loop and check for ";"
					break;
				}
			}
			if(css.checkChar(0x3b)) {
				// ";" found: done
				mytrace("@import ok [" + _uri + "]", "CCssParser", "parseAtImport");
				_uri = new DENG.CUri(_uri, this.baseUrl).getAbsolute();
				mytrace("@import absolute uri [" + unescape(_uri) + "]", "CCssParser", "parseAtImport");
				// register @import rule in dom
				if(dom.import == undefined) { dom.import = []; }
				$tmpAtImportObj = { uri:_uri, media:_media, status:_status };
				dom.import.push($tmpAtImportObj);
				return true;
			} else {
				// illegal char after medium ident
				// todo: report error
			}
		} else {
			// todo: report error
		}
		mytrace("@import corrupt", "CCssParser", "parseAtImport");
		return false;
	}
}

DENG.CCssParser.prototype.parseAtNamespace = function()
{
	with(this) {
		var _uri;
		var _prefix = "0";
		css.skipWhiteAndComments();
		if(css.getUri() || css.getString()) {
			_uri = css.s;
			// skip following whitespace
			css.skipWhiteAndComments();
		} else if(css.getIdent()) {
			_prefix = css.s;
			// skip following whitespace
			css.skipWhiteAndComments();
			if(css.getUri() || css.getString()) {
				_uri = css.s;
				// skip following whitespace
				css.skipWhiteAndComments();
			} else {
				// todo: report error (uri or string expected)
				css.skipRuleSet();
				// problem: namespace uri expected in @namespace rule
				mytrace("@namespace corrupt (namespace uri expected)", "CCssParser", "parseAtNamespace");
				return false;
			}
		} else {
			// todo: report error (uri or string expected)
			css.skipRuleSet();
			// problem: @namespace rule corrupt
			mytrace("@namespace corrupt", "CCssParser", "parseAtNamespace");
			return false;
		}
		// skip next char if ";"
		if(css.checkChar(0x3b)) {
			// ok we're done
			mytrace("@namespace ok [" + _prefix + ", " + _uri + "]", "CCssParser", "parseAtNamespace");
			// register @namespace rule in dom
			dom.namespace[_prefix] = _uri;
			return true;
		} else {
			// problem: ";" expected after @namespace rule
			mytrace("@namespace corrupt (';' expected)", "CCssParser", "parseAtNamespace");
			css.skipRuleSet();
			return false;
		}
	}
}

// parse ruleset
// ruleset : selector [’,’ S* selector]* ’{’ S* declaration [’;’ S* declaration]* ’}’ S*
DENG.CCssParser.prototype.parseRuleSet = function()
{
	with(this) {
		if(css.getCharCode() == 0x40) {
			// this block is not a ruleset, it's an at-rule
			return false;
		} else {
			var oRuleSet = { selectors:[], declarations:[] };
			// get the selectors
			while(parseSelector(oRuleSet)) {
				// skip next char if ","
				if(css.checkChar(0x2c)) {
					// skip following whitespace
					css.skipWhiteAndComments();
				} else {
					// skip next char if "{"
					if(css.checkChar(0x7b)) {
						// skip following whitespace
						css.skipWhiteAndComments();

						// get the declarations
						while(parseDeclaration(oRuleSet)) {
							// skip next char if ";"
							// otherwise break (must be a "}" then)
							if(!css.checkChar(0x3b)) {
								break;
							} else {
								// skip following whitespace
								css.skipWhiteAndComments();
								if(css.getCharCode() == 0x7d) {
									break;
								}
							}
						}
						// skip next char if "}"
						if(css.checkChar(0x7d)) {
							// register lookup tables, get calculated values
							registerRuleSet(oRuleSet);
							// register in dom
							dom.rulesets.push(oRuleSet);
							// skip trailing whitespace
							css.skipWhiteAndComments();
							// we're done
							return true;
						} else {
							// problem: "}" expected
							// skip the rest
							// (we're inside a block already, so specify true)
							css.skipRuleSet(true);
						}
					} else {
						// problem: "{" expected
						css.skipRuleSet();
					}
					return true;
					break;
				}
			}

			css.skipRuleSet();
			// we processed the ruleset or skipped it, so return true
			return true;
		}
	}
}


DENG.CCssParser.prototype.registerRuleSet = function(oRuleSet)
{
	var _o = {};
	var _decls = oRuleSet.declarations;
	var _sels = oRuleSet.selectors;
	var _propTable = this.domRoot.propertyTable;
	var _selTable = this.domRoot.selectorTable;
	var _i = _decls.length;
	var _sl = _sels.length;
	var _j = 0;
	//for(var i in _sels) {
	//	mytrace(traceSelector(_sels[i]), "CCssParser", "registerRuleSet");
	//}
	while(_j < _sl) {
		var _s = _sels[_j++];
		_selTable.push({ oSelector:_s, dom: this.dom });
	}
	while(_i--) {
		var _p = _decls[_i].property;
		if(!_o[_p]) {
			_o[_p] = true;
			_j = 0;
			var _pt = _propTable[_p];
			if(!_pt) { _pt = _propTable[_p] = {}; }
			while(_j < _sl) {
				var _s = _sels[_j].specificity;
				if(!_pt[_s]) { _pt[_s] = []; }
				_pt[_s].push({ oRuleSet:oRuleSet, dom: this.dom, idxDecl:_i, idxSel:_j++ });
			}
		}
	}
}

DENG.CCssParser.prototype.registerRuleSetInline = function(oRuleSet)
{
	var _decls = oRuleSet.declarations;
	var _propTable = this.domRoot.propertyTableInline;
	var _i = _decls.length;
	while(_i--) {
		var _di = _decls[_i];
		_propTable[_di.property] = _di.expr;
	}
}

DENG.CCssParser.prototype.registerRuleSetAttr = function(oRuleSet)
{
	var _decls = oRuleSet.declarations;
	var _propTable = this.domRoot.propertyTableAttr;
	var _i = _decls.length;
	while(_i--) {
		var _di = _decls[_i];
		_propTable[_di.property] = _di.expr;
	}
}


// parse selector
// selector : simple_selector [combinator simple_selector]*
DENG.CCssParser.prototype.parseSelector = function(oRuleSet)
{
	with(this) {
		if(css.getSimpleSelector()) {
			var oSelector = { hasPseudoElements:false, hasPseudoClasses:false };
			var _sso = [{ simpleselector:css.ss }];
			var _i = 0;
			// get combinator
			while(css.getCombinator()) {
				_sso[_i].combinator = css.s;
				// skip whitespace
				css.skipWhite();
				if(css.getSimpleSelector()) {
					_sso.push({ simpleselector:css.ss });
					_i++;
				} else {
					// problem: simple selector expected
					return false;
				}
			}

			// calculate specificity
			var _sb = 0, _sc = 0, _sd = 0;
			for(var i in _sso) {
				var _ss = _sso[i].simpleselector;
				for(var j in _ss) {
					// simpleselector type
					//  0 element, no/default namespace
					//  1 element, namespace
					// 10 class selector "."
					// 11 attribute selector "[..]"
					// 12 pseudo class
					// 13 id selector "#"
					// 20 pseudo element (ignored)
					switch(_ss[j].type) {
						case 0:
						case 1:
							if(_ss[j].name != "*") {
								_sd++;
							}
							break;
						case 10:
						case 11:
							_sc++;
							break;
						case 12:
							oSelector.hasPseudoClasses = true;
							if(_ss[j].name != "not") {
								_sc++;
							} else {
								// negation pseudo class:
								// "negative selectors are counted like their simple selectors argument"
								_sb = 0; _sc = 0; _sd = 0;
								for(var k in _ss[j].farg) {
									var _fargss = _ss[j].farg[k];
									switch(_fargss.type) {
										case 0:
										case 1:
											if(_fargss.name != "*") { _sd++;	}; break;
										case 10:
										case 11:
										case 12:
											_sc++; break;
										case 13:
											_sb++; break;
									}
								}
							}
							break;
						case 13:
							_sb++;
							break;
						case 20:
							oSelector.hasPseudoElements = true;
							break;
					}
				}
			}
			oSelector.specificity = (((_sb * 1000) + _sc) * 1000) + _sd;
			oSelector.root = _sso.pop().simpleselector;
			if(_i) {
				oSelector.simpleselectors = _sso;
			}
			oRuleSet.selectors.push(oSelector);
			DENG.CSSPARSER_SELECTOR_COUNT++;

			// mytrace("registered: " + traceSelector(oSelector), "CCssParser", "parseSelector");

			return true;
		} else {
			return false;
		}
	}
}


// parse declaration
// declaration:  {ident} S* ':' S* {expr} {prio}? | /* empty */
DENG.CCssParser.prototype.parseDeclaration = function(oRuleSet)
{
	with(this) {
		if(css.getIdent()) {
			// check property
			var _prop = css.s.split("-").join("");
			//if(_pd.propAll[_prop]) {
				// register property
				// > declaration object
				//   - property
				//   - expr
				//   - prio
				var _oDeclaration = { property:_prop };
				// skip trailing whitespace
				css.skipWhiteAndComments();
				// skip next char if ":"
				if(css.checkChar(0x3a)) {
					// skip trailing whitespace
					css.skipWhiteAndComments();
					// get expression
					if(css.getExpr()) {
						// register expr
						_oDeclaration.expr = css.oExpr;
						// skip trailing whitespace
						css.skipWhiteAndComments();
						if(css.getPrio()) {
							// register prio in declaration object
							_oDeclaration.prio = css.bPrio;
							// skip trailing whitespace
							css.skipWhiteAndComments();
						}
						// shorthand property?
						var _pd = domRoot.propertyDefs;
						if(_pd.propShorthand[_prop] != undefined) {
							// yes: call shorthand handler
							var _oShorthandDeclarations = _pd[_pd.propShorthand[_prop]](_oDeclaration);
							if(_oShorthandDeclarations) {
								oRuleSet.declarations = oRuleSet.declarations.concat(_oShorthandDeclarations);
								DENG.CSSPARSER_DECLARATION_COUNT += _oShorthandDeclarations.length;
							} else {
								mytrace("shorthand property " + _prop + ": illegal value [line:" + (css.i+1) + ", pos:" + (css.p+1) + "]", "CCssParser", "parseDeclaration");
							}
						} else {
							// no: register declaration in ruleset
							oRuleSet.declarations.push(_oDeclaration);
							DENG.CSSPARSER_DECLARATION_COUNT++;
						}
						// done
					} else {
						// problem: expression expected after property in declaration
						mytrace("expression expected after property in declaration" + " [line:" + (css.i+1) + ", pos:" + (css.p+1) + "]", "CCssParser", "parseDeclaration");
						css.skipDeclaration();
					}
				} else {
					// problem: ":" expected after property in declaration
					mytrace("\":\" expected after property in declaration" + " [line:" + (css.i+1) + ", pos:" + (css.p+1) + "]", "CCssParser", "parseDeclaration");
					css.skipDeclaration();
				}
			//} else {
			//	mytrace("unknown property: " + _prop + " (ignored)" + " [line:" + (css.i+1) + ", pos:" + (css.p+1) + "]", "CCssParser", "parseDeclaration");
			//	css.skipDeclaration();
			//}
		} else {
			// not a problem:
			// empty declaration
			// next character should be a "}"
		}
		return true;
	}
}

	/*
	mtrace("parsing done [time:" + (getTimer()-t1) + "ms]");
	var _rl = css.report.length;
	if(_rl) {
		mtrace("\nerror Log:");
		for(var i = 0; i < _rl; i++) {
			var _r = css.report[i];
			mtrace(_r.type + " " + _r.code + " " + _r.line + " " + _r.position);
		}
	} else {
		mtrace("\nno errors, no warnings");
	}
	*/

