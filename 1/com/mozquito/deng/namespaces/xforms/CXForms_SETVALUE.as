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
//   class DENG.CXForms_SETVALUE
// ===========================================================================================

DENG.CXForms_SETVALUE = function()
{
	super();
}

DENG.CXForms_SETVALUE.extend(DENG.CXFormsControlWnd);

DENG.CXForms_SETVALUE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.css.dom.propertyTableAttr.display = "none";
	
};

DENG.CXForms_SETVALUE.prototype.create = function () {
	super.create();
};

DENG.CXForms_SETVALUE.prototype.createControl = null;

DENG.CXForms_SETVALUE.prototype.activate = function (e) {
	if (this.myactivate == undefined) {
		if (this.check(this.valueXPath = this.node.attributes.value)) {
			this.myactivate = this.dynamicActivate;
		} else {
			this.myactivate = this.staticActivate;
		}
		this.createBinding();
	} else {
		this.updateBinding();
	}
	this.myactivate();
}

DENG.CXForms_SETVALUE.prototype.dynamicActivate = function (e) 
{
	var value = this.evalXPath(this.getParentContext(), this.valueXPath);
	//trace("SETVALUE new value is: " +value)
	this.binding.instanceValue = value;
	this.updateInstance();
};

DENG.CXForms_SETVALUE.prototype.staticActivate = function (e) 
{
	if (this.staticValue == undefined) {
		var value = "";
		var t = this.node.firstChild;
		do {
			if (t.nodeType == 3) value += t.nodeValue;
		} while (t = t.nextSibling);
		this.staticValue = value;
	}
	//trace("SETVALUE new value is: " +value)
	this.binding.instanceValue = this.staticValue;
	this.updateInstance();
};
