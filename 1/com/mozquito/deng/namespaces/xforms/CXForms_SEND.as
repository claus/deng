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
//   class DENG.CXForms_SEND
// ===========================================================================================

DENG.CXForms_SEND = function()
{
	super();
}

DENG.CXForms_SEND.extend(DENG.CXFormsWnd);

DENG.CXForms_SEND.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_SEND.prototype.activate = function (e) {
	this.submissionID = this.node.attributes.submission;
	this.submission = this.xmlDomRef.getSubmission(this.submissionID);
	var submitevent = this.xmlDomRef.createXFormsEvent(Event.XFORMS_SUBMIT);
	this.submission.dispatchEvent(submitEvent);
};
