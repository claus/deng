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
//   class DENG.CCss
// ===========================================================================================

#include "com/mozquito/deng/css/CCssProperties.as"
#include "com/mozquito/deng/css/CCssParserCore.as"
#include "com/mozquito/deng/css/CCssParser.as"

DENG.CCss = function(callback)
{
	// this.callback -> CWnd object
	this.callback = callback;
	this.$queue = [];
	this.$queueInline = [];
	this.$queueInlineAttr = [];
	this.$parseDelay = 0;
	
	// css dom object
	// - propertyTable (associative)
	// - propertyTableInline (associative)
	// - propertyTableAttr (associative)
	// - propertyDefs (instance of namespaces css property class)
	//   - propInherited
	//   - propShorthand (only if properties parsed)
	//   - propInitial (only if root)
	this.dom = {
		selectorTable: [],
		propertyTable: {},
		propertyTableInline: {},
		propertyTableAttr: {},
		propertyDefs: new DENG[DENG.$getCssPropertiesClassName(callback.node.nsUri)](this)
	};
}

DENG.CCss.prototype.addExternalCSS = function(uri)
{
	if(this.$parser == undefined) {
		this.$parser = new DENG.CCssParser(this, this.dom);
		this.$parser.dom.import = [];
	}
	var _p = new DENG.CCssParser(null, null, this.$parser);
	this.$parser.dom.import.push( { obj: _p } );
	this.$queue.push({ type: 0, uri: uri, obj: _p });
}

DENG.CCss.prototype.addInternalCSS = function(css)
{
	if(this.$parser == undefined) {
		this.$parser = new DENG.CCssParser(this, this.dom);
		this.$parser.dom.import = [];
	}
	var _p = new DENG.CCssParser(null, null, this.$parser);
	this.$parser.dom.import.push( { obj: _p } );
	this.$queue.push({ type: 1, css: css, obj: _p });
}

DENG.CCss.prototype.addInlineCSS = function(css)
{
	if(this.$inlineParser == undefined) {
		this.$inlineParser = new DENG.CCssParser(this, this.dom);
	}
	this.$queueInline.push(css);
}

DENG.CCss.prototype.addInlineAttrCSS = function(name, value)
{
	if(this.$inlineParser == undefined) {
		this.$inlineParser = new DENG.CCssParser(this, this.dom);
	}
	this.$queueInlineAttr.push({ name:name, value:value });
}


DENG.CCss.prototype.resolvePseudos = function(obj)
{
	var _st = this.dom.selectorTable;
	// loop selectors
	for(var _i in _st) {
		if(_st[_i].oSelector.hasPseudoElements) {
			var _s = _st[_i].oSelector;
			var _dom = _st[_i].dom;
			// loop simpleselectors
			//mytrace(traceSelector(_s), "CCss", "resolvePseudos");
			// match root simple selector
			if(this.matchSimpleSelector(obj, _s.root, _dom)) {
				if(_s.simpleselectors) {
					// there are simple selectors to match this node
					var _match = true;
					var _node = obj.node;
					var _ssa = _s.simpleselectors;
					// loop simple selectors
					for(var _ssi in _ssa) {
						var _ss = _ssa[_ssi];
						switch(_ss.combinator) {
							case null:
								_match = this.matchSimpleSelector(obj, _ss.simpleselector, _dom);
								break;
							case " ":
								// descendent selector:
								// until root node is reached,
								// dig through parent nodes to find the element matching the current simpleselector
								_match = false;
								while(!_match && (_node = _node.parentNode)) {
									_match = this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom);
								}
								break;
							case "+":
								// adjacent sibling selector:
								// check if the previous sibling element matches
								_match = (_node = _node.previousSibling) ? this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom) : false;
								break;
							case "~":
								// indirect adjacent sibling selector:
								// check if one of the previous sibling elements match
								_match = false;
								while(!_match && (_node = _node.previousSibling)) {
									_match = this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom);
								}
								break;
							case ">":
								// child selector:
								// check if the parent element match
								_match = (_node = _node.parentNode) ? this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom) : false;
								break;
							case "*":
								// grandchild descendent selector:
								// until root node is reached,
								// dig through parent nodes to find the element matching the current simpleselector
								_match = false;
								if(_node = _node.parentNode) {
									while(!_match && (_node = _node.parentNode)) {
										_match = this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom);
									}
								}
								break;
							default:
								_match = false;
								break;
						}
						if(!_match) {
							break;
						}
					}
				}
			}
		} else {
			//mytrace(traceSelector(_st[_i].oSelector) + " ###xxx", "CCss", "resolvePseudos");
		}
	}
}


DENG.CCss.prototype.resolveProperty = function(obj, name)
{
	var _pty = this.dom.propertyTable[name];
	// loop specificity array
	// (high specificity first)
	//for(var s in _pty) {
	//	var _ptys = _pty[s];
	//	mytrace(name + " [" + s + "]", "CCss", "resolveProperty");
	//}
	for(var s in _pty) {
		var _ptys = _pty[s];
		// loop rulesets
		for(var x in _ptys) {
			var _ptysx = _ptys[x];
			var _so = _ptysx.oRuleSet.selectors[_ptysx.idxSel];
			//mytrace(name + " [" + traceSelector(_so) + "]", "CCss", "resolveProperty");
			var _dom = _ptysx.dom;
			// match root simple selector
			if(this.matchSimpleSelector(obj, _so.root, _dom)) {
				if(!_so.simpleselectors) {
					// no more simple selectors: match found
					//trace("###match! " + name + " " + obj.cssPseudoClass + " " + _ptysx.oRuleSet.declarations[_ptysx.idxDecl].expr[0].value);
					return _ptysx.oRuleSet.declarations[_ptysx.idxDecl].expr;
				} else {
					// there are simple selectors to match this node
					var _match = true;
					var _node = obj.node;
					var _ssa = _so.simpleselectors;
					// loop simple selectors
					for(var _ssi in _ssa) {
						var _ss = _ssa[_ssi];
						switch(_ss.combinator) {
							case null:
								_match = this.matchSimpleSelector(_node, _ss.simpleselector, _dom);
								break;
							case " ":
								// descendent selector:
								// until root node is reached,
								// dig through parent nodes to find the element matching the current simpleselector
								_match = false;
								while(!_match && (_node = _node.parentNode)) {
									_match = this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom);
								}
								break;
							case "+":
								// adjacent sibling selector:
								// check if the previous sibling element matches
								_match = (_node = _node.previousSibling) ? this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom) : false;
								break;
							case "~":
								// indirect adjacent sibling selector:
								// check if one of the previous sibling elements match
								_match = false;
								while(!_match && (_node = _node.previousSibling)) {
									_match = this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom);
								}
								break;
							case ">":
								// child selector:
								// check if the parent element match
								_match = (_node = _node.parentNode) ? this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom) : false;
								break;
							case "*":
								// grandchild descendent selector:
								// until root node is reached,
								// dig through parent nodes to find the element matching the current simpleselector
								_match = false;
								if(_node = _node.parentNode) {
									while(!_match && (_node = _node.parentNode)) {
										_match = this.matchSimpleSelector(_node.obj, _ss.simpleselector, _dom);
									}
								}
								break;
							default:
								_match = false;
								break;
						}
						if(!_match) {
							break;
						}
					}
					// break if match found
					/*
					if(_match) {
						trace("###match! " + name + " " + _ptysx.oRuleSet.declarations[_ptysx.idxDecl].expr[0].value);
						return _ptysx.oRuleSet.declarations[_ptysx.idxDecl].expr;
					}
					*/
				}
			}
			// break if match found
			if(_match) {
				//trace("###match! " + name);
				return _ptysx.oRuleSet.declarations[_ptysx.idxDecl].expr;
			}
		}
	}
	return null;
}


DENG.CCss.prototype.matchSimpleSelector = function(obj, ss, dom)
{
	var _match = true;
	var _sl = ss.length;
	// loop subselectors in simple selector
	for(var i = 0; _match && i < _sl; i++) {
		var _ssi = ss[i];
		/*
		if(_ssi.type != 20 && obj.cssPseudoClass != undefined) {
			trace(obj.toString() + " " + _ssi.type + " " + _ssi.name + " ######");
			return false;
		}
		*/
		//trace(obj.toString() + " " + _ssi.type + " " + _ssi.name);
		switch(_ssi.type) {
			case 0:
				// check selector (no namespace)
				if(_ssi.name != "*" && _ssi.name != obj.node.nsNodeName) {
					_match = false;
				}
				break;
			case 1:
				// check selector (namespace)
				if(_ssi.prefix == null) {
					if(obj.node.nsUri != undefined) {
						_match = false;
					} else {
						_match = (_ssi.name == "*" || _ssi.name == obj.node.nsNodeName);
					}
				} else {
					if(_ssi.prefix == "*") {
						_match = (_ssi.name == "*" || _ssi.name == obj.node.nsNodeName);
					} else {
						_match = (dom.namespace[_ssi.prefix] == obj.node.nsUri) && (_ssi.name == "*" || _ssi.name == obj.node.nsNodeName);
					}
				}
				break;
			case 10:
				// check class selector
				// todo: namespaces (?), xhtml only (?)
				_match = false;
				var _a = obj.node.attributes.class.split(" ");
				for(var _j in _a) {
					if(_a[_j] == _ssi.class) {
						_match = true;
						break;
					}
				}
				break;
			case 11:
				// check attribute selector
				// todo: namespaces (?)
				switch(_ssi.operator) {
					case 0:
						// [att]
						// Match when the element sets the "att" attribute, whatever the value of the attribute
						if(_ssi.prefix == null) {
							_match = (obj.node.attributes[_ssi.name] != undefined);
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									_match = (_node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name] != undefined);
									if(_match) { break; }
								}
							}
						}
						break;
					case 1: 
						// [att=val]
						// Match when the element's "att" attribute value is exactly "val"
						if(_ssi.prefix == null) {
							_match = (node.attributes[_ssi.name] == _ssi.expr);
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									var _attval = _node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name];
									_match = (_node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name] == _ssi.expr);
									if(_match) { break; }
								}
							}
						}
						break;
					case 2:
						// [att~=val]
						// Match when the element's "att" attribute value is a space-separated list of "words", 
						// one of which is exactly "val". If this selector is used, the words in the value must 
						// not contain spaces (since they are separated by spaces). 
						if(_ssi.prefix == null) {
							_match = false;
							var _a = obj.node.attributes[_ssi.name].split(" ");
							for(var _i in _a) {
								if(_a[_i] == _ssi.expr) {
									_match = true;
									break;
								}
							}
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									var _a = _node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name].split(" ");
									for(var _i in _a) {
										if(_a[_i] == _ssi.expr) {
											_match = true;
											break;
										}
									}
									if(_match) { break; }
								}
							}
						}
						break;
					case 3:
						// [att|=val]
						// Match when the element's "att" attribute value is a hyphen-separated list of "words", 
						// beginning with "val". The match always starts at the beginning of the attribute value. 
						// This is primarily intended to allow language subcode matches (e.g., the "lang" 
						// attribute in HTML) as described in RFC 1766 
						if(_ssi.prefix == null) {
							_match = false;
							var _el = _ssi.expr.length;
							var _a = obj.node.attributes[_ssi.name].split(" ");
							for(var _i in _a) {
								if(_a[_i] == _ssi.expr || _a[_i].indexOf(_ssi.expr + "-") == 0) {
									_match = true;
									break;
								}
							}
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									var _el = _ssi.expr.length;
									var _a = _node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name].split(" ");
									for(var _i in _a) {
										if(_a[_i] == _ssi.expr || _a[_i].indexOf(_ssi.expr + "-") == 0) {
											// match if att value matches expr followed by "-"
											_match = true;
											break;
										}
									}
									if(_match) { break; }
								}
							}
						}
						break;
					case 4:
						// [att^=val] (CSS3)
						// Represents the att attribute whose value begins with the prefix "val"
						if(_ssi.prefix == null) {
							_match = (obj.node.attributes[_ssi.name].indexOf(_ssi.expr) == 0);
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									_match = (_node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name].indexOf(_ssi.expr) == 0);
									if(_match) { break; }
								}
							}
						}
						break;
					case 5:
						// [att$=val] (CSS3)
						// Represents the att attribute whose value ends with the suffix "val" 
						if(_ssi.prefix == null) {
							_match = (obj.node.attributes[_ssi.name].substr(obj.node.attributes[_ssi.name].length - _ssi.expr.length) == _ssi.expr);
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									var _attval = _node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name];
									_match = (_attval != undefined && _attval.substr(_attval.length - _ssi.expr.length) == _ssi.expr);
									if(_match) { break; }
								}
							}
						}
						break;
					case 6:
						// [att*=val] (CSS3)
						// Represents the att attribute whose value contains at least one instance of the substring "val"
						if(_ssi.prefix == null) {
							var _attval = obj.node.attributes[_ssi.name];
							_match = (_attval != undefined && _attval.indexOf(_ssi.expr) >= 0);
						} else {
							_match = false;
							var _node = obj.node;
							var _ns = dom.namespace[_ssi.prefix];
							for(var _i in _node.$xmlns) {
								if(_ssi.prefix == "*" || _node.$xmlns[_i] == _ns) {
									var _attval = _node.attributes[((_i == "0") ? "" : (_i + ":")) + _ssi.name];
									_match = (_attval != undefined && _attval.indexOf(_ssi.expr) >= 0);
									if(_match) { break; }
								}
							}
						}
						break;
				}
				break;
			case 12:
				// check pseudo class
				// (see method checkPseudos() in CWnd)
				_match = obj.checkPseudos(_ssi);
				break;
			case 13:
				// check id selector
				// we assume the ID attribute is always called "id"
				_match = (obj.node.attributes.id == _ssi.id);
				break;
			case 20:
				// check pseudo element
				// (see method checkPseudos() in CWnd)
				_match = obj.checkPseudos(_ssi);
				break;
			default:
				_match = false;
				break;
		}
	}
	return _match;
}



DENG.CCss.prototype.parse = function(delay)
{
	with(this) {
		// parse inline styles
		if($inlineParser) {
			dom.propertyDefs.init(callback.parentNode == null);
			$inlineParser.parseInlineAttr($queueInlineAttr);
			var _ql = $queueInline.length;
			for(var i = 0; i < _ql; i++) {
				$inlineParser.parseInline($queueInline[i]);
			}
		}
		// parse external/internal styles
		if($queue.length) {
			// initialize properties
			dom.propertyDefs.init(callback.parentNode == null);
			if(delay) {
				$parseDelay = delay;
				if(this.$ivid == undefined) {
					this.$ivid = setInterval(this, "$doparse", delay);
				}
			} else {
				$doparse();
			}
		} else {
			delete $queue;
			onParse(true);
		}
	}
}


DENG.CCss.prototype.onParse = function(success) { /* overwrite this method */ }


DENG.CCss.prototype.cleanUp = function()
{
	var _pt = this.dom.propertyTable;
	for(var i in _pt) {
		var _pty = _pt[i];
		for(var s in _pty) {
			var _ptys = _pty[s];
			for(var x in _ptys) {
				var _ptysx = _ptys[x];
				delete _ptysx.oRuleSet.selectors[_ptysx.idxSel];
				delete _ptysx.oRuleSet.selectors;
				delete _ptysx.oRuleSet.declarations[_ptysx.idxDecl];
				delete _ptysx.oRuleSet.declarations;
				delete _ptysx.oRuleSet;
				delete _ptysx.idxSel;
				delete _ptysx.idxDecl;
			}
			delete _ptys;
		}
		delete _pty;
	}
	delete _pt;
	var _pti = this.dom.propertyTableInline;
	for(var i in _pti) {
		delete _pti[i];
	}
	delete _pti;
	this.dom.propertyDefs.cleanUp();
	this.$parser.cleanUp();
	this.$inlineParser.cleanUp();
	delete this.$parser;
	delete this.$inlineParser;
	delete this.dom.propertyDefs;
	delete this.dom;
	delete this.$queueInline;
}



//
//  CCss private methods
//

DENG.CCss.prototype.$doparse = function()
{
	if(this.$ivid != undefined) {
		clearInterval(this.$ivid);
		delete this.$ivid; this.$ivid = undefined;
	}
	var _o = this.$queue[0];
	_o.obj.onParse = function(s) { this.callback.$onparse(s); };
	switch(_o.type) {
		case 0:
			// external
			_o.obj.load(_o.uri);
			break;
		case 1:
			// internal
			_o.obj.parse(_o.css);
			break;
	}
}

DENG.CCss.prototype.$onparse = function(success)
{
	with(this) {
		$queue.splice(0, 1);
		if($queue.length) {
			parse($parseDelay);
		} else {
			onParse(success);
		}
	}
}	



