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
//   class DENG.CXForms_INSERT
// ===========================================================================================

DENG.CXForms_INSERT = function()
{
	super();
}

DENG.CXForms_INSERT.extend(DENG.CXFormsControlWnd);

DENG.CXForms_INSERT.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.css.dom.propertyTableAttr.display = "none";
	
};

DENG.CXForms_INSERT.prototype.create = function () {
	super.create();
};

DENG.CXForms_INSERT.prototype.size = function () {
	super.size();
};

DENG.CXForms_INSERT.prototype.createControl = null;

DENG.CXForms_INSERT.prototype.zeroItem = function (n) 
{
	if (n.nodeType == 3) {
		n.nodeValue = "";
	} else {
		var i, attrs = n.attributes;
		for (i in attrs) {
			if (i.indexOf("xmlns") != 0) {
				attrs[i] = "";
			}
		}
		n = n.firstChild;
		while (n != null) {
			this.zeroItem(n);
			n = n.nextSibling;
		}
	}
};

DENG.CXForms_INSERT.prototype.activate = function (e) 
{
	// determine the nodeset for insertion
	if (this.at == undefined) {
		this.createBinding();
		var attrs = this.node.attributes;
		this.at = attrs.at;
		this.pos = attrs.position;
	} else {
		this.updateBinding();
	}
	var items = this.binding.boundNodes;
	
	// determine the prototypical item (the last node in the nodeset)
	var item = items[items.length-1];
	var template = item.cloneNode(true);
	// reset it with empty values
	this.zeroItem(template);
	
	// determine insertion point modifier
	if (this.offset == undefined) {
		this.offset = (this.pos == "after") ? 1 : 0;
	}
	// determine the insertion point index
	var ctxt = this.getParentContext();
	var at = this.evalXPath(ctxt, this.at);
	var index = this.offset +at -1;
	
	// add the new node to the parent of the nodes in the nodeset
	//this.xmlDomRef.debugMsg("insert at: " +at);
	//this.xmlDomRef.debugMsg("invoking insertBefore " +item.parentNode.insertBefore +" newNode: " +template +"  beforeNode: " +items[index]);
	item.parentNode.insertBefore(template, items[index]);
	// initialize its namespace info
	this.resolveNamespaces(item.parentNode);
	
	// compare the nodeset
	// with the nodeset of all repeats in the document
	var r, repeat, repeats = this.xmlDomRef.repeatlist;
	for (r = 0; r < repeats.length; r++) {
		repeat = repeats[r];
		// if this repeat's nodeset is the same that we changed
		if (this.isSameNodeset(repeat.binding.boundNodes, this.binding.boundNodes)) {
			// determine new nodeset bound to this repeat
			repeat.updateBinding();
			// update repeat UI with new index after insertion
			if (this.offset) {
				repeat.setIndex(at+1, true);
			} else {
				repeat.setIndex(at, true);
			}
		}
	}
};

DENG.CXForms_INSERT.prototype.isSameNodeset = function (one, two) {
	var i, l = one.length;
	if (l != two.length) return false;
	for (i = 0; i < l; i++) {
		if (one[i] != two[i]) return false;
	}
	return true;
};
