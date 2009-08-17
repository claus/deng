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
//   class DENG.CXForms_MESSAGE
// ===========================================================================================

DENG.CXForms_MESSAGE = function()
{
	super();
}

DENG.CXForms_MESSAGE.extend(DENG.CXFormsWnd);

DENG.CXForms_MESSAGE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CXForms_MESSAGE.prototype.activate = function (e) {
	// determine message text
	if (this.message == undefined) {
		this.message = "";
		var n = this.node.firstChild;
		do {
			this.message += n.nodeValue;
		}
		while (n = n.nextSibling);
	}
	if (this.node.attributes.level == "debug") {
		// debug mode
		if (this.node.attributes.debugmode == "append") {
			// append mode
			_root.out.text += this.message;
		} else {
			// replace mode
			_root.out.text = this.message;
		}
	} else {
		// standard XForms message
		this.xmlDomRef.alert("XForms message", this.message);
	}
};
