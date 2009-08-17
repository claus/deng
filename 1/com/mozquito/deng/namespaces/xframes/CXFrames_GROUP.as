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
//   class DENG.CXFrames_GROUP
// ===========================================================================================

DENG.CXFrames_GROUP = function()
{
	super();
	
	this.cssPropAttr = {
		compose: true,
		width: true,
		height: true
	};
}

DENG.CXFrames_GROUP.extend(DENG.CXFramesWnd);
DENG.CXFrames_GROUP.prototype.initialize = function(n, p) { super.initialize(n, p); };
DENG.CXFrames_GROUP.prototype.position = null;


DENG.CXFrames_GROUP.prototype.create = function()
{
	// create mcs
	this.mc = this.xmlDomRef.mc.createEmptyMovieClipExt();
	this.mcMask = this.mc.createEmptyMovieClipExt("_MASK_");
	this.mcContent = this.mc.createEmptyMovieClipExt("_CONTENT_");
	this.mcContent.setMask(this.mcMask);
	this.mc.classRef = this.mcContent.classRef = this;

	// the $childFrames array contains the ids of 
	// this element's child frames
	// (see CXFrames_FRAMES.create)
	this.$childFrames = [];

	// register this group as a frame in $frames and $childFrames
	// (see CXFramesWnd)
	this.registerFrame();

	super.create();
}


DENG.CXFrames_GROUP.prototype.size = function()
{
	var _fi = this.rootNode.$frames[this.$id];
	this.cbX = this.mc._x = _fi.calcX; 
	this.cbY = this.mc._y = _fi.calcY;
	this.cbWidth = _fi.calcWidth;
	this.cbHeight = this.$height = _fi.calcHeight;
	
	var _mt = this.resolveCssProperty("margintop");
	var _mr = this.resolveCssProperty("marginright");
	var _mb = this.resolveCssProperty("marginbottom");
	var _ml = this.resolveCssProperty("marginleft");
	var _pt = this.resolveCssProperty("paddingtop");
	var _pr = this.resolveCssProperty("paddingright");
	var _pb = this.resolveCssProperty("paddingbottom");
	var _pl = this.resolveCssProperty("paddingleft");
	var _cx = _ml + _pl + this.$cssBorder.l.w;
	var _cy = _mt + _pt + this.$cssBorder.t.w;
	this.calcContentX = this.cbX + _cx;
	this.calcContentY = this.cbY + _cy;
	this.calcContentWidth = this.cbWidth - _cx - _mr - _pr - this.$cssBorder.r.w;
	this.calcContentHeight = this.cbHeight - _cy - _mb - _pb - this.$cssBorder.b.w;

	// calculate the bounds of the child frames
	this.calcChildFrames();

	super.size();
}

