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
//   class DENG.CXHTML_IMG
// ===========================================================================================

DENG.CXHTML_IMG = function()
{
	super();
	this.cssPropAttr = {
		width: true,
		height: true
	};
}

DENG.CXHTML_IMG.prototype = new DENG.CWnd();


DENG.CXHTML_IMG.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// initialize default styles
	this.css.dom.propertyTableAttr.display = "block";
}


DENG.CXHTML_IMG.prototype.create = function()
{
	super.create();

	this.mcContent.onLoad = function(success) {
		//trace("###onLoad " + success);
	}
	
	this.mcImgContainer = this.mcContent.createEmptyMovieClipExt();
	
	var _src = this.node.attributes.src;
	if(_src != undefined && _src.length > 0) {
		var _u = new DENG.CUri(_src, this.xmlDomRef.getBaseUrl());
		this.xmlDomRef.queue.addObject(10000, this.mcImgContainer, _u.getAbsolute());
	}
}

DENG.CWnd.prototype.privateOnRelease = function()
{
	if(typeof this.clickHandlerID != "undefined" && this.mc.hitTest(_level0._xmouse, _level0._ymouse, true)) {
		this.onClickHandler(this.clickHandlerID);
	}
}


