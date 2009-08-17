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
//   class DENG.CXHTML_P
// ===========================================================================================

DENG.CXHTML_P = function() { super(); }

DENG.CXHTML_P.prototype = new DENG.CWnd();

DENG.CXHTML_P.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// initialize default styles
	var _pta = this.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.margintop = [{type:20, value:0.25}]; // 0.25em
	_pta.marginbottom = [{type:20, value:0.5}]; // 0.5em
	_pta.marginleft = 0;
	_pta.marginright = 0;
}
