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
//   class DENG.CXForms_SUBMIT
// ===========================================================================================

DENG.CXForms_SUBMIT = function()
{
	super();
}

DENG.CXForms_SUBMIT.extend(DENG.CXForms_TRIGGER);

DENG.CXForms_SUBMIT.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_SUBMIT.prototype.create = function()
{
	super.create();
};

DENG.CXForms_SUBMIT.prototype.size = function()
{
	super.size();
};

DENG.CXForms_SUBMIT.prototype.activate = function()
{
	var submission = this.node.attributes.submission;
	this.submission = this.xmlDomRef.getSubmission(submission);
	if (this.submission) {
		var submitevent = this.xmlDomRef.createXFormsEvent(Event.XFORMS_SUBMIT);
		this.submission.dispatchEvent(submitEvent);
	} else {
		this.xmlDomRef.errorMsg("could not find a submission with id: " +submission);
	}
};
