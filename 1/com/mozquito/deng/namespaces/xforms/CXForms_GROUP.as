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
//   class DENG.CXForms_GROUP
// ===========================================================================================

DENG.CXForms_GROUP = function()
{
	super();
}

DENG.CXForms_GROUP.extend(DENG.CXFormsControlWnd);

DENG.CXForms_GROUP.prototype.initialize = function(node, parent)
{
	this.bindingRequired = false;
	// initialize element wrapper
	super.initialize(node, parent);
	
	var css = this.css.dom.propertyTableAttr;
	css.bordertopstyle = css.borderrightstyle = css.borderbottomstyle = css.borderleftstyle = "solid";
	css.bordertopwidth = css.borderrightwidth = css.borderbottomwidth = css.borderleftwidth = 1;
	css.bordertopcolor = css.borderrightcolor = css.borderbottomcolor = css.borderleftcolor = 0xcccccc;	
	css.paddingtop = css.paddingbottom = css.paddingleft = css.paddingright = css.margintop = css.marginbottom = 6;
	
};
DENG.CXForms_GROUP.prototype.create = function()
{
	super.create();
};
DENG.CXForms_GROUP.prototype.size = function()
{
	super.size();
};

DENG.CXForms_GROUP.prototype.createControl = null;

