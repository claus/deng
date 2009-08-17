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
//   class DENG.CXForms_LABEL
// ===========================================================================================

DENG.CXForms_LABEL = function()
{
	super();
}

DENG.CXForms_LABEL.extend(DENG.CXFormsControlWnd);

DENG.CXForms_LABEL.prototype.initialize = function(node, parent)
{
	this.bindingRequired = false;
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.parentNode.label = this;
	
	/*if (this.parentNode.$cssnopadlabel == undefined)
		css.margintop = 6;
	*/
};
DENG.CXForms_LABEL.prototype.setDefaultLabelStyles = null;
DENG.CXForms_LABEL.prototype.create = function()
{
	super.create();
};

DENG.CXForms_LABEL.prototype.size = function()
{
	super.size();
};
