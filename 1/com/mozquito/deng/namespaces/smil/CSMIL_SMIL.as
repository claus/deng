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
//   class DENG.CSMIL_SMIL
// ===========================================================================================


DENG.CSMIL_SMIL = function () {
	super();
}

DENG.CSMIL_SMIL.extend(DENG.CWnd);

DENG.CSMIL_SMIL.prototype.initialize = function(node, parent) {
	super.initialize(node, parent);

	// fast access to members, interface and document
	var m, i = DENG.ISMIL_HostDoc, d = this.xmlDomRef;
	// copy interface members to CDom document
	for (m in i) d[m] = i[m];
	// initialize CDom to be a SMIL Host Document
	d.initSMILHostDoc();

}

