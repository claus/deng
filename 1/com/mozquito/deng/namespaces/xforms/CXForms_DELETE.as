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
//   class DENG.CXForms_DELETE
// ===========================================================================================

DENG.CXForms_DELETE = function()
{
	super();
}

DENG.CXForms_DELETE.extend(DENG.CXFormsControlWnd);

DENG.CXForms_DELETE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.css.dom.propertyTableAttr.display = "none";
	
};

DENG.CXForms_DELETE.prototype.create = function () {
	super.create();
};

DENG.CXForms_DELETE.prototype.size = function () {
	super.size();
};

DENG.CXForms_DELETE.prototype.createControl = null;

DENG.CXForms_DELETE.prototype.zeroItem = DENG.CXForms_INSERT.prototype.zeroItem;

DENG.CXForms_DELETE.prototype.activate = function (e) 
{
	// determine the nodeset to be modified
	if (this.at == undefined) {
		this.createBinding();
		this.at = this.node.attributes.at;
	} else {
		this.updateBinding();
	}
	var items = this.binding.boundNodes;
	
	// determine the index for deletion
	var ctxt = this.getParentContext();
	var at = this.evalXPath(ctxt, this.at);
	var isLast = (at == items.length);
	
	// remove the node
	//this.xmlDomRef.infoMsg("delete at: " +at);
	if (items.length > 1) {
		items[--at].removeNode();
	} else {
		this.zeroItem(items[0]);
	}
	
	// compare the nodeset
	// with the nodeset of all repeats in the document
	var nodes = this.binding.boundNodes;
	var length = nodes.length;
	var r, repeat, repeats = this.xmlDomRef.repeatlist;
	for (r = 0; r < repeats.length; r++) {
		repeat = repeats[r];
		// if this repeat's nodeset is the same that we changed
		if (this.isSameNodeset(repeat.binding.boundNodes, nodes)) {
			// determine new nodeset bound to this repeat
			repeat.updateBinding();
			// update repeat UI with new index after deletion
			if (length) {
				if (isLast) {
					repeat.setIndex(repeat.index-1, true);
				} else {
					repeat.setIndex(repeat.index, true);
				} 
			} else {
				repeat.index = 0;
				repeat.updateControl();
			}
		}
	}
};

DENG.CXForms_DELETE.prototype.isSameNodeset = function (one, two) {
	var i, l = one.length;
	if (l != two.length) return false;
	for (i = 0; i < l; i++) {
		if (one[i] != two[i]) return false;
	}
	return true;
};
