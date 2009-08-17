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
//   class DENG.CXForms_INPUT
// ===========================================================================================

DENG.CXForms_INPUT = function() { super(); }

DENG.CXForms_INPUT.extend(DENG.CXFormsControlWnd);

DENG.CXForms_INPUT.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_INPUT.prototype.create = function()
{
	super.create();
	
	var _txt = this.control;
	
	// tell our TextField Object it must be editable
	_txt.type = "input";
	// single line only, no wordwrap, no autosize
	_txt.multiline = false;
	_txt.wordWrap = false;
	_txt.autoSize = "none";

	// listen to keyboard input 
	// TODO: this is keyboard only no cut-and-paste
	this.control.addListener(this);
};

DENG.CXForms_INPUT.prototype.setDefaultControlStyles = function(ctrlObj) 
{
	var _pta = ctrlObj.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.backgroundcolor = 0xffffff;
	_pta.bordertopstyle = _pta.borderrightstyle = _pta.borderbottomstyle = _pta.borderleftstyle = "inset";
	_pta.bordertopwidth = _pta.borderrightwidth = _pta.borderbottomwidth = _pta.borderleftwidth = 2;
	_pta.bordertopcolor = _pta.borderrightcolor = _pta.borderbottomcolor = _pta.borderleftcolor = 0xffffff;
};

DENG.CXForms_INPUT.prototype.size = function()
{
	super.size();
};

DENG.CXForms_INPUT.prototype.onChanged = function() 
{
	this.binding.instanceValue = this.control.text;
	this.updateInstance();
};
