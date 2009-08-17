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
//   class DENG.CXFormsWnd
// ===========================================================================================

DENG.CXFormsWnd=function(){super();};

DENG.CXFormsWnd.extend(DENG.CEventsWnd);

DENG.CXFormsWnd.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);

	// default css for XForms elements is display: none
	this.css.dom.propertyTableAttr.display = "none";

	// initialize XPath XForms context
	this.context = null;

	// if we are the first XForms element of the doc
	// initialize CDom to become an XForms Host Doc
	// do this only first time, then replace initialize method
	//if (this.xmlDomRef.$isXFormsHostDoc == undefined) this.initXFormsHostDoc();
	this.initXFormsHostDoc();
	DENG.CXFormsWnd.prototype.initialize = function (node, parent) {
		// initialize element wrapper
		super.initialize(node, parent);
		// default css for XForms elements is display: none
		this.css.dom.propertyTableAttr.display = "none";
		// initialize XPath XForms context
		this.context = null;
		// debug
		//this.xmlDomRef.infoMsg("**********" +node.nsNodeName.toUpperCase() +"**********\n" +node);
	};
	
	// debug
	//this.xmlDomRef.infoMsg("**********" +node.nsNodeName.toUpperCase() +"**********\n" +node);
};

DENG.CXFormsWnd.prototype.create=function(){super.create();};
DENG.CXFormsWnd.prototype.size=function(){super.size();};
DENG.CXFormsWnd.prototype.position=function(){return super.position();};
DENG.CXFormsWnd.prototype.paint=function(){super.paint();};

// boolean CXFormsWnd.doBind()
// expects: the binding xpath to be already found
// determines: the bound node(s) (and the new context)
// setups: the instance listeners
// returns: true
DENG.CXFormsWnd.prototype.doBind = function () 
{
	with (this) {
		// get our XForms XPath context
		var ctxt = getParentContext();
		//trace("using context node: " +ctxt.contextNode.nodeName)
		
		// setup namespace context for XPath expression parsing
		var p, ns = node.$xmlns, nscontext = {};
		for (p in ns) nscontext[p] = ns[p];
		delete nscontext["0"];
		
		// do XPath evaluation
		this.boundNodes = ctxt.contextNode.selectNodes(xpath,nscontext,xmlDomRef);
		//this.boundNodes = this.evalXPath(ctxt, xpath)
		
		// setup binding and new XPath context
		this.boundNode = (boundNodes.length > 0) ? boundNodes[0] : null;
		this.context = {contextNode: boundNode, nodeSet: boundNodes};
		
		// determine instance value and setup instance listeners
		if (boundNode) {
			var type = boundNode.nodeType;
			switch (type) {
				case 1:
					this.instanceValue = boundNode.firstChild.nodeValue;
					boundNode.addListenerUI(this);
					break;
				case 5:
					// workaround for attribute nodes not being an XMLNode 
					// TODO: unnecessary recalculations may happen, refactor 
					this.instanceValue = boundNode.parentNode.attributes[boundNode.nodeName];
					boundNode.parentNode.addListenerUI(this);
					break;
				case 3: 
					this.instanceValue = boundNode.nodeValue;
					this.boundNode = boundNode.parentNode;
					boundNode.addListenerUI(this);
					break;
				// TODO:: handle root
			}
			//this.xmlDomRef.infoMsg("OK: the current value of this control is: " +this.instanceValue);
		} /*else {
			this.xmlDomRef.infoMsg("OK: the current value of this control is not a string");
		}*/
		//this.xmlDomRef.infoMsg(this.node.nsNodeName +" ## bound node: " +boundNode +"  ### bound nodes: " +boundNodes);
		return true;
	}
};

// this is called only once by the first XForms element in the doc that gets initialized
// makes the DENG DOM be an XForms host document by adding some methods to it and initializing it
DENG.CXFormsWnd.prototype.initXFormsHostDoc = function () 
{
	// fast access to members, interface and document
	var m, i = DENG.IXForms_HostDoc, d = this.xmlDomRef;
	// copy interface members to CDom document
	for (m in i) d[m] = i[m];
	// initialize CDom to be an XForms Host Document
	d.initXFormsHostDoc();
	this.xmlDomRef.debugMsg("The xml document has been initialized to be an XForms host document after an XForms element was found in it");
};
// NOTE: this is overridden by CXFormsControlWnd to return a boolean               
// TODO: refactor to make sure they have similar signatures
DENG.CXFormsWnd.prototype.getModel = function () 
{
	return (this.model) ? this.model : this.model = this.parentNode.model;
};

DENG.CXFormsWnd.prototype.resolveNamespaces = function (node) {
	if (node._xmlDomCallback == undefined) {
		node._xmlDomCallback = node.parentNode._xmlDomCallback;
	}
	node.resolveNamespaces();
	if (node = node.firstChild) {
		do  {
			this.resolveNamespaces(node);
		} while (node = node.nextSibling);
	}
};

// evaluate an XPath expression as if it was a predicate
DENG.CXFormsWnd.prototype.evalXPath = function (c, xpath) {
	return XPathPredicate.evaluate(c.contextNode, xpath, c.nodeSet, XPathPredicate.parse(xpath));
};
