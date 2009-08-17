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
//   interface DENG.IXFormsHostDoc
// ===========================================================================================

DENG.IXForms_HostDoc = {};

DENG.IXForms_HostDoc.initXFormsHostDoc = function ()
{
	this.$enableErrorAlerts = true;
	this.$enableInfoAlerts  = true;
	this.$enableDebugAlerts = false;

	this.models = [];
	this.binds = [];
	this.submissions = [];
	this.repeats = [];
	this.repeatlist = [];
	
	// XForms helper constants
	Event.XFORMS_MODEL_CONSTRUCT      = "xforms-model-construct";
	Event.XFORMS_MODEL_CONSTRUCT_DONE = "xforms-model-construct-done";
	Event.XFORMS_READY                = "xforms-ready";
	Event.XFORMS_DEBUG                = "xforms-debug";
	Event.XFORMS_SUBMIT               = "xforms-submit";
	// TODO: this should go in another module
	Event.CLICK                       = "click";
	
	// setup event prototypes for XForms
	if (Event.protos == undefined) Event.protos = [];
	with (Event) {
		//0: bubbles
		//1: cancelable
		protos[XFORMS_MODEL_CONSTRUCT]            = [true, false];
		protos[XFORMS_MODEL_CONSTRUCT_DONE]       = [true, false];
		protos[XFORMS_READY]                      = [true, false];
		protos[XFORMS_DEBUG]                      = [true, true];
		protos[XFORMS_SUBMIT]                     = [true, true];
		protos[CLICK]                             = [true, true];
	}
	
	// initialize done
	this.$isXFormsHostDoc = true;
	// workaround for a Flash Player 7 beta bug
	XPathParser.AxisFunctions[0] = "root";
};

DENG.IXForms_HostDoc.getInstance = function (ID) {
	var i, ret = null;
	for (i in this.models) {
	    ret = this.models[i].getInstance(ID);
	    if (ret) return ret.documentElement;
	}
	return null;
};

DENG.IXForms_HostDoc.addModel = function (model) 
{
	var ID = model.node.attributes.id;
	if ((ID == undefined) && (this.models["$default"] == undefined)) {
		var ID = "$default";
	}
	if (ID != undefined) {
		this.models[ID] = model;
		if (this.defaultModel == undefined) this.defaultModel = model;
	} else {
		this.errorMsg("ignoring a model element");
	}
};

DENG.IXForms_HostDoc.getModel = function(ID)
{
	if (ID == undefined) {
		return (this.defaultModel == undefined) ? null : this.defaultModel;
	} else {
		return (this.models[ID] == undefined) ? null : this.models[ID];
	}
};

DENG.IXForms_HostDoc.addBind = function (ID, bind) 
{
	if (ID != undefined) this.binds[ID] = bind;
};
DENG.IXForms_HostDoc.getBind = function (ID) 
{
	var ret = this.binds[ID];
	return (ret == undefined) ? null : ret;
};
DENG.IXForms_HostDoc.addSubmission = function (ID, submission) 
{
	if (ID != undefined) this.submissions[ID] = submission;
};
DENG.IXForms_HostDoc.getSubmission = function (ID) 
{
	var ret = this.submissions[ID];
	return (ret == undefined) ? null : ret
};
DENG.IXForms_HostDoc.addRepeat = function (ID, repeat) 
{
	if (ID != undefined) {
		this.repeats[ID] = repeat;
		this.repeatlist.push(repeat);
	}
};
DENG.IXForms_HostDoc.getRepeat = function (ID) 
{
	var ret = this.repeats[ID];
	return (ret == undefined) ? null : ret;
};

// this is a factory for XForms events
// NOTE: this is NOT like the DocumentEvent.createEvent() in optional part of DOM spec 
DENG.IXForms_HostDoc.createXFormsEvent = function (type) {
	var e = null, p = Event.protos[type];
	if (p != undefined) {
		e = new Event();
		e.initEvent(type, p[0], p[1]);
		this.debugMsg(type +" event created");
	}
	return e;
};
// utility for setting up fake XML node trees, out of which wrappers can be
// created for insertion in UI DOM without touching the original XML source DOM
DENG.IXForms_HostDoc.createNodeTree = function (t, inheritedNamespaces) {
	var tmp = new XML(t);
	if (inheritedNamespaces != undefined)
		tmp.$xmlns = inheritedNamespaces;
	tmp._xmlDomCallback = this;
	this.resolveNamespaces(tmp);
	var ret = {};
	var i, n = tmp.firstChild;
	for (i in n) {
		ret[i] = n[i];
	}
	ret.createElementWrapper = XMLNode.prototype.createElementWrapper;
	return ret;
};
// DOM Document.getElementById 
// XMLNode IXForms_HostDoc.getElementById(String ID)
// expects: the ID string to look for, the other optional parameter is private
// determines: the element with that id attribute
// returns: the XMLNode representing that element, otherwise null
DENG.IXForms_HostDoc.getElementById = function (ID, node) {
	if (node == undefined) {
		if (!this.check(ID)) {
			return null;
		} else if (this[ID] instanceof XMLNode && this[ID].attributes.id == ID) {
			// don't recurse if the Flash XML object trick for getting nodes by id works :-)
			return this[ID];
		}
		var node = this;
	}
	var a = node.attributes.id;
	if (this.check(a) && a == ID) {
		// are we the node with that ID?
		return node;
	} else {
		// if not, recurse children
		var c = node.firstChild, ret = null;
		while (c != null) {
			ret = this.getElementById(ID, c);
			if (ret != null) return ret;
			c = c.nextSibling;
		}
		return null;
	}
};

DENG.IXForms_HostDoc.check = DENG.CEventsWnd.prototype.check;
DENG.IXForms_HostDoc.resolveNamespaces = DENG.CXFormsWnd.prototype.resolveNamespaces;

DENG.IXForms_HostDoc.infoMsg = function (m) {
	if (this.$enableInfoAlerts) this.alert("INFO", m, "555555");
};

DENG.IXForms_HostDoc.errorMsg = function (m) {
	if (this.$enableErrorAlerts) this.alert("ERROR", m, "ff0000");
};

DENG.IXForms_HostDoc.debugMsg = function (m) {
	if (this.$enableDebugAlerts) this.alert("DEBUG", m, "0000ff");
};

DENG.IXForms_HostDoc.alert = function (c, m, color) {
	//m = m.substring(0,100)
	m = m +"";
	//m = m.split("'").join("`");
	c = "[" +c +"] ";
	//getURL("javascript:alert('" +m +"')");
	//_level0.deb_txt.text += m +"\n";
	if (_level0.ugodebug == "1") {
		mytrace(c +" " +m);
	} else {
		m = m.split("<").join("&lt;").split(">").join("&gt;");
		_level0.deb_txt.htmlText += '<textformat leading="1"><p><font face="_typewriter" color="#000000">' + c + '</font><font face="_typewriter" color="#' +color +'">' + m + '</font></p></textformat>';
	}
	trace(m);
};

