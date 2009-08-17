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
//   class DENG.CXForms_ITEM
// ===========================================================================================

DENG.CXForms_ITEM = function()
{
	super();
}

DENG.CXForms_ITEM.extend(DENG.CXForms_TRIGGER);

DENG.CXForms_ITEM.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	this.controller = this.parentNode;
};
DENG.CXForms_ITEM.prototype.setDefaultLabelStyles = null;
DENG.CXForms_ITEM.prototype.create = function()
{
	this.controller.items.push(this);
	super.create();
};

DENG.CXForms_ITEM.prototype.setDefaultControlStyles = null;

DENG.CXForms_ITEM.prototype.size = function()
{
	super.size();
	if (this.$initControlDone == undefined) {
		this.initControl();
		this.$initControlDone = true;
	}
};

DENG.CXForms_ITEM.prototype.createControl = null;

DENG.CXForms_ITEM.prototype.initControl = function()
{
	// save original colors
	this.fgColor = this.label_txt.textColor;
	this.bgcolor = this.label_txt.backgroundColor;
	
	// compute and initialize UI state info
	this.states = [{fg: this.fgColor, bg: this.bgColor, bgon: false},{fg: this.bgColor, bg: this.fgColor, bgon: true}];
	this.currentstate = 0;
	this.labelText = this.label_txt.text;
};

DENG.CXForms_ITEM.prototype.updateControl = function () {
	this.labelText = this.label_txt.text;
};

DENG.CXForms_ITEM.prototype.getCurrentState = function () {
	return this.states[this.currentstate % 2];
};

DENG.CXForms_ITEM.prototype.activate = function(e)
{
	//this.xmlDomRef.infoMsg(this.valueText +" " +this.controller);
	this.controller.select(this.valueText, this.labelText);
};
                 
DENG.CXForms_ITEM.prototype.lo = function()
{
	this.currentstate = 0;
	this.updateUI();
};

DENG.CXForms_ITEM.prototype.hi = function()
{
	this.currentstate = 1;
	this.updateUI();
};

DENG.CXForms_ITEM.prototype.updateUI = function(state)
{
	// determine current state
	var state = this.getCurrentState();
	//this.xmlDomRef.infoMsg("current state: " +state);
	// update UI with state info
	//this.xmlDomRef.infoMsg("text color is: " +this.label_txt.textColor +" and becomes: " +state.fg);
	this.label_txt.textColor = state.fg;
	//this.xmlDomRef.infoMsg("background is: " +this.label_txt.background +" and becomes: " +state.bgon);
	this.label_txt.background = state.bgon;
	//this.xmlDomRef.infoMsg("bg color is: " +this.label_txt.backgroundColor +" and becomes: " +state.bg);
	this.label_txt.backgroundColor = state.bg;
};

