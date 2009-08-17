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
//   class DENG.CSMIL_MediaObjectWnd
// ===========================================================================================

//DENG.CSMIL_MediaObjectWnd = DENG.CXHTML_IMG;

DENG.CSMIL_MediaObjectWnd = function () {
	super();
}

DENG.CSMIL_MediaObjectWnd.extend(DENG.CWnd);

DENG.CSMIL_MediaObjectWnd.prototype.initialize = function (node, parent) {
	super.initialize(node, parent);
	// initialize default styles
	this.css.dom.propertyTableAttr.display = "block";

	this.region = this.xmlDomRef.smilLayout[this.node.attributes.region];
}

DENG.CSMIL_MediaObjectWnd.prototype.create = function () {
	super.create();
}

DENG.CSMIL_MediaObjectWnd.prototype.size = function () {
	super.size();
}

DENG.CSMIL_MediaObjectWnd.prototype.position = function () {
	this.mc._x += parseInt(this.region.left);
	this.mc._y += parseInt(this.region.top);
	return 0;
}



