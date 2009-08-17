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
//   class DENG.CSMIL_REGION
// ===========================================================================================


DENG.CSMIL_REGION = function () {
	super();
}

DENG.CSMIL_REGION.extend(DENG.CWnd);

DENG.CSMIL_REGION.prototype.initialize = function(node, parent) {
	super.initialize(node, parent);
	var layout = this.xmlDomRef.smilLayout;
	var attr_names = ["top", "left", "width", "height"];
	var attrs = this.node.attributes;
	var id = this.id = attrs.id;
	var region = layout[id] = {};
	for (var i = 0; i < attr_names.length; i++) {
		var name = attr_names[i];
		region[name] = attrs[name];
	}
	//getURL("javascript:alert('region defined: " +id +" -> " +this.xmlDomRef.smilLayout[id] +"')");
}

