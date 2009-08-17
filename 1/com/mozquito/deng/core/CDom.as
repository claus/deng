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
//   class DENG.CDom
// ===========================================================================================

DENG.CDom = function(componentCallback, src)
{
	if(componentCallback) {
		// call super class constructor
		// in this case XML()
		super(src);
		// ignore whitespaces
		this.ignoreWhite = true;
		// callback to view
		this.callback = componentCallback;
		// array of user css uri's
		this.cssUser = [];
		
		this.$isCreated = false;
		this.$isRendering = false;
		this.$waitRendering = false;

		this.$enableDefaultStylesheets = true;
		this.$enableUserStylesheets = true;
		this.$enableAuthorStylesheets = true;
		
		this.$delay = 30;
		
		this.$title = "Untitled Document";
		
		this.counters = [];
	}
}

// create inheritence
DENG.CDom.prototype = new XML();

// callback handlers
DENG.CDom.prototype.onLoadXML = null;
DENG.CDom.prototype.onParseCSS = null;
DENG.CDom.prototype.onInitialize = null;
DENG.CDom.prototype.onCreate = null;
DENG.CDom.prototype.onSize = null;
DENG.CDom.prototype.onPosition = null;
DENG.CDom.prototype.onRender = null;
DENG.CDom.prototype.onClickHandler = null;
DENG.CDom.prototype.onScroll = null;
//DENG.CDom.prototype.onClickHandler = function(linkUrl, targetStyle, targetPosition, targetName) {
//	getURL(unescape(linkUrl), (targetStyle != "none") ? unescape(targetName) : "_self");
//};


DENG.CDom.prototype.load = function(src)
{
	if(this.$isRendering) {
		mytrace("isRendering", "CDom", "load");
		this.status = -100;
		this.onLoad(true);
		return;
	} else {
		this.$isRendering = true;
	}

	mytrace(src, "CDom", "load");
	
	// convert uri (add no-cache-var if document is not local)
	var _d = new Date();
	var _u = new DENG.CUri(src);
	if(_u.$querySplit != undefined) { delete _u.$querySplit.c; }
	if(_u.$scheme != "file") { _u.addQueryVar("c", Math.round(Math.random() * _d * 100)); }

	// save converted url (this is our document's base url)
	this.setBaseUrl(_u.getAbsolute(false,false));

	var _us = _u.getLocator();
	if(_us == null) {
		this.status = -110;
		this.onLoad(false);
		return;
	}

	this.$xmlUri = _us;
	
	mytrace(unescape(_us), "CDom", "load");
	// load the document
	// (call XML.load via super)
	super.load(_us);
}


DENG.CDom.prototype.onData = function(src)
{
	this.$xmlSource = src;

	super.onData(src);
}


DENG.CDom.prototype.onLoad = function(success)
{
	if(success && (this.status == 0 || this.status == undefined)) {
		// document loaded and parsed: 
		mytrace("document loaded [success:" + success + ", status:" + this.status + ", bytes:" + this.getBytesLoaded() + "]", "CDom", "onLoad");
		// notify component
		this.onLoadXML(success, this.status);
		// prepare to render
		this.init();
	} else {
		if(!success) {
			// load error
			mytrace("file not found", "CDom", "onLoad", 1);
		} else {
			var _err = "";
			switch(this.status) {
				case 0: _err = "No error; parse was completed successfully."; break;
				case -2: _err = "A CDATA section was not properly terminated."; break;
				case -3: _err = "The XML declaration was not properly terminated."; break;
				case -4: _err = "The DOCTYPE declaration was not properly terminated."; break;
				case -5: _err = "A comment was not properly terminated."; break;
				case -6: _err = "An XML element was malformed."; break;
				case -7: _err = "Out of memory."; break;
				case -8: _err = "An attribute value was not properly terminated."; break;
				case -9: _err = "A start-tag was not matched with an end-tag."; break;
				case -10: _err = "An end-tag was encountered without a matching start-tag."; break;
				case -100: _err = "Rendering in progress..."; break;
				default: _err = "An unknown error occured (" + this.status + ")"; break;
			}
			mytrace("xml parse error: " + _err, "CDom", "onLoad", 1);
		}
		this.onLoadXML(success, this.status);
	}
}


DENG.CDom.prototype.init = function()
{
	mytrace("initializing, prepare parsing css", "CDom", "init");

	var t = getTimer();

	// parse xml declaration for xml stylesheets
	mytrace("parsePIs [" + this.xmlDecl + "]", "CDom", "init");
	this.cssParseQueue = this.$parsePIs(this.xmlDecl);
	this.cssParseQueueObjects = [];

	// initialize generic loading queue 
	this.queue = new DENG.CQueue(2);
	this.queue.timeout = 3000;
	
	// create and initialize element wrappers
	this.uiDom = this.firstChild.createElementWrapper();
	this.onInitialize();

	// is a delay defined for the root elements namespace?
	if(this.uiDom.node.nsUri != undefined) {
		var _delay = DENG.$nsDelay[this.uiDom.node.nsUri];
		if(_delay != undefined) {
			this.$delay = _delay;
		}
	}

	mytrace("done [" + (getTimer()-t) + "ms]", "CDom", "init");

	// parse stylesheets for this document
	this.cssInit();
	this.cssParse();
}



DENG.CDom.prototype.cssInit = function() 
{
	var _active = false;

	if(this.$enableDefaultStylesheets == true) {
		// add user agent (default) stylesheets
		if(DENG.$nsDefaultCSS) {
			for(var _nsid in DENG.$nsDefaultCSS) {
				if(DENG.$nsDefaultCSS[_nsid].active) {
					this.uiDom.css.addInternalCSS(DENG.$nsDefaultCSS[_nsid].css);
					_active = true;
				}
			}
			if(_active) {
				this.cssParseQueueObjects.push(this.uiDom.css);
			}
		}
	}

	if(this.$enableUserStylesheets == true) {
		// add user stylesheets
		var _ul = this.cssUser.length;
		for(var i = 0; i < _ul; i++) {
			// add user css to root elements queue
			this.uiDom.css.addExternalCSS(this.cssUser[i]);
			if(!active) {
				// add root element's css to parse queue
				// (but only if its not already been added above)
				this.cssParseQueueObjects.push(this.uiDom.css);
			}
		}
	}
	
	if(this.$enableAuthorStylesheets == true) {
		// add author stylesheets
		var _pql = this.cssParseQueue.length;
		for(var i = 0; i < _pql; i++) {
			var _pqo = this.cssParseQueue[i];
			var _csso = _pqo.obj ? _pqo.obj.css : this.uiDom.css;
			switch(_pqo.type) {
				case 0: _csso.addExternalCSS(_pqo.uri); break;
				case 1: _csso.addInternalCSS(_pqo.css); break;
				case 2: _csso.addInlineCSS(_pqo.css); break;
				case 3: _csso.addInlineAttrCSS(_pqo.name, _pqo.value); break;
			}
			var _found = false;
			for(var j in this.cssParseQueueObjects) {
				if(this.cssParseQueueObjects[j] == _csso) {
					_found = true;
					break;
				}
			}
			if(!_found) {
				this.cssParseQueueObjects.push(_csso);
			}
		}
	}
	// debug only:
	if(this.cssParseQueueObjects.length == 0) {
		mytrace("no stylesheets found", "CDom", "cssInit");
	} else {
		mytrace("ready to parse css", "CDom", "cssInit");
	}
}



DENG.CDom.prototype.cssParse = function()
{
	if(this.$cssParseIntervalID != undefined) {
		clearInterval(this.$cssParseIntervalID);
		delete this.$cssParseIntervalID;
	}

	// check if there are css left to parse
	if(this.cssParseQueueObjects.length)
	{
		var _cq = this.cssParseQueueObjects[0];
		_cq.cssParseCallback = this;
		// prevent flash players 256 recursion overflow error:
		// break syncronous parsing for documents with many stylesheets (eg many presentation attributes in svg)
		if(this.cssParseQueueObjects.length % 30 == 0) {
			_cq.onParse = function() {
				// pop css object from queue
				this.cssParseCallback.cssParseQueueObjects.splice(0,1);
				// parse async
            this.cssParseCallback.$cssParseIntervalID = setInterval(this.cssParseCallback, "cssParse", (this.$delay ? this.$delay : 1));
			};
		} else {
			_cq.onParse = function() {
				// pop css object from queue
				this.cssParseCallback.cssParseQueueObjects.splice(0,1);
				// parse sync
				this.cssParseCallback.cssParse(); 
			};
		}
		_cq.parse();
	}
	else
	{
		// no css left in queue: we're done
		delete this.cssParseQueueObjects;
		mytrace("done [selectors:" + DENG.CSSPARSER_SELECTOR_COUNT + ", declarations:" + DENG.CSSPARSER_DECLARATION_COUNT + "]", "CDom", "cssParse");
		this.$cssParsed = true;
		this.onParseCSS();

		// start loading assets
		this.queue.run = true;
		// check loading status in checkQueueBeforeCreate()
		this.$checkQueueBCIntervalID = setInterval(this, "checkQueueBeforeCreate", 100);
	}
}



DENG.CDom.prototype.checkQueueBeforeCreate = function()
{
	if(this.queue.getPendingObjects(20000) == 0) {
		if(this.$checkQueueBCIntervalID != undefined) {
			clearInterval(this.$checkQueueBCIntervalID);
			delete this.$checkQueueBCIntervalID;
		}
		if(this.$delay) {
			this.$createIntervalID = setInterval(this, "create", this.$delay);
		} else {
			this.create();
		}
	}
}




DENG.CDom.prototype.create = function()
{
	if(this.$createIntervalID != undefined) {
		clearInterval(this.$createIntervalID);
		delete this.$createIntervalID;
	}
	var t = getTimer();
	
	this.uiDom.create();
	
	mytrace("done [" + (getTimer()-t) + "ms]", "CDom", "create");
	this.$isCreated = true;
	this.$isRendering = false;
	this.onCreate();
	this.$sizeIntervalID = setInterval(this, "size", 30);
}



DENG.CDom.prototype.size = function()
{
	if(this.$sizeIntervalID != undefined) {
		clearInterval(this.$sizeIntervalID);
		delete this.$sizeIntervalID;
	}
	if(this.$isCreated) {
		if(this.$isRendering) {
			this.$waitRendering = true;
			return false;
		} else {
			this.$isRendering = true;
			var t = getTimer();
			
			this.uiDom.size();
			
			mytrace("done [" + (getTimer()-t) + "ms]", "CDom", "size");
			this.$isSized = true;
			this.onSize();
			if(this.$delay) {
				this.$positionIntervalID = setInterval(this, "position", this.$delay);
			} else {
				this.position();
			}
			return true;
		}
	} else {
		return false;
	}
}


DENG.CDom.prototype.position = function()
{
	if(this.$positionIntervalID != undefined) {
		clearInterval(this.$positionIntervalID);
		delete this.$positionIntervalID;
	}
	var t = getTimer();
	
	this.uiDom.position();
	
	mytrace("done [" + (getTimer()-t) + "ms]", "CDom", "position");
	this.onPosition();
	if(this.$delay) {
		this.$paintIntervalID = setInterval(this, "paint", this.$delay);
	} else {
		this.paint();
	}
}


DENG.CDom.prototype.paint = function()
{
	if(this.$paintIntervalID != undefined) {
		clearInterval(this.$paintIntervalID);
		delete this.$paintIntervalID;
	}
	var t = getTimer();
	
	this.uiDom.paint();
	
	mytrace("done [" + (getTimer()-t) + "ms]", "CDom", "paint");
	//_root.dump()
	this.$isRendering = false;
	if(this.$waitRendering) {
		this.$waitRendering = false;
		this.size();
	} else {
		this.onRender();
	}
}






DENG.CDom.prototype.$parsePIs = function(src)
{
	var i = 0;
	var srcPI = "";
	// is next tag a PI?
	while(src.substring(i,i+2) == "<?") {
		i += 2;
		// get end of PI
		var j = src.indexOf("?>", i);
		if(j > 0) {
			// make it a normal xml tag, eg: <xml-stylesheet />
			// and add it to our src string
			srcPI += "<" + src.substring(i, j) + "/>";
			i = j + 2;
		}
	}
	// did we find PIs?
	if(srcPI.length > 0) {
		// wrap tags with dummy root element
		// and let the flash xml parser parse it
		var _xml = new XML("<pi>" + srcPI + "</pi>");
		var _cn = _xml.firstChild.childNodes;
		var _cnLen = _cn.length;
		var _a = [];
		for(var i = 0; i < _cnLen; i++) {
			if(_cn[i].nodeName.toLowerCase() == "xml-stylesheet" && _cn[i].attributes.type.toLowerCase() == "text/css") {
				// process uri
				var _d = new Date();
				var _u = new DENG.CUri(_cn[i].attributes.href, this.getBaseUrl());
				if(_u.$querySplit != undefined) {
					delete _u.$querySplit.c;
				}
				if(_u.$scheme != "file") {
					_u.addQueryVar("c", Math.round(Math.random() * _d * 100));
				}
				mytrace("added [" + _u.getAbsolute() + "]", "CDom", "$parsePIs");
				// register external stylesheet
				_a.push({ type: 0, uri: _u.getAbsolute() });
			}
		}
		return _a;
	} else {
		return [];
	}
}




DENG.CDom.prototype.getBaseUrl = function()
{
	return this.$baseUrl;
}

DENG.CDom.prototype.setBaseUrl = function(baseUrl)
{
	this.$baseUrl = baseUrl;
	return baseUrl;
}



DENG.CDom.prototype.getTitle = function()
{
	return this.$title;
}

DENG.CDom.prototype.setTitle = function(title)
{
	this.$title = title;
}



DENG.CDom.prototype.addUserStylesheet = function(uri)
{
	this.cssUser.push(new DENG.CUri(uri, DENG.$baseurl).getAbsolute());
}



DENG.CDom.prototype.cleanUp = function()
{
	this.dump(this.uiDom, "  ");
	this.firstChild.cleanUp();
	this.uiDom.cleanUp();
	for(_i in this.mc) {
		var _t = typeof this.mc[_i];
		if(_t == "movieclip" && _i != "boundingBox_mc") {
			this.mc[_i].removeMovieClip();
		}
	}
	_level0.__$DENG_TF$__.removeTextField();
}

DENG.CDom.prototype.dump = function(o, t)
{
	if(typeof o.$$$ == "undefined") {
		o.$$$ = true;
		for(var i in o) {
			var oit = typeof o[i];
			if(i != "$$$" && oit != "function") {
				//trace(t + i + " " + o[i] + " [" + oit + "]");
				if(oit == "object" || oit == "array") {
					this.dump(o[i], t + "  ");
					delete o[i];
				}
			}
		}
	} else {
		//trace("################crossreference!");
		delete o;
	}
}

DENG.CDom.prototype.getSource = function()
{
	var _src = "";
	var _decl = "";
	if(this.xmlDecl != undefined && this.xmlDecl != "") {
		_decl = "<textformat blockIndent=\"0\"><p><font face=\"_typewriter\" color=\"#888888\">" 
				+ this.xmlDecl.split("<").join("&lt;").split(">").join("&gt;") 
				+ "</font></p></textformat>";
	}
	var _doctype = "";
	if(this.docTypeDecl != undefined && this.docTypeDecl != "") {
		_doctype = "<textformat blockIndent=\"0\"><p><font face=\"_typewriter\" color=\"#888888\">" 
					+ this.docTypeDecl.split("<").join("&lt;").split(">").join("&gt;") 
					+ "</font></p></textformat>";
	}
	var _xml = this.firstChild.getSource();
	_src += _decl + _doctype + _xml;
	return _src;
}

