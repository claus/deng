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
//   class DENG.CXForms_LOAD
// ===========================================================================================

DENG.CXForms_LOAD = function()
{
	super();
}

DENG.CXForms_LOAD.extend(DENG.CXFormsWnd);

DENG.CXForms_LOAD.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	this.controller = this;
	do {
		this.controller = this.controller.parentNode;
	}
	while (this.controller.filecontrol == undefined && this.controller);
	this.controller = this.controller.filecontrol;
};

DENG.CXForms_LOAD.prototype.activate = function (e) {
	// TODO: see comment in CXFormsControlWnd, this must be fixed!!
	//this.xmlDomRef.infoMsg("attempting to load file: " +this.controller.filename);
	this.controller.load();
};
