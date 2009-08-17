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
//   class DENG.CMMCAWnd
// ===========================================================================================

DENG.CMMCAWnd = function() { super(); }

DENG.CMMCAWnd.prototype = new DENG.CWnd();

DENG.CMMCAWnd.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// 
	var _classAttr = this.node.attributes.class.toLowerCase();
	if(_classAttr != undefined && _classAttr != "") {
		if(_classAttr.indexOf("titlestyle") >= 0) {
			// class="titleStyle"
			var _pta = this.css.dom.propertyTableAttr;
			_pta.fontsize = [{type:14, value:9}]; // 9pt
			_pta.fontweight = "bold";
			_pta.bordertopwidth = 2;
			_pta.borderrightwidth = 2;
			_pta.borderbottomwidth = 2;
			_pta.borderleftwidth = 2;
			_pta.bordertopstyle = "outset";
			_pta.borderrightstyle = "outset";
			_pta.borderbottomstyle = "outset";
			_pta.borderleftstyle = "outset";
			_pta.bordertopcolor = 0xffffff;
			_pta.borderrightcolor = 0xffffff;
			_pta.borderbottomcolor = 0xffffff;
			_pta.borderleftcolor = 0xffffff;
			_pta.backgroundcolor = 0xdddddd;
			_pta.marginbottom = [{type:20, value:1}]; // 1em
		}
		if(_classAttr.indexOf("codestyle") >= 0) {
			// class="titleStyle"
			var _pta = this.css.dom.propertyTableAttr;
			_pta.fontfamily = [{type:200, value:"Courier New"},{type:200, value:"Courier"},{type:200, value:"monospace"}];
			_pta.whitespace = "pre";
			_pta.color = "green";
		}
		if(_classAttr.indexOf("subtitle") >= 0) {
			// class="titleStyle"
			var _pta = this.css.dom.propertyTableAttr;
			_pta.fontweight = "bold";
			_pta.textdecoration = "underline";
		}
	}
}

