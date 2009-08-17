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
//   class DENG.CXForms_SUBMISSION
// ===========================================================================================

DENG.CXForms_SUBMISSION = function()
{
	super();
}

DENG.CXForms_SUBMISSION.extend(DENG.CXFormsWnd);

DENG.CXForms_SUBMISSION.template="<dengxf:group xmlns:deng='http://claus.packts.net/deng' xmlns:dengxf='http://www.w3.org/2002/xforms/cr' xmlns='http://www.w3.org/1999/xhtml'>"
							+	  "<table cellpadding='0' cellspacing='0'><tr><td>"
							+     "<deng:location submission='$s'>"
							+         "<dengxf:label>Submission URL</dengxf:label>"
							+     "</deng:location></td>"
							+     "<td><deng:mediatype submission='$s'>"
							+         "<dengxf:label>Mediatype</dengxf:label>"
							+     "</deng:mediatype></td></tr>"
							+	  "</table>"
							+    "</dengxf:group>";

DENG.CXForms_SUBMISSION.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	var attrs = this.node.attributes;
	// must we keep track of what instance
	// in what model is to be replaced?
	var replace = this.replace = (attrs.replace == "instance");
	//this.xmlDomRef.infoMsg("must instance be replaced at submission?" +this.replace);
	// can we make any use of this submission?
	if (this.check(this.id = attrs.id)) {
		// OK add it to submissions known to host doc
		this.xmlDomRef.addSubmission(this.id, this);
		// make it listen to xforms-submit events
		this.addSubmitListener();
		// determine model info
		this.getModel();
		// setup serialization media type
		if (!this.check(this.mediatype = attrs.mediatype)) {
			// TODO:: check it to be compatible w/ application/xml
			this.mediatype = "application/xml";
		}
		// must we provide means to input a uri for submission?
		if (!this.check(this.url = attrs.action)) {
			// fill template with our data
			var template = DENG.CXForms_SUBMISSION.template.split("$s").join(this.id);
			// generate the objects DENG will create the wrappers of
			this.locationTree = this.xmlDomRef.createNodeTree(template);
			// NOTE: it may be necessary to add support for other 
			// host doc types: we handle XHTML and the generic case.
			// Are we in a XHTML doc?
			if (this.rootNode instanceof DENG.CXHTML_HTML) {
				// ui must be inserted under xhtml:BODY 
				if (this.xmlDomRef.blindSubmits == undefined) {
					this.xmlDomRef.blindSubmits = [];
					DENG.CXHTML_BODY.prototype._create = DENG.CXHTML_BODY.prototype.create;
					DENG.CXHTML_BODY.prototype.create = function () {
						var s, c = 0;
						while (s = this.xmlDomRef.blindSubmits.shift()) {
							var w = s.locationTree.createElementWrapper(this);
							w.regChildnode(this, s.locationTree, c++);
						}
						this._create();
						DENG.CXHTML_BODY.prototype.create = DENG.CXHTML_BODY.prototype._create;
					};
				}
				this.xmlDomRef.blindSubmits.push(this);
			 } else {
			 	// we insert the ui under the root element
				this.locationTree.createElementWrapper(this.rootNode).regChildnode(this.rootNode, this.locationTree, 0);
			 }
		}
	} else {
		this.xmlDomRef.errorMsg("the id attribute is missing on this submission: " +this.node);
		this.activate = this.replaceInstance = null;
	}
};
DENG.CXForms_SUBMISSION.prototype.progress = function() {
	with (this.$progresscontroller) {
		progressSetText(progressstates[dotcount % 3]);
		dotcount++;
	}
}

DENG.CXForms_SUBMISSION.prototype.activate = function(e)
{
	if (this.replace) {
		this.progressstates = ["Replacing instance .<b>.</b>.", "Replacing instance ..<b>.</b>", "Replacing instance <b>.</b>.."];
		this.dotcount = 0;
		this.progressCreate("Replacing instance <b>.</b>..");
		this.rootNode.mc.$progresscontroller = this;
		this.rootNode.mc.onEnterFrame = this.progress;
	}
	// setup HTTP response callback object
	var response = new XML();
	response.callback = this;
	response.onLoad = function (success) {
		if (success) {
			this.callback.xmlDomRef.infoMsg("instance replaced");
    		this.callback.replaceInstance(this); 
		} else {
			this.callback.xmlDomRef.errorMsg("error while loading new instance");
		}
		this.callback.progressDestroy();
		this.callback.rootNode.mc.onEnterFrame = null;
		delete this.callback.rootNode.mc.$progresscontroller;
	};
	// determine the instance data to be submitted
	var instance = this.model.defaultInstance;
	if (this.check(this.xpath = this.node.attributes.ref)) {
		var ctxt = instance.documentElement;
		this.xmlDomRef.infoMsg("using context node: " +ctxt.nodeName);

		// setup namespace context for XPath expression parsing
		var p, ns = this.node.$xmlns, nscontext = {};
		for (p in ns) nscontext[p] = ns[p];
		delete nscontext["0"];

		// do XPath evaluation
		this.boundNodes = ctxt.selectNodes(this.xpath,nscontext,this.xmlDomRef);

		// setup binding and new XPath context
		this.boundNode = (this.boundNodes.length > 0) ? this.boundNodes[0] : null;
		// TODO:: this is a quirk to get the upload tool to work for any
		// kind of file (not only XML) but it will be removed as soon as the
		// XPath engine is completed
		var instancetext = "", node = this.boundNode.firstChild;
		do {
			instancetext += node.toString();
		} while (node = node.nextSibling);
		//this.xmlDomRef.infoMsg("submitting instance: " +instance.prolog +instancetext);
		var request = new XML(instance.prolog +instancetext);
	} else {
		//this.xmlDomRef.infoMsg("submitting instance: " +instance.prolog +instance.documentElement);
		var request = new XML(instance.prolog +instance.documentElement);
	}
	// do HTTP POST!
	this.xmlDomRef.infoMsg("submitting to: " +this.url);
	request.contentType = this.mediatype;
	if (_level0.debugfpv != undefined) {
		var url = this.url +"?fpv=" +System.capabilities.version;
	} else {
		var url = this.url;
	}
	if (this.replace) {
		request.sendAndLoad(url, response);
	} else {
		if (this.check(this.node.attributes.target)) {
			var target = this.node.attributes.target;
		} else {
			var target = "_self";
		}
		request.send(url, target);
	}
};

// parse new instance and update all bindings and UIs
DENG.CXForms_SUBMISSION.prototype.replaceInstance = function(newInstance)
{
	var controls = XPathUtils.cloneArray(this.model.controls);
	this.model.controls = [];
	this.model.defaultInstance.parseInstance(newInstance);
	while (controls.length) {
		var control = controls.shift();
		if (control.bound) {
			// TODO: refactor to avoid this check on all controls
			// if the control is a repeat, reset its index
			if (control instanceof DENG.CXForms_REPEAT) control.index = 1;
			// update control binding
			control.updateBinding();
			// update control UI
			control.updateControl();
			this.model.controls.push(control);
		}
	}
};

// listen to submit events for this submission
DENG.CXForms_SUBMISSION.prototype.addSubmitListener = function()
{
	this.observer = this.handler = this;
	this.phase = "";
	this.addEventListener(Event.XFORMS_SUBMIT, this, false);
};



DENG.CXForms_SUBMISSION.prototype.progressCreate = function (txt)
{
	if(_level0.progress == undefined || _level0.progress == "1") {
		if(_level0.$$progressCreated == undefined || _level0.$$progressCreated == false) {
			_level0.$$progressCreated = true;
			_level0.createEmptyMovieClip("$$progressMC", 90000);
			var _mc = _level0.$$progressMC;
			_mc.createTextField("__head", 500, 5, 2, 150, 10);
			var _label = _mc.__head;
			_label.autoSize = "left";
			_label.html = true;
			//_label.embedFonts = true;
			_label.multiline = true;
			_label.selectable = true;
		}
		if(txt.length > 0) {
			this.progressSetText(txt);
		}
	}
}

DENG.CXForms_SUBMISSION.prototype.progressDestroy = function ()
{
	if(_level0.progress == undefined || _level0.progress == "1") {
		if(_level0.$$progressCreated) {
			delete _level0.$$progressCreated;
			_level0.$$progressMC.removeMovieClip();
		}
	}
}

DENG.CXForms_SUBMISSION.prototype.progressPosition = function ()
{
	if(_level0.progress == undefined || _level0.progress == "1") {
		if(_level0.$$progressCreated) {
			var _mc = _level0.$$progressMC;
			var _h = (_level0.$debugViewHeight != undefined) ? Stage.height-_level0.$debugViewHeight : Stage.height;
			_mc._x = Math.round((Stage.width - _mc._width) / 2);
			_mc._y = Math.round((_h - _mc._height) / 2);
		}
	}
}

DENG.CXForms_SUBMISSION.prototype.progressSetText = function (txt)
{
	if(_level0.progress == undefined || _level0.progress == "1") {
		if(_level0.$$progressCreated) {
			var _mc = _level0.$$progressMC;
			var _label = _mc.__head;
			_label.htmlText = '<textformat leading="0"><p><font face="_sans" size="12">Mozquito DENG</font><br><font face="_sans" color="#006600" size="12">' + txt + "</font></p></textformat>";
			var _w = 150; //_label._width + 10;
			_mc.clear();
			_mc.lineStyle(2, 0xe8e8e8, 100);
			_mc.beginFill(0xf8f8f9, 100);
			_mc.moveTo(0, 0);
			_mc.lineTo(_w, 0);
			_mc.lineStyle(2, 0x666666, 100);
			_mc.lineTo(_w, _label._height+5);
			_mc.lineTo(0, _label._height+5);
			_mc.lineStyle(2, 0xe8e8e8, 100);
			_mc.lineTo(0, 0);
			_mc.endFill();
			this.progressPosition();
		}
	}
}



