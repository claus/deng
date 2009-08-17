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
//   class DENG.CXForms_SETINDEX
// ===========================================================================================

DENG.CXForms_SETINDEX = function()
{
	super();
}

DENG.CXForms_SETINDEX.extend(DENG.CXFormsWnd);

DENG.CXForms_SETINDEX.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_SETINDEX.prototype.activate = function (e) {
	this.getModel();
	var attrs = this.node.attributes;
	this.repeatID = attrs.repeat;
	this.xpath = attrs.index;
	this.repeat = this.xmlDomRef.getRepeat(this.repeatID);
	var newIndex = this.evalXPath(this.getParentContext(), this.xpath);
	//this.xmlDomRef.infoMsg("setindex activated: new index: " +newIndex +" after eval: " +this.xpath +" on: " +this.getParentContext().contextNode);
	this.repeat.setIndex(newIndex);
};

DENG.CXForms_SETINDEX.prototype.getParentContext      = DENG.CXFormsControlWnd.prototype.getParentContext;
DENG.CXForms_SETINDEX.prototype.getParentBoundElement = DENG.CXFormsControlWnd.prototype.getParentBoundElement;
DENG.CXForms_SETINDEX.prototype.getModel              = DENG.CXFormsControlWnd.prototype.getModel;
