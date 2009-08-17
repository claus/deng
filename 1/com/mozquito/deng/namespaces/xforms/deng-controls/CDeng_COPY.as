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
//   class DENG.CDeng_COPY
// ===========================================================================================

DENG.CDeng_COPY = function()
{
	super();
}

DENG.CDeng_COPY.extend(DENG.CXForms_SETVALUE);

DENG.CDeng_COPY.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	this.controller = this;
	do {
		this.controller = this.controller.parentNode;
	}
	while (this.controller.filecontrol == undefined && this.controller);
};

DENG.CDeng_COPY.prototype.activate = function (e) {
	if (this.node.attributes.as == 'xml') {
		var frag = new XML(this.controller.control.text);
		//frag.ignoreWhite = true;
		this.binding.boundNode.firstChild.removeNode();
		this.xmlDomRef.infoMsg("copy: " +frag.childNodes);	
		for (var i = 0; i < frag.childNodes.length; i++) {
			var node = frag.childNodes[i];
			this.binding.boundNode.appendChild(node);
			this.xmlDomRef.infoMsg("added: " +node.nodeName);	
			this.xmlDomRef.infoMsg("added: " +node.nodeValue);	
			this.xmlDomRef.infoMsg("added: " +node.nodeType);			
			this.xmlDomRef.infoMsg("next: " +node.nextSibling);	
		} 
	} else {
		this.binding.instanceValue = this.controller.control.text;
		this.updateInstance();
	}
	this.controller.control.text = this.node.attributes.as +" fragment included";
	this.controller.checkSize();
};

