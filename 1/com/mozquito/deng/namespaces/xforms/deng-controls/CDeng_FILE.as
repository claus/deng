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
//   class DENG.CDeng_FILE
// ===========================================================================================

DENG.CDeng_FILE = function()
{
	super();
}

DENG.CDeng_FILE.extend(DENG.CXForms_INPUT);

DENG.CDeng_FILE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	this.controller = this;
	do {
		this.controller = this.controller.parentNode;
	}
	while (this.controller.node.nsNodeName != "include" && this.controller);
	this.controller.filecontrol = this;
};
DENG.CDeng_FILE.prototype.create = function()
{
	super.create();
};
DENG.CDeng_FILE.prototype.size = function()
{
	super.size();
};
DENG.CDeng_FILE.prototype.createBinding = function () {
	return true;
};
DENG.CDeng_FILE.prototype.onChanged = function () 
{
	this.filename = this.control.text;
};
DENG.CDeng_FILE.prototype.load = function () {
	this.file = new XML();
	this.file.controller = this;
	this.file.onData = function (text) {
		this.controller.onLoad(text);
	};
	this.file.load(this.filename);
};
DENG.CDeng_FILE.prototype.onLoad = function (text) {
	this.controller.control.text = text;
};
