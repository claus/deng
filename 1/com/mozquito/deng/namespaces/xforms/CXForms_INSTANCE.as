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
//   class DENG.CXForms_INSTANCE
// ===========================================================================================

DENG.CXForms_INSTANCE = function()
{
	super();
}

DENG.CXForms_INSTANCE.extend(DENG.CXFormsWnd);

// TODO :: add default wrapper root if missing
DENG.CXForms_INSTANCE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	this.model = this.getModel();
	var src = this.node.attributes.src;
	if (this.check(src)) {
	    // fetch external instance
	    this.load(src);
	} else {
	    // fetch internal instance copying namespace context and free some mem by
		// removing unneeded nodes from original doc (they are display:none anyway)
	    this.parseInstance(this.node, this.node.$xmlns);
		this.removeChildren();
	}
	this.model.addInstance(this);
};

DENG.CXForms_INSTANCE.prototype.parseInstance = function (instance, inheritedNamespaces) 
{
	this.prolog = (instance.xmlDecl == undefined) ? "" : instance.xmlDecl;
	instance = this.getFirstChildElement(instance);
	// save instance text hard copy
	this.initialDoc = instance.toString();
	// parse it
	this.instanceDoc = new XML();
	//this.instanceDoc.ignoreWhite = true
	this.instanceDoc.parseXML(this.initialDoc);
	// root tag, default XPath context
	this.documentElement = this.instanceDoc.firstChild;
	// resolve namespaces context
	if (inheritedNamespaces != undefined) {
		// copy namespace scope
		this.instanceDoc.$xmlns = inheritedNamespaces;
	}
	// resolve the whole instance doc's namespaces
	this.resolveNamespaces(this.documentElement);
	this.instanceDoc.xmlDomRef = this.xmlDomRef;
};

DENG.CXForms_INSTANCE.prototype.getFirstChildElement = function (node) {
	node = node.firstChild;
	while (node.nodeType != 1) node = node.nextSibling;
	return node;
};

DENG.CXForms_INSTANCE.prototype.load = function (src) {
	var loader = new XML();
	loader.callback = this;
	loader.onLoad = function (success) {
		if (success) this.callback.parseInstance(this);
	};
	
	var _u = new DENG.CUri(src, this.getBaseUrl());
	
	// convert uri (add no-cache-var if document is not local)
	var _d = new Date();
	if(_u.$querySplit != undefined) { delete _u.$querySplit.c; }
	if(_u.$scheme != "file") { _u.addQueryVar("c", Math.round(Math.random() * _d * 100)); }
	
	var url = _u.getLocator();
    mytrace("Loading instance: " +url);
	this.xmlDomRef.queue.addObject(20000, loader, url);
};

DENG.CXForms_INSTANCE.prototype.removeChildren = function () {
	var n, c = this.node.childNodes;
	while (n = c.pop()) n.removeNode();
};
