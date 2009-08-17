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

// extensions to XMLNode prototype

// this does NOT work like the DOM method:
// namespaceURI must be specified
// returns null or a string
XMLNode.prototype.getAttributeNS = function(namespaceURI, localName){
	var prefix, ns = this.$xmlns;
	var attrs = this.attributes;
	for (prefix in ns) {
		if (namespaceURI == ns[prefix]) {
			var a = attrs[prefix +":" +localName];
			if (a != undefined) return a;
			// there may be more than one prefix bound to the same uri: go on looping
		}
	}
	return null;
};
