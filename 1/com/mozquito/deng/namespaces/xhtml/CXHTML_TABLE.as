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
//   class DENG.CXHTML_TABLE
// ===========================================================================================

DENG.CXHTML_TABLE = function()
{
	super();
	
	this.cssPropAttr = {
		width: true,
		height: true
	};
}

DENG.CXHTML_TABLE.prototype = new DENG.CWnd();


DENG.CXHTML_TABLE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// initialize default styles
	var _pta = this.css.dom.propertyTableAttr;
	_pta.display = "table";
	//_pta.bordertopcolor = _pta.borderrightcolor = _pta.borderbottomcolor = _pta.borderleftcolor = 0x333333;
	//_pta.bordertopstyle = _pta.borderrightstyle = _pta.borderbottomstyle = _pta.borderleftstyle = "solid";
	//_pta.bordertopwidth = _pta.borderrightwidth = _pta.borderbottomwidth = _pta.borderleftwidth = 1;
}
