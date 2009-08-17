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
//   class DENG.CXForms_ITEMSET
// ===========================================================================================

DENG.CXForms_ITEMSET = function()
{
	super();
}

DENG.CXForms_ITEMSET.extend(DENG.CXFormsControlWnd);

DENG.CXForms_ITEMSET.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.css.dom.propertyTableAttr.display = "none";
	
	if (!this.check(this.xpath = this.node.attributes.nodeset)) {
		this.checkBinding = null;
		this.xmlDomRef.errorMsg("couldn't make sense out of this itemset: " +this.node);
	}
};
DENG.CXForms_ITEMSET.prototype.create = function()
{
	var children = this.childNodes;
	this.template = "<dengxf:item xmlns:dengxf='http://www.w3.org/2002/xforms/cr'>";
	for (var i = 0; i < children.length; i++) {
		this.template += children[i].node;
	}
	this.template += "</dengxf:item>";
	super.create();
	//this.xmlDomRef.infoMsg(this.template);
};
DENG.CXForms_ITEMSET.prototype.size = function()
{
	super.size();
};
DENG.CXForms_ITEMSET.prototype.checkBinding = function () 
{
    return true;
};

DENG.CXForms_ITEMSET.prototype.createControl = function()
{
	var context = this.binding.boundNodes;
	var choices = this.parentNode;
	var select = this.controller = choices.parentNode;
	//this.xmlDomRef.infoMsg("choices: " +choices);
	//this.xmlDomRef.infoMsg("select: " +select);
	for (var i = 0; i < context.length; i++) {
		var item = this.xmlDomRef.createNodeTree(this.template, this.node.$xmlns);
		//item.createElementWrapper = XMLNode.prototype.createElementWrapper;
		var wrapper = item.createElementWrapper(choices);
		wrapper.controller = select;
		wrapper.model = this.model;
		wrapper.getModel = function () {return true;}
		wrapper.itemset = this;
		wrapper.itemsetcontext = {contextNode: context[i], nodeSet: context};
		wrapper.getContext = function () {return this.itemsetcontext;}
		// add the wrapper for the fake node to UI DOM
		wrapper.regChildnode(choices, item);
	}
};

