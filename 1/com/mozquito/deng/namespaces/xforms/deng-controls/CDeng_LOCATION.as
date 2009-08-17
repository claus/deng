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
//   class DENG.CDeng_LOCATION
// ===========================================================================================

DENG.CDeng_LOCATION = function()
{
	super();
}

DENG.CDeng_LOCATION.extend(DENG.CXForms_INPUT);

DENG.CDeng_LOCATION.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// TODO: error checking
	this.submission = this.node.attributes.submission;
	var initialValue = this.xmlDomRef.getSubmission(this.submission).url;
	this.binding = {instanceValue:((initialValue.length)?initialValue:"")};
};
DENG.CDeng_LOCATION.prototype.create = function()
{
	super.create();
};
DENG.CDeng_LOCATION.prototype.size = function()
{
	super.size();
};
DENG.CDeng_LOCATION.prototype.createBinding = function () {
	return true;
};
DENG.CDeng_LOCATION.prototype.onChanged = function () 
{
	this.xmlDomRef.getSubmission(this.submission).url = this.control.text;
};
