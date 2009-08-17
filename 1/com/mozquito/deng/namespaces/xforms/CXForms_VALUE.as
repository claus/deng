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
//   class DENG.CXForms_VALUE
// ===========================================================================================

DENG.CXForms_VALUE = function()
{
	super();
}

DENG.CXForms_VALUE.extend(DENG.CXFormsControlWnd);

DENG.CXForms_VALUE.prototype.initialize = function(node, parent)
{
	this.bindingRequired = false;
	// initialize element wrapper
	super.initialize(node, parent);
		
	this.css.dom.propertyTableAttr.display = "none";
	
};

DENG.CXForms_VALUE.prototype.create = function()
{
	super.create();
	if (this.bound) {
		this.parentNode.valueText = this.binding.instanceValue;
	} else {
		var value = "";
		var n = this.node.firstChild;
		do { value += n.nodeValue;}
		while (n = n.nextSibling);
		this.parentNode.valueText = value;
	}
};

DENG.CXForms_VALUE.prototype.size = function()
{
	super.size();
};

