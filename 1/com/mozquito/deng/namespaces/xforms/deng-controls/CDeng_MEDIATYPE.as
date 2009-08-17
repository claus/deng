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
//   class DENG.CDeng_MEDIATYPE
// ===========================================================================================

DENG.CDeng_MEDIATYPE = function()
{
	super();
}

DENG.CDeng_MEDIATYPE.extend(DENG.CXForms_INPUT);

DENG.CDeng_MEDIATYPE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// TODO: error checking
	this.submission = this.node.attributes.submission;
	var initialValue = this.xmlDomRef.getSubmission(this.submission).mediatype;
	this.binding = {instanceValue:((initialValue.length)?initialValue:"")};
};
DENG.CDeng_MEDIATYPE.prototype.create = function()
{
	super.create();
};
DENG.CDeng_MEDIATYPE.prototype.size = function()
{
	super.size();
};
DENG.CDeng_MEDIATYPE.prototype.createBinding = function () {
	return true;
};
DENG.CDeng_MEDIATYPE.prototype.onChanged = function () 
{
	this.xmlDomRef.getSubmission(this.submission).mediatype = this.control.text;
};
