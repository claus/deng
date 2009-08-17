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
//   class DENG.CXForms_TEXTAREA
// ===========================================================================================

DENG.CXForms_TEXTAREA = function() { super(); }

DENG.CXForms_TEXTAREA.extend(DENG.CXFormsControlWnd);

DENG.CXForms_TEXTAREA.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_TEXTAREA.prototype.create = function()
{
	super.create();
	
	var _txt = this.control;
	
	// tell our TextField Object it must be editable
	_txt.type = "input";

	// listen to keyboard input 
	_txt.addListener(this);
};

DENG.CXForms_TEXTAREA.prototype.setDefaultControlStyles = function(ctrlObj) 
{
	super.setDefaultControlStyles(ctrlObj);
	var _pta = ctrlObj.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.backgroundcolor = 0xffffff;
	_pta.bordertopstyle = _pta.borderrightstyle = _pta.borderbottomstyle = _pta.borderleftstyle = "inset";
	_pta.bordertopwidth = _pta.borderrightwidth = _pta.borderbottomwidth = _pta.borderleftwidth = 2;
	_pta.bordertopcolor = _pta.borderrightcolor = _pta.borderbottomcolor = _pta.borderleftcolor = 0xffffff;
	_pta.whitespace = "pre";
}

DENG.CXForms_TEXTAREA.prototype.size = function()
{
	super.size();
	this.control.$height = this.control.textHeight;
};

DENG.CXForms_TEXTAREA.prototype.onChangedDelay = function() 
{
	this.binding.instanceValue = this.control.text;
	this.updateInstance();
	this.checkSize();
};

DENG.CXForms_TEXTAREA.prototype.updateControl = function () {
	super.updateControl();
	this.checkSize();
};

DENG.CXForms_TEXTAREA.prototype.checkSize = function ()
{
	if(this.control.$height != this.control.textHeight) {
		this.control.$height = this.control.textHeight;
		// reflow
		this.xmlDomRef.size();
	}
};
