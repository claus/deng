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
//   class DENG.CXHTML_PRE
// ===========================================================================================

DENG.CXHTML_PRE = function() { super(); }

DENG.CXHTML_PRE.prototype = new DENG.CWnd();

DENG.CXHTML_PRE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// initialize default styles
	var _pta = this.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.fontfamily = [{type:200, value:"Courier New"},{type:200, value:"Courier"},{type:200, value:"monospace"}];
	_pta.fontsize = 12; // 9pt
	_pta.whitespace = "pre";
	_pta.margintop = [{type:20, value:0.83}]; // 0.83em
	_pta.marginbottom = [{type:20, value:0.83}]; // 0.83em
	_pta.marginleft = 0;
	_pta.marginright = 0;
}
