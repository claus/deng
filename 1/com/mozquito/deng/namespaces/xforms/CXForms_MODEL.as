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
//   class DENG.CXForms_MODEL
// ===========================================================================================

DENG.CXForms_MODEL = function()
{
	super();
}

DENG.CXForms_MODEL.extend(DENG.CXFormsWnd);

DENG.CXForms_MODEL.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	this.model = this;
	this.xmlDomRef.addModel(this);
	this.instances = [];
	this.controls = [];
};

DENG.CXForms_MODEL.prototype.addInstance = function (instance) 
{
	var ID = instance.node.attributes.id;
	if ((ID == undefined) && (this.instances["$default"] == undefined)) {
		var ID = "$default";
	}
	if (ID != undefined) {
		this.instances[ID] = instance;
		if (this.defaultInstance == undefined) this.defaultInstance = instance;
	} else {
		this.xmlDomRef.errorMsg("XForms error: ignoring an instance element");
	}
};

DENG.CXForms_MODEL.prototype.getInstance = function(ID)
{
	if (ID == undefined) {
		return (this.defaultInstance == undefined) ? null : this.defaultInstance;
	} else {
		return (this.instances[ID] == undefined) ? null : this.instances[ID];
	}
};

// returns outermost XPath binding context (it is called on default model)
DENG.CXForms_MODEL.prototype.getContext = function()
{
	var n = this.defaultInstance.documentElement;
	return {contextNode: n, nodeSet: [n]};
};
