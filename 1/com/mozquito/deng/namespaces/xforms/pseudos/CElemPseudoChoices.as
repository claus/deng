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
//   class DENG.CElemPseudoChoices
// ===========================================================================================

DENG.CElemPseudoChoices = function() { super(); }

DENG.CElemPseudoChoices.extend(DENG.CWnd);

DENG.CElemPseudoChoices.prototype.cssPseudoClass = "choices";

DENG.CElemPseudoChoices.prototype.create = function()
{
	var _pta = this.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.paddingtop = 3; 
	_pta.paddingright = 0;
	_pta.paddingbottom = 3;
	_pta.paddingleft = 2;
	super.create();
}

DENG.CElemPseudoChoices.prototype.checkPseudos_choices = function () {return true;}

DENG.CElemPseudoChoices.prototype.toString = function()
{
	return "<" + this.node.nodeName + "::choices>";
}
