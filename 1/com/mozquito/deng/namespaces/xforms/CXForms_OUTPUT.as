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
//   class DENG.CXForms_OUTPUT
// ===========================================================================================

DENG.CXForms_OUTPUT = function()
{
	super();
}

DENG.CXForms_OUTPUT.extend(DENG.CXFormsControlWnd);

DENG.CXForms_OUTPUT.prototype.initialize = function(node, parent)
{
	this.bindingRequired = false;
	// initialize element wrapper
	super.initialize(node, parent);

	this.css.dom.propertyTableAttr.color =  0x999999;

	var attrs = this.node.attributes;
	// if we have a value attribute instead of normal binding
	if (!this.checkBinding() && this.check(this.xpath = attrs.value) && this.getModel(attrs.model)) {
		// setup xpath evaluation instead of binding
		this.binding = this;
		this.createBinding = this.updateBinding = function () {
			var result = this.evalXPath(this.getParentContext(), this.xpath);
			this.binding.instanceValue = XPathFunctions.toString(result);
			return true;
		}
	}
};

DENG.CXForms_OUTPUT.prototype.create = function()
{
	super.create();
};

DENG.CXForms_OUTPUT.prototype.setDefaultControlStyles = function(ctrlObj)
{
	var _pta = ctrlObj.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.whitespace = "pre";
}

DENG.CXForms_OUTPUT.prototype.size = function()
{
	super.size();
};

DENG.CXForms_OUTPUT.prototype.updateControl = function()
{
	this.control.text = this.binding.instanceValue;
};
