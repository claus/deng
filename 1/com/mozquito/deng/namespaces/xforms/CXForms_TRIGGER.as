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
//   class DENG.CXForms_TRIGGER
// ===========================================================================================

DENG.CXForms_TRIGGER = function()
{
	super();
}

DENG.CXForms_TRIGGER.extend(DENG.CXFormsControlWnd);

DENG.CXForms_TRIGGER.prototype.initialize = function(node, parent)
{
	this.bindingRequired = false;
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_TRIGGER.prototype.setDefaultControlStyles = function(ctrlObj) 
{
	var css = ctrlObj.css.dom.propertyTableAttr;
	css.bordertopstyle = css.borderrightstyle = css.borderbottomstyle = css.borderleftstyle = "outset";
	css.bordertopwidth = css.borderrightwidth = css.borderbottomwidth = css.borderleftwidth = 2;
	css.bordertopcolor = css.borderrightcolor = css.borderbottomcolor = css.borderleftcolor = 0xffffff;	
	css.backgroundcolor = 0xf8f8f9;
	css.paddingtop = css.paddingbottom = css.paddingleft = css.paddingright = css.margintop = css.marginbottom = 2;
};

DENG.CXForms_TRIGGER.prototype.create = function()
{
	super.create();
	
	this.bound = false;
	this.control = this.mc;
	this.control.onRelease = function () {this.classRef.activate();};
	if (this.label) {
		this.label_txt = this.label.getTextField().tfRef;
		this.label_txt.selectable = false;
	}
};

DENG.CXForms_TRIGGER.prototype.createControl = function ()
{
	// default styles
	this.setDefaultControlStyles(this);
};

DENG.CXForms_TRIGGER.prototype.size = function()
{
	super.size();
};
DENG.CXForms_TRIGGER.prototype.createBinding = function() {
	return true;
};

//DENG.CXForms_TRIGGER.prototype.createControl = null;

// dispatch click event to all listeners for this trigger
DENG.CXForms_TRIGGER.prototype.activate = function(e)
{
	var event = this.xmlDomRef.createXFormsEvent(Event.CLICK);
	this.dispatchEvent(event);
};
