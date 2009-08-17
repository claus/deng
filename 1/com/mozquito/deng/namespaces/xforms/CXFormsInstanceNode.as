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
//   class XMLNode extensions
// ===========================================================================================

// Instance Node Methods
// extensions to XMLNode prototype

// unfortunately these must be added to every XMLNode in every XML object


// addListenerUI method
// registers to this instance node any reference passed as argument
XMLNode.prototype.addListenerUI = function(l){
	if (null == l) return;
	if (this.UIs == undefined) this.UIs = [];
	// add the reference to the UI listeners table
	this.UIs.push(l);
	return l;
}; // addListenerUI method end

// updateControls method
// update all registered listeners with this instance node's current value
XMLNode.prototype.updateControls = function(l) {
	var i, c = XPathUtils.cloneArray(this.UIs);
	this.UIs = [l];
	while (c.length) {
		i = c.shift();
		if (i!=l) {
			i.updateBinding();
			i.updateControl();
		}
	}
};
