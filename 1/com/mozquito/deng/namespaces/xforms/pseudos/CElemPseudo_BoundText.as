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
//   class DENG.CElemPseudo_BoundText
// ===========================================================================================

DENG.CElemPseudo_BoundText = function()
{
	super();
};

DENG.CElemPseudo_BoundText.extend(DENG.CElemText);

DENG.CElemPseudo_BoundText.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};

DENG.CElemPseudo_BoundText.prototype.create = function ()
{
	this.controller = this.parentNode.parentNode;
	super.create();
	this.controller.control = this.tf;
};

DENG.CElemPseudo_BoundText.prototype.size = function ()
{
	super.size();
	this.tf.setNewTextFormat(this.tf.getTextFormat());
};

DENG.CElemPseudo_BoundText.prototype.position = function()
{
	var _ch = super.position();
	//mytrace(this.tf.autoSize + " " + _ch + " " + this.parentNode.calcContentHeight, "CXForms", "create");
	if(this.tf.autoSize == "none") {
		if(this.cbObj.calcContentHeight > 0) {
			this.tf._height = this.cbObj.calcContentHeight
		} else {
			this.tf._height = _ch + 4;
		}
	}
	return _ch;
}

DENG.CElemPseudo_BoundText.prototype.getCharacterData = function()
{
	return this.controller.binding.instanceValue;
};

