/*
	TODOs:
	- implement parseAtMedia()
	- implement parseAtPage()
	- implement getUnicodeRange()
	- support for 4/8-digit color values
	- support for hsb() color values
	- report errors/warnings
*/

package deng.css
{
	import flash.utils.Dictionary;
	import deng.css.*;
	
	public class CSSParser
	{
		private var _aRules:Array;
	
		private var source:String;
		private var sourceLen:Number;
		private var index:Number;
		private var eof:Boolean;
		
		private var _s:String;
		private var _o:Object;
	
		public static const TYPE_AT_CHARSET:uint = 1;
		public static const TYPE_AT_IMPORT:uint = 2;
		public static const TYPE_AT_NAMESPACE:uint = 3;
		public static const TYPE_AT_MEDIA:uint = 4;
		public static const TYPE_AT_PAGE:uint = 5;
		public static const TYPE_AT_FONTFACE:uint = 6;
		public static const TYPE_RULESET:uint = 10;
		
		private static var _isNumSuffix:Dictionary = new Dictionary(); // numerical units (px, cm, mm, in, pt, pc, em, ex, ...)
		private static var _isCSS2Pseudo:Dictionary = new Dictionary(); // css2 pseudo elements (before, after, ...)
		private static var _hasPseudoExprArg:Dictionary = new Dictionary(); // pseudos with expr arguments (nth-child, nth-of-type, ...)

		private static var staticsInitialized:Boolean = false;
	
		public function CSSParser()
		{
			if(!staticsInitialized) {
				staticsInitialized = true;
				initStatics();
			}
		};

		public function parse(aSource:String):void
		{
			var atImportAllowed:Boolean = true;
			var atNamespaceAllowed:Boolean = true;
	
			index = 0;
			source = aSource;
			sourceLen = aSource.length;
			eof = (sourceLen == 0);
			_aRules = [];
	
			if(getAtSym()) {
				// a @charset rule is only allowed at the very top of a css
				if(_s == "charset") {
					parseAtCharset();
				} else {
					// reset index
					index = 0;
					eof = (sourceLen == 0);
				}
			}
			
			skipWhiteAndComments();
	
			while(!eof) {
				// check for standard ruleset
				if(parseRuleSet()) {
					// after the first ruleset,
					// all @import or @namespace are ignored
					atImportAllowed = false;
					atNamespaceAllowed = false;
				} else {
					// check for @rule
					if(getAtSym()) {
						switch(_s) {
							case "import":
								if(!atImportAllowed || !parseAtImport()) {
									// todo: report warning: @import ignored
									skipRuleSet(false);
								}
								break;
							case "charset":
								// at this point, @charset is already processed (see above): skip it
								// todo: report warning: @charset ignored
								skipRuleSet(false);
								break;
							case "namespace":
								if(!atNamespaceAllowed || !parseAtNamespace()) {
									// todo: report warning: @namespace ignored
									skipRuleSet(false);
								}
								atImportAllowed = false;
								break;
							case "page":
								// note: page rules are special in a way that
								// they may have page selectors. they behave
								// similar to normal rulesets
								if(!parseAtPage()) {
									// todo: report warning: @page ignored
									skipRuleSet(false);
								}
								atImportAllowed = false;
								atNamespaceAllowed = false;
								break;
							case "media":
								if(!parseAtMedia()) {
									// todo: report warning: @media ignored
									skipRuleSet(false);
								}
								atImportAllowed = false;
								atNamespaceAllowed = false;
								break;
							default:
								// not supported atrule: skip it
								// todo: report warning: unsupported atrule ignored
								atImportAllowed = false;
								atNamespaceAllowed = false;
								skipRuleSet(false);
								break;
						}
					} else {
						// todo: report error: illegal character. parse aborted
						break;
					}
				}
				skipWhiteAndComments();
			}
		};
	
	
		private function parseAtCharset():Boolean {
			skipWhiteAndComments();
			// get the charset string
			if(getString()) {
				skipWhiteAndComments();
				// skip next char if ";"
				if(checkChar(0x3b)) {
					// ok we're done
					// register charset string
					_aRules.push({ type:TYPE_AT_CHARSET, charset:_s });
					return true;
				} else {
					skipRuleSet(false);
				}
			} else {
				skipRuleSet(false);
			}
			// todo: report warning: corrupt @charset rule
			return false;
		}
	
		private function parseAtMedia():Boolean {
			// todo
			return false;
		}
	
		private function parseAtImport():Boolean {
			skipWhiteAndComments();
			// get the url
			if(getUri() || getString()) {
				var uri:String = _s;
				var media:Array = [];
				while(!eof) {
					skipWhite();
					if(getIdent()) {
						// medium ident found
						media.push(_s);
						// todo: check if medium matches
						skipWhiteAndComments();
						// check for ","
						if(!checkChar(0x2c)) {
							// no "," found
							// break loop and check for ";"
							break;
						}
					} else {
						// no more medium idents found
						// break loop and check for ";"
						break;
					}
				}
				if(checkChar(0x3b)) {
					// ";" found: done
					// register @import rule
					_aRules.push({ type:TYPE_AT_IMPORT, uri:uri, media:media });
					return true;
				} else {
					// todo: report warning: corrupt @import rule (";" expected)
					return false;
				}
			} else {
				// todo: report warning: corrupt @import rule (uri or string expected)
				return false;
			}
		}
	
		private function parseAtNamespace():Boolean {
			var uri:String;
			var prefix:String = "0";
			skipWhiteAndComments();
			if(getUri() || getString()) {
				uri = _s;
				// skip following whitespace
				skipWhiteAndComments();
			} else if(getIdent()) {
				prefix = _s;
				// skip following whitespace
				skipWhiteAndComments();
				if(getUri() || getString()) {
					uri = _s;
					// skip following whitespace
					skipWhiteAndComments();
				} else {
					skipRuleSet(false);
					// todo: report warning: corrupt @namespace rule (namespace uri expected)
					return false;
				}
			} else {
				skipRuleSet(false);
				// todo: report warning: corrupt @namespace rule (uri or string expected)
				return false;
			}
			// skip next char if ";"
			if(checkChar(0x3b)) {
				// ok we're done
				// register @namespace rule
				_aRules.push({ type:TYPE_AT_NAMESPACE, uri:uri, prefix:prefix });
				return true;
			} else {
				// todo: report warning: corrupt @namespace rule (";" expected)
				skipRuleSet(false);
				return false;
			}
		}
	
		private function parseAtPage():Boolean {
			// todo
			return false;
		}
	
		// ruleset : selector [',' S* selector]* '{' S* declaration [';' S* declaration]* '}' S*
		private function parseRuleSet():Boolean {
			if(getCharCode() == 0x40) {
				// this block is not a ruleset, it's an at-rule
				return false;
			} else {
				var ruleset:CSSRuleSet = new CSSRuleSet();
				var selector:CSSSelector;
				var declaration:CSSDeclaration;
				// get the selectors
				while(selector = parseSelector()) {
					// add selector to ruleset
					ruleset.addSelector(selector);
					// skip next char if ","
					if(checkChar(0x2c)) {
						// skip following whitespace
						skipWhiteAndComments();
					} else {
						// skip next char if "{"
						if(checkChar(0x7b)) {
							// skip following whitespace
							skipWhiteAndComments();
	
							// get the declarations
							while (declaration = parseDeclaration()) {
								if (declaration.isWellformed) {
									// add declaration to ruleset
									ruleset.addDeclaration(declaration);
								}
								// skip next char if ";"
								// otherwise break (must be a "}" then)
								if(!checkChar(0x3b)) {
									break;
								} else {
									// skip following whitespace
									skipWhiteAndComments();
									if(getCharCode() == 0x7d) {
										break;
									}
								}
							}
							// skip next char if "}"
							if(checkChar(0x7d)) {
								// skip trailing whitespace
								skipWhiteAndComments();
								// register ruleset
								_aRules.push({ type:TYPE_RULESET, rule:ruleset });
								// we're done
								return true;
							} else {
								// todo: report warning: "}" expected
								// skip the rest
								// (we're inside a block already, so specify true)
								skipRuleSet(true);
							}
						} else {
							// todo: report warning: "{" expected
							skipRuleSet(false);
						}
						// we're done
						return true;
					}
				}
	
				skipRuleSet(false);
				// we processed the ruleset or skipped it
				return true;
			}
			return false;
		}
	
		// parse selector
		// selector : simple_selector [combinator simple_selector]*
		private function parseSelector():CSSSelector {
			var selector:CSSSelector = new CSSSelector();
			// get simple selector
			var simpleSelector:CSSSimpleSelector = getSimpleSelector();
			if(simpleSelector) {
				selector.addSimpleSelector(simpleSelector);
				// get combinator
				while(getCombinator()) {
					selector.setCombinator(_s);
					// skip whitespace
					skipWhite();
					// get simple selector
					simpleSelector = getSimpleSelector()
					if(simpleSelector) {
						selector.addSimpleSelector(simpleSelector);
					} else {
						// todo: report warning: simple selector expected after combinator
						return null;
					}
				}
				return selector;
			} else {
				return null;
			}
		}
		
		// parse declaration
		// declaration:  {ident} S* ':' S* {expr} {prio}? | /* empty */
		private function parseDeclaration():CSSDeclaration {
			var declaration:CSSDeclaration = new CSSDeclaration();
			if(getIdent()) {
				// set property name in declaration object
				declaration.property = _s;
				// skip trailing whitespace
				skipWhiteAndComments();
				// skip next char if ":"
				if(checkChar(0x3a)) {
					// skip trailing whitespace
					skipWhiteAndComments();
					// get expression
					var expression:CSSExpr = getExpr();
					if(expression) {
						// set expression in declaration object
						declaration.value = expression;
						// skip trailing whitespace
						skipWhiteAndComments();
						if(getPrio()) {
							// set prio in declaration object
							declaration.priority = true;
							// skip trailing whitespace
							skipWhiteAndComments();
						}
						/*
						// shorthand property?
						var _pd = domRoot.propertyDefs;
						if(_pd.propShorthand[_prop] != undefined) {
							// yes: call shorthand handler
							var _oShorthandDeclarations = _pd[_pd.propShorthand[_prop]](_oDeclaration);
							if(_oShorthandDeclarations) {
								ruleset.declarations = ruleset.declarations.concat(_oShorthandDeclarations);
								DENG.CSSPARSER_DECLARATION_COUNT += _oShorthandDeclarations.length;
							} else {
								mytrace("shorthand property " + _prop + ": illegal value [line:" + (css.i+1) + ", pos:" + (css.p+1) + "]", "CCssParser", "parseDeclaration");
							}
						} else {
							// no: register declaration in ruleset
							ruleset.declarations.push(_oDeclaration);
							DENG.CSSPARSER_DECLARATION_COUNT++;
						}
						*/
						// done
					} else {
						// todo: report warning: expression expected after property in declaration
						skipDeclaration();
					}
				} else {
					// todo: report warning: ":" expected after property in declaration
					skipDeclaration();
				}
			} else {
				// not a problem:
				// empty declaration
				// next character should be a "}"
				return null;
			}
			return declaration;
		}
		
	
		////////////////////////////////////////////////////////
		// TOKENIZER
		////////////////////////////////////////////////////////
	
	
		private function skipWhite():void {
			if(eof) { return; }
			// while char is whitespace
			var c:Number;
			while((c = source.charCodeAt(index)) == 32 || c == 10 || c == 13 || c == 9 || c == 12) {
				// skip one char
				if(++index == sourceLen) {
					// end of file
					eof = true;
					break;
				}
			}
		}
		
		private function skipWhiteAndComments():void {
			if(eof) { return; }
			// while char is [whitespace | "/" | ">" | "-"]
			var c:Number;
			while((c = source.charCodeAt(index)) == 32 || c == 10 || c == 13 || c == 9 || c == 12 || c == 45 || c == 47 || c == 60) {
				// skip to next char
				if(++index == sourceLen) {
					// end of file
					eof = true;
					break;
				}
				// check for "/*"
				if(c == 0x2f) {
					if(source.charCodeAt(index) == 0x2a) {
						// start of comment found "/*"
						// skip to next char
						if(++index == sourceLen) {
							// end of file
							eof = true;
							return;
						}
						// now search for matching "*/"
						var posCommentClose:Number = source.indexOf("*/", index);
						if(posCommentClose < 0) {
							index = sourceLen;
							eof = true;
							return;
						}
						if((index = posCommentClose + 2) == sourceLen) {
							// end of file
							eof = true;
							return;
						}
					} else {
						// we're done (we found "/"): reset index
						--index;
						return;
					}
				} else if(c == 0x3c) {
					// "<" found, check for CDO ("<!--")
					if(source.indexOf("!--", index) != index) {
						// we're done (we found "<"): reset index
						--index;
						return;
					} else {
						index += 3;
						if(index == sourceLen) {
							// end of file
							eof = true;
							return;
						}
					}
				} else if(c == 0x2d) {
					// "-" found, check for CDC ("-->")
					if(source.indexOf("->", index) != index) {
						// we're done (we found "-"): reset index
						--index;
						return;
					} else {
						index += 2;
						if(index == sourceLen) {
							// end of file
							eof = true;
							return;
						}
					}
				}
			}
		}
		
		private function skipRuleSet(isInsideDeclaration:Boolean):void {
			if(eof) { return; }
			var parenthesisLevel:Number = 1;
			// loop until either "{", "}" or, if we're in a declaration, ";" is found
			var c:Number;
			while((c = source.charCodeAt(index)) != 0x7b && c != 0x7d && (isInsideDeclaration || c != 0x3b)) {
				// skip one char
				if(++index == sourceLen) {
					// end of file
					eof = true;
					return;
				}
				if(c == 0x5c) {
					// skip escaped char
					getEscapedChar(false);
				}
			}
			if(c == 0x3b || c == 0x7d) {
				// ";" found: skip this char, and we're done
				if(++index == sourceLen) { eof = true; }
			} else if(c == 0x7b) {
				// "{" found: skip this char, and search for matching "}"
				if(++index == sourceLen) {
					// end of file
					eof = true;
					return;
				}
				// loop until "}" is found
				while(!eof) {
					c = source.charCodeAt(index);
					// skip one char
					if(++index == sourceLen) {
						// end of file
						eof = true;
						return;
					}
					if(c == 0x7b) {
						parenthesisLevel++;
					} else if(c == 0x7d) {
						if(--parenthesisLevel == 0) {
							break;
						}
					} else if(c == 0x5c) {
						// get escaped char (add escaped crlf)
						getEscapedChar(false);
					}
				}
			}
			return;
		}
	
		private function skipDeclaration():void {
			if(eof) { return; }
			// loop until ";" or "}" is found
			var c:Number;
			while((c = source.charCodeAt(index)) != 0x3b && c != 0x7d) {
				// skip one char
				if(++index == sourceLen) {
					// end of file
					eof = true;
					return;
				}
				if(c == 0x5c) {
					// get escaped char (add escaped crlf)
					getEscapedChar(false);
				}
			}
		}
	
		
		private function checkChar(c:Number):Boolean {
			if(eof) { return false; }
			if(source.charCodeAt(index) == c) {
				if(++index == sourceLen) {
					eof = true;
				}
				return true;
			}
			return false;
		}
		
		private function getCharCode():Number {
			return eof ? 0 : source.charCodeAt(index);
		}
	
		// escape:   {unicode} | \\[ -~\200-\4177777]
		// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
		private function getEscapedChar(isInString:Boolean):String {
			var c:Number = source.charCodeAt(index);
			if(c == 0x0a || c == 0x0d) {
				// char is a lf or cr: skip
				if(++index == sourceLen) {
					eof = true;
				} else if(c == 0x0d && source.charCodeAt(index) == 0x0a) {
					// condense cr+lf into lf
					if(++index == sourceLen) {
						eof = true;
					}
				}
				// return lf or (for strings) an empty string
				return isInString ? "" : "\012";
			} else if((c >= 0x30 && c <= 0x39) || (c >= 0x61 && c <= 0x66) || (c >= 0x41 && c <= 0x46)) {
				// char is hexadecimal
				// get up to 6 hex numbers
				var count:Number = 6;
				var h:String = "";
				do {
					h += String.fromCharCode(c);
					if(++index == sourceLen) { eof = true; break; }
				} while((((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) || (c >= 0x61 && c <= 0x66) || (c >= 0x41 && c <= 0x46)) && --count > 0);
				// ignore a following whitespace
				if(c == 32 || c == 10 || c == 13 || c == 9 || c == 12) {
					// skip it
					if(++index == sourceLen) { eof = true; }
				}
				// convert hex to int and return the char
				return String.fromCharCode(parseInt(h, 16));
			} else {
				// any other char: skip
				if(++index == sourceLen) { eof = true; }
				if(c != 0x7f && c >= 0x20 && c <= 0x10ffff) {
					// if c in [32..126, 128..1114111]
					// return that char
					return String.fromCharCode(c);
				} else {
					// char not escapable, ignore
					// todo: report warning: illegal escape sequence
					return "";
				}
			}
		}
	
		// atrule: @<ident>
		private function getAtSym():Boolean {
			if(eof) { return false; }
			// check for "@"
			if(source.charCodeAt(index) == 0x40) {
				// skip one char
				if(++index == sourceLen) {
					// end of file
					// todo: report warning: unexpected 
					eof = true;
					return false;
				}
				// get atrule identifier
				if(getIdent()) {
					return true;
				} else {
					// todo: report warning: illegal atrule
					// skip rule
					// skipRuleSet();
					return false;
				}
			} else {
				return false;
			}
		}
	
		// ident:    {nmstart}{nmchar}*
		// nmstart:  [_a-zA-Z] | {nonascii} | {escape}
		// nmchar:   [_a-zA-Z0-9-] | {nonascii} | {escape}
		// nonascii: [^\0-\177]
		// escape:   {unicode} | \\[ -~\200-\4177777]
		// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
		private function getIdent():Boolean {
			_s = "";
			if(eof) { return false; }
			// get first char
			var c:Number = source.charCodeAt(index);
			// does it match nmstart?
			if((c >= 0x41 && c <= 0x5a) || c == 0x5f || (c >= 0x61 && c <= 0x7a) || (c >= 0x80 && c <= 0xff)) {
				_s = String.fromCharCode(c);
				// skip one char
				if(++index == sourceLen) { eof = true; return true; }
			} else if(c == 0x5c) {
				// this char is escaped
				// skip the backslash
				if(++index == sourceLen) {
					// todo: report warning: unexpected  in escape
					eof = true;
					return false;
				}
				// get the escaped character (add escaped crlf)
				_s = getEscapedChar(false);
			} else {
				return false;
			}
			// while it matches nmchar:
			while(((c = source.charCodeAt(index)) >= 0x41 && c <= 0x5a) || (c >= 0x30 && c <= 0x39) || c == 0x2d || c == 0x5f || c == 0x5c || (c >= 0x61 && c <= 0x7a) || (c >= 0x80 && c <= 0xff)) {
				if(c != 0x5c) {
					// char was not escaped
					_s += String.fromCharCode(c);
					// skip one char
					if(++index == sourceLen) { eof = true; break; }
				} else {
					// this char is escaped
					// skip the backslash
					if(++index == sourceLen) {
						// todo: report warning: unexpected  in escape sequence
						eof = true;
						return false;
					}
					// get escaped char (eventually add lf)
					_s += getEscapedChar(false);
				}
			}
			return true;
		}
	
		// name:     {nmchar}+
		// nmchar:   [_a-zA-Z0-9-] | {nonascii} | {escape}
		// nonascii: [^\0-\177]
		// escape:   {unicode} | \\[ -~\200-\4177777]
		// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
		private function getName():Boolean {
			_s = "";
			if(eof) { return false; }
			var c:Number;
			while(((c = source.charCodeAt(index)) >= 0x41 && c <= 0x5a) || (c >= 0x30 && c <= 0x39) || c == 0x2d || c == 0x5f || c == 0x5c || (c >= 0x61 && c <= 0x7a) || (c >= 0x80 && c <= 0xff)) {
				if(c != 0x5c) {
					// char was not escaped
					_s += String.fromCharCode(c);
					// skip one char
					if(++index == sourceLen) {
						// todo: report warning: unexpected  in escape sequence
						eof = true;
						return false;
					}
				} else {
					// skip one char
					if(++index == sourceLen) {
						// todo: report warning: unexpected  in escape sequence
						eof = true;
						return false;
					}
					// get escaped char (add escaped crlf)
					_s += getEscapedChar(false);
				}
			}
			return (_s != "");
		}
	
		// element_name: {ident} | '*'
		// identical to getIdent except for the parts marked with "!!!"
		private function getElementName():Boolean {
			_s = "";
			if(eof) { return false; }
			// get first char
			var c:Number = source.charCodeAt(index);
			if(c == 0x2a) { // !!!
				_s = "*";
				// skip char
				if(++index == sourceLen) { eof = true; }
				return true;
			} else if((c >= 0x41 && c <= 0x5a) || c == 0x5f || (c >= 0x61 && c <= 0x7a) || (c >= 0x80 && c <= 0xff)) {
				_s = String.fromCharCode(c);
				// skip one char
				if(++index == sourceLen) { eof = true; return true; }
			} else if(c == 0x5c) {
				// this char is escaped
				// skip the backslash
				if(++index == sourceLen) {
					// todo: report warning: unexpected  in escape
					eof = true;
					return false;
				}
				// get the escaped character (add escaped crlf)
				_s = getEscapedChar(false);
			} else {
				return false;
			}
			// while it matches nmchar:
			while(((c = source.charCodeAt(index)) >= 0x41 && c <= 0x5a) || (c >= 0x30 && c <= 0x39) || c == 0x2d || c == 0x5f || c == 0x5c || (c >= 0x61 && c <= 0x7a) || (c >= 0x80 && c <= 0xff)) {
				if(c != 0x5c) {
					// char was not escaped
					_s += String.fromCharCode(c);
					// skip one char
					if(++index == sourceLen) { eof = true; break; }
				} else {
					// this char is escaped
					// skip the backslash
					if(++index == sourceLen) {
						// todo: report warning: unexpected  in escape sequence
						eof = true;
						return false;
					}
					// get escaped char (eventually add lf)
					_s += getEscapedChar(false);
				}
			}
			return true;
		}
	
		// string:   {string1} | {string2}
		// string1:  \"([\t !#$%&(-~] | \\{nl} | \’ | {nonascii} | {escape})*\"
		// string2:  \’([\t !#$%&(-~] | \\{nl} | \" | {nonascii} | {escape})*\’
		// nonascii: [^\0-\177]
		// escape:   {unicode} | \\[ -~\200-\4177777]
		// unicode:  \\[0-9a-f]{1,6}[ \n\r\t\f]?
		private function getString():Boolean {
			_s = "";
			if(eof) { return false; }
			// is first char a single or a double quote?
			var c:Number = source.charCodeAt(index);
			if(c == 0x22 || c == 0x27) {
				// skip it
				if(++index == sourceLen) {
					// todo: report warning: unexpected  in string
					eof = true;
					return false;
				}
				var cStr:Number;
				var cAllowedQuote:Number = (c == 0x27) ? 0x22 : 0x27;
				// 
				while((cStr = source.charCodeAt(index)) == 0x09 || (cStr >= 0x20 && cStr <= 0xff && cStr != 0x22 && cStr != 0x27 && cStr != 0x7f) || cStr == cAllowedQuote) {
					if(cStr != 0x5c) {
						// char was not escaped
						_s += String.fromCharCode(cStr);
						// skip one char
						if(++index == sourceLen) {
							// todo: report warning: unexpected  in string
							eof = true;
							return false;
						}
					} else {
						// unescape char
						// skip "\"
						if(++index == sourceLen) {
							// todo: report warning: unexpected  in string
							eof = true;
							return false;
						}
						// get escaped char (eventually omit escaped crlf)
						_s += getEscapedChar(true);
					}
				}
				if(source.charCodeAt(index) == cStr) {
					// correct quote found: skip it
					if(++index == sourceLen) { eof = true; }
					return true;
				} else {
					// todo: report warning: illegal char in string: string not terminated
					return false;
				}
			} else {
				return false;
			}
		}
	
		// num: [0-9]+ | [0-9]* "." [0-9]+
		private function getNum():Boolean {
			_s = "";
			if(eof) { return false; }
			var c:Number;
			var idxTmp:Number = index;
			while((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) {
				_s += String.fromCharCode(c);
				// skip one char
				if(++index == sourceLen) {
					eof = true;
					return (_s != "");
				}
			}
			if(c == 0x2e) {
				// "." detected:
				// get fractional part
				// skip the "."
				if(++index == sourceLen) {
					eof = true;
					return false;
				}
				_s += ".";
				var hasFract:Boolean = false;
				while((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) {
					hasFract = true;
					_s += String.fromCharCode(c);
					// skip one char
					if(++index == sourceLen) {
						eof = true;
						break;
					}
				}
				if(!hasFract) {
					if(_s == ".") {
						// this is no number, this is just a "."
						// reset indices and return null
						index = idxTmp;
						eof = false;
						return false;
					} else {
						// todo: report warning: fractional part missing after "."
						return false;
					}
				}
			}
			return (_s != "");
		}
	
		// hexcolor:  {hash} S*
		private function getHexcolor():Boolean {
			_s = "";
			// check for "#"
			if(source.charCodeAt(index) == 0x23) {
				var c:Number;
				var idxTmp:Number = index;
				// skip it
				if(++index == sourceLen) { eof = true; return false; }
				if(((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) || (c >= 0x61 && c <= 0x66) || (c >= 0x41 && c <= 0x46)) {
					// char is hexadecimal
					// get up to 6 hex numbers
					var count:uint = 0;
					do {
						count++;
						_s += String.fromCharCode(c);
						if(++index == sourceLen) { eof = true; break; }
					} while(((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) || (c >= 0x61 && c <= 0x66) || (c >= 0x41 && c <= 0x46));
					if(count == 6) {
						return true;
					} else if(count == 3) {
						var n1:String = _s.charAt(0);
						var n2:String = _s.charAt(1);
						var n3:String = _s.charAt(2);
						_s = n1 + n1 + n2 + n2 + n3 + n3;
						return true;
					} else {
						index = idxTmp;
					}
				}
			}
			return false;
		}
	
		// integer: [-]?[0-9]+
		private function getInteger():Boolean {
			_s = "";
			if(eof) { return false; }
			var c:Number;
			var idxTmp:Number = index;
			if(source.charCodeAt(index) == 0x2d) {
				_s = "-";
				// skip it
				if(++index == sourceLen) { eof = true; return false; }
			}
			if((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) {
				// char is a number
				do {
					_s += String.fromCharCode(c);
					if(++index == sourceLen) { eof = true; break; }
				} while((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39);
			} else {
				// problem: no number
				index = idxTmp;
				return false;
			}
			return true;
		}
	
		// signed_integer: [-+][0-9]+
		private function getSignedInteger():Boolean {
			_s = "";
			if(eof) { return false; }
			var c:Number;
			var idxTmp:Number = index;
			if((c = source.charCodeAt(index)) == 0x2b || c == 0x2d) {
				_s = String.fromCharCode(c);
				// skip it
				if(++index == sourceLen) { eof = true; return false; }
			} else {
				return false;
			}
			if((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39) {
				// char is a number
				do {
					_s += String.fromCharCode(c);
					if(++index == sourceLen) { eof = true; break; }
				} while((c = source.charCodeAt(index)) >= 0x30 && c <= 0x39);
			} else {
				// problem: no number
				index = idxTmp;
				return false;
			}
			return true;
		}
	
		// expression: [['-' | INTEGER]? 'n' [SIGNED_INTEGER]?] | INTEGER
		private function getPseudoExpr():Boolean {
			_o = { a:1, b:0 };
			if(eof) { return false; }
			if(getInteger()) {
				if(source.charAt(index) != "n") {
					_o = { a:0, b:parseInt(_s) };
					return true;
				} else {
					_o.a = parseInt(_s);
				}
			} else if(source.charCodeAt(index) == 0x2d) {
				_o.a = -1;
				if(++index == sourceLen) {
					// todo: report warning: unexpected  in pseudo expression
					eof = true;
					return false;
				}
			}
			if(source.charAt(index) == "n") {
				if(++index == sourceLen) { eof = true; }
				if(getSignedInteger()) {
					_o.b = parseInt(_s);
				}
			} else {
				return false;
			}
			return true;
		}
		
		// "url(" {w} {string} {w} ")"
		// "url(" {w} {url} {w} ")"
		private function getUri():Boolean {
			_s = "";
			if(eof) { return false; }
			// check for "url("
			if(source.substr(index, 4) == "url(") {
				index += 4;
				if(index == sourceLen) {
					// todo: report warning: unexpected  in uri
					eof = true;
					return false;
				}
				skipWhite();
				if(getString() || getUrlCss()) {
					if(source.charCodeAt(index) == 0x29) {
						// ")" found: skip
						if(++index == sourceLen) { eof = true; }
						return true;
					} else {
						// todo: report warning: ")" expected
						return false;
					}
				}
			}
			return false;
		}
	
		// url:      ([!#$%&*-~] | {nonascii} | {escape})*
		// nonascii: [^\0-\177]
		private function getUrlCss():Boolean {
			_s = "";
			if(eof) { return false; }
			var c:Number;
			while((c = source.charCodeAt(index)) == 0x21 || (c >= 0x2a && c <= 0x7e) || (c >= 0x23 && c <= 0x26)) {
				if(c != 0x5c) {
					// char was not escaped
					_s += String.fromCharCode(c);
					// skip one char
					if(++index == sourceLen) { eof = true; }
				} else {
					// skip one char
					if(++index == sourceLen) {
						// todo: report warning: unexpected  in url
						eof = true;
						return false;
					}
					// get escaped char (add escaped crlf)
					_s += getEscapedChar(false);
				}
			}
			return (_s != "");
		}
		
		// simple_selector:    [ {namespace_selector}? {element_name} ]? [{hash}|{class}|{attrib}|{pseudo}]* S*
		// namespace_selector: {element_name}? '|'
		// element_name:       {ident} | '*'
		// hash:               '#' {name}
		// class:              '.' {ident}
		// attrib:             '[' S* {namespace_selector}? {ident} S* [ ['='|{includes}|{dashmatch}] S* [{ident}|{string}] S* ]? ']'
		// pseudo:             ':' [ {ident} | {ident} '(' S* {ident} S* ')' ]
		private function getSimpleSelector():CSSSimpleSelector {
			var c:Number;
			var simpleSelector:CSSSimpleSelector = new CSSSimpleSelector();
			var subSelectorsExpected:Boolean = false;
			var ssPrefix:String;
			var ssName:String;
			if(getElementName()) {
				ssName = _s;
			}
			// check for "|"
			if(source.charCodeAt(index) == 0x7c) {
				if(++index == sourceLen) {
					// todo: report warning: unexpected  in selector
					eof = true;
					return null;
				}
				if(getElementName()) {
					ssPrefix = ssName;
					ssName = _s;
				} else {
					// todo: report warning: element name expected after | in a simple selector
					// ignore ruleset
					return null;
				}
				// element with namespace
				simpleSelector.addElementSelectorNS(ssName, ssPrefix);
			} else {
				if(ssName == null) {
					// * without namespace
					simpleSelector.addElementSelector("*");
					subSelectorsExpected = true;
				} else {
					// element without namespace
					simpleSelector.addElementSelector(ssName);
				}
			}
			
			var loop:Boolean = true;
			while(loop)
			{
				switch(source.charCodeAt(index))
				{
					case 0x2e: // "."
						if(++index == sourceLen) { eof = true; };
						if(getIdent()) {
							// class selector
							simpleSelector.addClassSelector(_s);
						} else {
							// todo: report warning: class name expected after "." in a simple selector
							// ignore ruleset
							return null;
						}
						break;
	
					case 0x5b: // "["
						// '[' S* {namespace_selector}? {ident} S* [ ['='|'~='|'|='] S* [{ident}|{string}] S* ]? ']'
						if(++index == sourceLen) {
							// todo: report warning
							eof = true;
							return null;
						}
						var ssAttrPrefix:String;
						var ssAttrName:String;
						var ssAttrExpression:String = "";
						var ssAttrOperator:Number = CSSSimpleSelector.TYPE_ATTR_OP_NONE;
						// skip whitespaces
						skipWhite();
						if(getElementName()) {
							ssAttrName = _s;
						}
						
						// check for "|" (and not "|=") -> namespaced attribute
						if(source.charCodeAt(index) == 0x7c && source.charCodeAt(index+1) != 0x3d) {
							// skip char
							if(++index == sourceLen) {
								// todo: report warning: unexpected  in selector
								eof = true;
								return null;
							}
							if(getIdent()) {
								ssAttrPrefix = ssAttrName;
								ssAttrName = _s;
							} else {
								// todo: report warning: element name expected after | in a simple selector
								// ignore ruleset
								return null;
							}
						} else {
							if(ssAttrName == null) {
								ssAttrName = "*";
							}
						}
						// skip whitespaces
						skipWhite();
						if((c = source.charCodeAt(index)) == 0x3d) {
							// "="
							ssAttrOperator = CSSSimpleSelector.TYPE_ATTR_OP_EQ;
						} else if(c == 0x5d) {
							// "]"
							// skip one character
							if(++index == sourceLen) {
								// todo: report warning: unexpected  after simpleselector
								eof = true;
								return null;
							}
							// add element
							if(ssAttrPrefix == null) {
								simpleSelector.addAttributeSelector(ssAttrName, 0, "");
							} else {
								simpleSelector.addAttributeSelectorNS(ssAttrName, ssAttrPrefix, 0, "");
							}
							break;
						} else {
							switch(c) {
								case 0x7e: // "~"
									ssAttrOperator = CSSSimpleSelector.TYPE_ATTR_OP_WORD; break;
								case 0x7c: // "|"
									ssAttrOperator = CSSSimpleSelector.TYPE_ATTR_OP_LANG; break;
								case 0x5e: // "^" (CSS3)
									ssAttrOperator = CSSSimpleSelector.TYPE_ATTR_OP_SUBSTR_BEGIN; break;
								case 0x24: // "$" (CSS3)
									ssAttrOperator = CSSSimpleSelector.TYPE_ATTR_OP_SUBSTR_END; break;
								case 0x2a: // "*" (CSS3)
									ssAttrOperator = CSSSimpleSelector.TYPE_ATTR_OP_SUBSTR; break;
							}
							// skip one character
							if(++index == sourceLen) {
								// todo: report warning: unexpected 
								// ignore ruleset
								eof = true;
								return null;
							}
							if(source.charCodeAt(index) != 0x3d) {
								// todo: report warning: "=" expected
								// ignore ruleset
								return null;
							}
						}
						// skip one character
						if(++index == sourceLen) { eof = true; }
						// skip whitespaces
						skipWhite();
						if(getIdent() || getString()) {
							ssAttrExpression = _s;
							// skip whitespaces
							skipWhite();
							if(source.charCodeAt(index) == 0x5d) {
								// "]"
								// register object in dom
								if(ssAttrPrefix == null) {
									simpleSelector.addAttributeSelector(ssAttrName, ssAttrOperator, ssAttrExpression);
								} else {
									simpleSelector.addAttributeSelectorNS(ssAttrName, ssAttrPrefix, ssAttrOperator, ssAttrExpression);
								}
								// skip char
								if(++index == sourceLen) { eof = true; }
							}
						}
						break;
	
					case 0x3a: // ":"
						// pseudo class
						var bPseudoClass:Boolean = true;
						var bPseudoClassNeg:Boolean = false;
						var sSSPseudoName:String;
						var sSSPseudoArg:String;
						var sSSPseudoExprArg:Object;
						var oSSPseudoNegArg:CSSSimpleSelector;
						// skip one character
						if(++index == sourceLen) {
							// todo: report warning: pseudo element expected after ":" in a simple selector
							// ignore ruleset
							eof = true;
							return null;
						}
						if(source.charCodeAt(index) == 0x3a) {
							// css3 pseudo element ("::")
							bPseudoClass = false;
							// skip one character
							if(++index == sourceLen) {
								// todo: report warning: css3 pseudo element expected after "::" in a simple selector
								// ignore ruleset
								eof = true;
								return null;
							}
							// pseudo-element
						}
						if(getIdent()) {
							sSSPseudoName = _s;
							if(_isCSS2Pseudo[sSSPseudoName]) {
								bPseudoClass = false;
							}
							if((c = source.charCodeAt(index)) == 0x28) {
								// "(" found, skip it
								if(++index == sourceLen) {
									// todo: report warning: unexpected 
									// ignore ruleset
									eof = true;
									return null;
								}
								// skip whitspaces
								skipWhite();
								// try to get the function's argument
								if(bPseudoClass) {
									// pseudo classes allow "IDENT | STRING | NUMBER | expression"
									// (or "negation_arg" for negation pseudo classes)
									if(sSSPseudoName != "not") {
										if(_hasPseudoExprArg[sSSPseudoName] && getPseudoExpr()) {
											sSSPseudoExprArg = _o;
										} else if (getIdent() || getString() || getNum()) {
											sSSPseudoArg = _s;
										} else {
											// todo: report warning: malformed expression in pseudo class
											// ignore ruleset
											return null;
										}
										// skip whitespaces
										skipWhite();
									} else {
										// the negation pseudo class :not(..) takes a 
										// simpleselector as argument (recursive call)
										if((oSSPseudoNegArg = getSimpleSelector()) == null) {
											// todo: report warning: malformed argument in negation pseudo class
											// ignore ruleset
											return null;
										}
										bPseudoClassNeg = true;
									}
								} else {
									// for pseudo elements, only idents are allowed
									if(getIdent()) {
										// argument found
										sSSPseudoArg = _s;
										// skip whitespaces
										skipWhite();
									} else {
										// no arguments given
										sSSPseudoArg = "";
									}
								}
								if(source.charCodeAt(index) == 0x29) {
									// ")" found, skip it
									if(++index == sourceLen) { eof = true; }
									// DONE
								} else {
									// todo: report warning: ")" expected in function
									// ignore ruleset
									return null;
								}
							} else {
								// DONE
							}
						} else {
							// todo: report warning: pseudo element expected after ":" in a simple selector
							// ignore ruleset
							return null;
						}
						// register selector
						if(bPseudoClass) {
							if(bPseudoClassNeg) {
								simpleSelector.addPseudoClassNegSelector(oSSPseudoNegArg);
							} else if(sSSPseudoExprArg != null) {
								simpleSelector.addPseudoClassExprSelector(sSSPseudoName, sSSPseudoExprArg);
							} else {
								simpleSelector.addPseudoClassSelector(sSSPseudoName, sSSPseudoArg);
							}
						} else {
							simpleSelector.addPseudoElementSelector(sSSPseudoName, sSSPseudoArg);
						}
						break;
	
					case 0x23: // "#"
						if(++index == sourceLen) {
							// todo: report warning: unexpected 
							eof = true;
							return null;
						}
						if(getName()) {
							// id selector
							simpleSelector.addIDSelector(_s);
						} else {
							// todo: report warning: hash expected after "#" in a simple selector
							// ignore ruleset
							return null;
						}
						break;
	
					default:
						loop = false;
						break;
				}
			}
			
			skipWhiteAndComments();
			
			return (simpleSelector.hasElements() ? simpleSelector : CSSSimpleSelector(null));
		}
		
		// '!' S* "important" S*
		private function getPrio():Boolean {
			if(eof) {
				return false;
			} else {
				// check for "!"
				if(source.charCodeAt(index) == 0x21) {
					// "!" found, skip it
					if(++index == sourceLen) { eof = true; };
					// skip whitespaces
					skipWhite();
					// check for "important"
					if(source.indexOf("important", index) == index) {
						index += 9;
						if(index == sourceLen) { eof = true; };
						// skip whitespaces
						skipWhite();
						return true;
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
	
		// combinator: '+' S* | '>' S* | '~' S* | '*' S* | /* empty */
		private function getCombinator():Boolean {
			_s = "";
			if(eof) {
				return false;
			} else {
				var bRet:Boolean = true;
				var c:Number = source.charCodeAt(index);
				switch(c) {
					case 0x2b:
						_s = "+";
						if(++index == sourceLen) { eof = true; };
						break;
					case 0x3e:
						_s = ">";
						if(++index == sourceLen) { eof = true; };
						break;
					case 0x7e:
						_s = "~";
						if(++index == sourceLen) { eof = true; };
						break;
					case 0x2a:
						_s = "*";
						if(++index == sourceLen) { eof = true; };
						if(!eof && (c = source.charCodeAt(index)) != 32 && c != 10 && c != 13 && c != 9 && c != 12) {
							_s = " ";
							--index;
						}
						break;
					default:
						if((c >= 0x41 && c <= 0x5a) // nmstart
						|| c == 0x5f // nmstart
						|| (c >= 0x61 && c <= 0x7a) // nmstart
						|| (c >= 0x80 && c <= 0xff) // nmstart
						|| c == 0x2a // "*"
						|| c == 0x23 // "#"
						|| c == 0x3a // ":"
						|| c == 0x2e // "."
						|| c == 0x5b // "["
						|| c == 0x5c // "\"
						|| c == 0x7c // "|"
						) {
							_s = " ";
						} else {
							bRet = false;
						}
						break;
				}
				return bRet;
			}
		}


		// expr:  {term} [ {operator} {term} ]*
		// term:  {unary_operator}?
		//           [ NUMBER S* | PERCENTAGE S* | LENGTH S* | EMS S* | EXS S* | ANGLE S* | TIME S* | FREQ S* | function ]
		//           | {string} S*
		//           | {ident} S*
		//           | {uri} S*
		//           | {unicoderange} S*
		//           | {hexcolor}
		// unicoderange: 'U\+' [0-9A-F?]{1,6} [ '-' [0-9A-F]{1,6} ]?
		// function:     {ident} '(' S* {expr} ')' S*
		private function getExpr():CSSExpr {
			if(eof) {
				return null;
			} else {
				var oExpr:CSSExpr = new CSSExpr();
				var loop:Boolean = true;
				do
				{
					var c:Number;
					var oTerm:Object = { op:CSSExpr.TYPE_OP_NONE }
					var u:Number = source.charCodeAt(index);
					var hasUnaryOperator:Boolean = (u == 0x2b || u == 0x2d);
					// test for unary operator
					if(hasUnaryOperator) {
						// skip char
						if(++index == sourceLen) {
							// todo: report warning: unexpected 
							eof = true;
							return null;
						}
					}
					if(getNum()) {
						// check for number
						if(u == 0x2d) {
							oTerm.value = "-" + _s;
						} else {
							oTerm.value = _s;
						}
						// check num suffix
						if(source.charCodeAt(index) == 0x25) {
							// percentage
							oTerm.type = CSSExpr.TYPE_PERCENTAGE;
							// skip char
							if(++index == sourceLen) { eof = true; };
						} else if(getIdent()) {
							u = _isNumSuffix[_s.toLowerCase()]
							if(u != undefined) {
								oTerm.type = u;
							} else {
								oTerm.type = CSSExpr.TYPE_DIMEN;
								oTerm.dimen = _s;
							}
						} else {
							// no suffix: this is a number
							oTerm.type = CSSExpr.TYPE_NUMBER;
						}
					} else if(getUri()) {
						if(hasUnaryOperator) {
							// problem: no unary operator allowed before uri
							return null;
						}
						oTerm.type = CSSExpr.TYPE_URI;
						oTerm.value = _s;
					//} else if(getUnicodeRange()) {
					// todo!
					//	_oTerm.value = s;
					} else if(getIdent()) {
						oTerm.value = _s.toLowerCase();
						// this may be a function: check for "("
						if(source.charCodeAt(index) == 0x28) {
							// this is a function:
							oTerm.type = CSSExpr.TYPE_FUNCTION;
							// skip char
							if(++index == sourceLen) { eof = true; };
							// skip whitespaces
							skipWhite();
							// check for ")"
							if(source.charCodeAt(index) == 0x29) {
								// skip char
								if(++index == sourceLen) { eof = true; };
								// empty function,
								// we're done
							} else {
								// create new expr object
								var oFuncExpr:CSSExpr = getExpr();
								// parse function argument (expression)
								// -> recursive call!
								if(oFuncExpr != undefined) {
									// skip whitespaces
									skipWhite();
									// check for ")"
									if(source.charCodeAt(index) == 0x29) {
										// skip char
										if(++index == sourceLen) { eof = true; };
										// okay we're almost done,
										// just check for rgb() function
										if(oTerm.value == "rgb") {
											if(oFuncExpr.getTermCount() == 3) {
												var rgb:Number = 0;
												for(var i:Number = 0; i < 3; i++) {
													var term:Object = oFuncExpr.getTermAt(i);
													if(term.op != CSSExpr.TYPE_OP_COMMA && i != 2) {
														// problem: arguments must be separated by "," in reserved function rgb
														return null;
													}
													var v:Number = term.value;
													if(term.type == CSSExpr.TYPE_PERCENTAGE) {
														// we have to round the value of _v to get rid of rounding errors
														v = Math.max(0, Math.round(v * 2.55));
													} else if(term.type == CSSExpr.TYPE_NUMBER) {
														v = Math.max(0, parseInt(v));
													} else {
														// problem: arguments must be of type CSSExpr.TYPE_NUMBER or CSSExpr.TYPE_PERCENTAGE
														return null;
													}
													if(v > 255) { v = 255; }
													rgb = (rgb << 8) + v;
												}
												oTerm.type = CSSExpr.TYPE_HEXCOLOR;
												oTerm.value = rgb;
											} else {
												// problem: wrong number of arguments in reserved function rgb
												return null;
											}
										} else {
											oTerm.expr = oFuncExpr;
										}
										// we're done
									} else {
										// problem: ")" expected
										return null;
									}
								} else {
									// problem: syntax error in function argument
									return null;
								}
							}
						} else if(!hasUnaryOperator) {
							oTerm.type = CSSExpr.TYPE_IDENT;
						} else {
							// problem: no unary operator allowed before ident
							return null;
						}
					} else if(getHexcolor()) {
						if(hasUnaryOperator) {
							// problem: no unary operator allowed before hexcolor
							return null;
						}
						oTerm.type = CSSExpr.TYPE_HEXCOLOR;
						oTerm.value = parseInt(_s, 16);
					} else if(getString()) {
						if(hasUnaryOperator) {
							// problem: no unary operator allowed before uri
							return null;
						}
						oTerm.type = CSSExpr.TYPE_STRING;
						oTerm.value = _s;
					} else {
						// problem: syntax error in expression
						return null;
					}
					// skip whitespaces
					skipWhite();
					// check for  "!", ";", "}", ")" or  (indicate end of expression)
					if(eof || (c = source.charCodeAt(index)) == 0x3b || c == 0x7d || c == 0x29 || c == 0x21) {
						// don't skip
						// we are done
						// break while loop
						loop = false;
					} else if(c == 0x2f) {
						oTerm.op = CSSExpr.TYPE_OP_SLASH;
						if(++index == sourceLen) { eof = true; };
						skipWhite();
					} else if(c == 0x2c) {
						oTerm.op = CSSExpr.TYPE_OP_COMMA;
						if(++index == sourceLen) { eof = true; };
						skipWhite();
					} else {
						oTerm.op = CSSExpr.TYPE_OP_SPACE;
					}
					// push term object into expr array
					oExpr.addTerm(oTerm);
				}
				while(loop);
				return oExpr;
			}
		}

	
		////////////////////////////////////////////////////////
		// initStatics
		////////////////////////////////////////////////////////
	
		private static function initStatics():void {
			// numeric units
			_isNumSuffix["px"] = CSSExpr.TYPE_LENGTH_PX;
			_isNumSuffix["cm"] = CSSExpr.TYPE_LENGTH_CM;
			_isNumSuffix["mm"] = CSSExpr.TYPE_LENGTH_MM;
			_isNumSuffix["in"] = CSSExpr.TYPE_LENGTH_IN;
			_isNumSuffix["pt"] = CSSExpr.TYPE_LENGTH_PT;
			_isNumSuffix["pc"] = CSSExpr.TYPE_LENGTH_PC;
			_isNumSuffix["em"] = CSSExpr.TYPE_EMS;
			_isNumSuffix["ex"] = CSSExpr.TYPE_EXS;
			_isNumSuffix["deg"] = CSSExpr.TYPE_ANGLE_DEG;
			_isNumSuffix["rad"] = CSSExpr.TYPE_ANGLE_RAD;
			_isNumSuffix["grad"] = CSSExpr.TYPE_ANGLE_GRAD;
			_isNumSuffix["s"] = CSSExpr.TYPE_TIME_S;
			_isNumSuffix["ms"] = CSSExpr.TYPE_TIME_MS;
			_isNumSuffix["hz"] = CSSExpr.TYPE_FREQ_HZ;
			_isNumSuffix["khz"] = CSSExpr.TYPE_FREQ_KHZ;
			// css2 pseudo elements
			_isCSS2Pseudo["before"] = true;
			_isCSS2Pseudo["after"] = true;
			_isCSS2Pseudo["first-line"] = true;
			_isCSS2Pseudo["first-letter"] = true;
			// css3 pseudo elements that can have expr arguments
			_hasPseudoExprArg["nth-child"] = true;
			_hasPseudoExprArg["nth-last-child"] = true;
			_hasPseudoExprArg["nth-of-type"] = true;
			_hasPseudoExprArg["nth-last-of-type"] = true;
		};


		////////////////////////////////////////////////////////
		// toString
		////////////////////////////////////////////////////////
	
		public function toString():String {
			var s:String = "";
			var i:Number = 0;
			var l:Number = _aRules.length;
			for(; i < l; i++) {
				var o:Object = _aRules[i];
				switch(o.type) {
					case TYPE_RULESET:
						s += CSSRuleSet(o.rule).toString() + "\n";
						break;
					case TYPE_AT_IMPORT:
						s += "@import \"" + o.uri + "\"";
						var nMediaLen:Number = Number(o.media.length);
						for(var j:Number = 0; j < nMediaLen; j++) {
							s += (j == 0 ? " " : ", ") + o.media[j];
						}
						s += ";\n";
						break;
					case TYPE_AT_NAMESPACE:
						s += "@namespace ";
						if(o.prefix) {
							s += o.prefix + " ";
						}
						s += "\"" + o.uri + "\";\n";
						break;
					case TYPE_AT_CHARSET:
						s += "@charset \"" + o.charset + "\";\n";
						break;
					case TYPE_AT_MEDIA:
						break;
					case TYPE_AT_PAGE:
						break;
					case TYPE_AT_FONTFACE:
						break;
				}
			}
			return s;
		};
	}
}
