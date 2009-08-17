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
//   class DENG.CXFrames_FRAMES
// ===========================================================================================

DENG.CXFrames_FRAMES = function()
{
	super();

	this.cssPropAttr = {
		compose: true
	};
}

DENG.CXFrames_FRAMES.extend(DENG.CXFramesWnd);
DENG.CXFrames_FRAMES.prototype.initialize = function(n, p) { super.initialize(n, p); };
DENG.CXFrames_FRAMES.prototype.position = null;


DENG.CXFrames_FRAMES.prototype.create = function()
{
	if(this.parentNode) {
		// <frames> must be root element
		this.size = null;
		this.paint = null;
		return;
	}

	// create mcs
	this.mc = this.xmlDomRef.mc.createEmptyMovieClipExt();
	this.mcMask = this.mc.createEmptyMovieClipExt("_MASK_");
	this.mcContent = this.mc.createEmptyMovieClipExt("_CONTENT_");
	this.mcContent.setMask(this.mcMask);
	this.mc.classRef = this.mcContent.classRef = this;

	// all frames are registered in the $frames object 
	// the index of this associative array is the frame's id,
	// objects referenced are anonymous "frame info" objects,
	// containing the following properties:
	// - obj (refers to the frame wrapper object that belongs to this frame)
	// - width (the raw css value for the width property)
	// - height (the raw css value for the height property)
	// - calcX, calcY, calcWidth, calcHeight (the calculated dimensions of the frame)
	// - rendered (true if the frame has finished rendering)
	// - valid (false if there was a problem resolving css values, currently not in use)
	this.$frames = {};

	// the $childFrames array contains the ids of 
	// this element's child frames
	this.$childFrames = [];

	// see also:
	// - CXFramesWnd.registerFrame
	// - CXFramesWnd.calcChildFrames
	// (both used in the create/size methods in CXFrames_GROUP and CXFrames_FRAME)
	// - this.renderFrames

	// continue with create
	super.create();
}


DENG.CXFrames_FRAMES.prototype.size = function()
{
	var _p = this.xmlDomRef.pos;
	this.cbX = _p.x; 
	this.cbY = _p.y;
	this.cbWidth = _p.width;
	this.cbHeight = this.$height = _p.height;
	
	var _mt = this.resolveCssProperty("margintop");
	var _mr = this.resolveCssProperty("marginright");
	var _mb = this.resolveCssProperty("marginbottom");
	var _ml = this.resolveCssProperty("marginleft");
	var _pt = this.resolveCssProperty("paddingtop");
	var _pr = this.resolveCssProperty("paddingright");
	var _pb = this.resolveCssProperty("paddingbottom");
	var _pl = this.resolveCssProperty("paddingleft");
	this.calcContentX = _ml + _pl + this.$cssBorder.l.w;
	this.calcContentY = _mt + _pt + this.$cssBorder.t.w;
	this.calcContentWidth = this.cbWidth - this.calcContentX - _mr - _pr - this.$cssBorder.r.w;
	this.calcContentHeight = this.cbHeight - this.calcContentY - _mb - _pb - this.$cssBorder.b.w;
	
	// calculate the bounds of the child frames
	this.calcChildFrames();

	// continue with size
	super.size();
	
	// all sizes set:
	// render the frames
	if(!this.xmlDomRef.$isSized) {
		this.renderFrames(true);
	}
}


DENG.CXFrames_FRAMES.prototype.renderFrames = function(init)
{
	if(init) {
		for(var _i in this.$frames) {
			this.$frames[_i].rendered = false;
		}
	}
	this.$currentFrameID = null;
	for(var _i in this.$frames) {
		if(this.$frames[_i].obj.mcDeng != undefined && !this.$frames[_i].rendered) {
			this.$currentFrameID = _i;
			// search for the last, unrendered frame
			// so no break here.
		}
	}
	if(this.$currentFrameID != null) {
		var _mcdeng = this.$frames[this.$currentFrameID].obj.mcDeng;
		_mcdeng.addListener(this);
		//_mcdeng.forceProxyScript = DENG.$forceProxy;
		//_mcdeng.proxyScript = DENG.$redirectUrl;
		_mcdeng.render();
	}
}

DENG.CXFrames_FRAMES.prototype.onRender = function()
{
	this.$frames[this.$currentFrameID].obj.mcDeng.removeListener(this);
	this.$frames[this.$currentFrameID].rendered = true;
	this.renderFrames();
}


