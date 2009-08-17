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
//   class DENG.CSVG_SVG
// ===========================================================================================

DENG.CSVG_SVG = function()
{
	super();
	
	this.cssPropAttr = {
		x: true,
		y: true,
		width: true,
		height: true,
		viewBox: true,
		preserveAspectRatio: true
	};
}

DENG.CSVG_SVG.prototype = new DENG.CSVGWnd();

DENG.CSVG_SVG.prototype.create = function()
{
	if(this.parentNode.$noRendering) {
		this.$noRendering = true;
		this.size = null;
		this.position = null;
		this.paint = null;
		return;
	}

	this.relPositioning = true;
	this.isBlockElement = true;
	
	// get object/mc of element's containing block 
	var cbr = this.getContainingBlock();
	this.cbt = cbr[0];
	this.cbObj = cbr[1];
	this.cbMC = cbr[2];
	
	// create mc
	this.mc = this.cbMC.createEmptyMovieClipExt();
	this.mc.classRef = this; // callback to this object
	this.mcContent = this.mc.createEmptyMovieClipExt("_CONTENT_");
	this.mcContent.classRef = this; // callback to this object
	this.mcMask = this.mc.createEmptyMovieClipExt("_MASK_");
	this.mcContent.setMask(this.mcMask);
	
	// all paths are registered in the $paths array
	// objects referenced are CSVG_PATH wrapper objects
	// used for asynchronous painting
	this.$paths = [];

	super.create();
}


DENG.CSVG_SVG.prototype.size = function()
{
	switch(this.cbt) {
		case 0:
			// anchestor's content edge
			this.cbX = this.cbObj.calcContentX;
			this.cbY = this.cbObj.calcContentY;
			this.cbWidth = this.cbObj.calcContentWidth;
			break;
		case 1:
			// initial containing block
			var cb = this.getInitialContainingBlock();
			this.cbX = cb.x;
			this.cbY = cb.y;
			this.cbWidth = cb.width;
			this.cbHeight = cb.height;
			break;
		case 2:
			// viewport
			var cb = this.getInitialContainingBlock();
			this.cbX = cb.x;
			this.cbY = cb.y;
			this.cbWidth = cb.width;
			this.cbHeight = cb.height;
			break;
		case 3:
			// anchestor's padding edge
			this.cbX = this.cbObj.calcPaddingX;
			this.cbY = this.cbObj.calcPaddingY;
			this.cbWidth = this.cbObj.calcContentWidth;
			break;
	}

	// get width/height
	var _w = this.resolveCssPropertyPercentage("width", this.cbWidth);
	var _h = this.resolveCssPropertyPercentage("height", this.cbHeight);
	this.calcContentX = 0;
	this.calcContentY = 0;
	this.calcContentWidth = (_w != "auto") ? _w : this.cbWidth;
	this.calcContentHeight = (_h != "auto") ? _h : this.cbHeight;

	// position main mc
	var x = 0, y = 0;
	if(this.parentNode) {
		x = this.cbObj.calcContentX;
		y = this.cbObj.calcContentY + this.cbObj.flowOffset;
	}
	this.mc._x = x;
	this.mc._y = y;

	// apply viewbox property
	var _viewBox = this.resolveCssProperty("viewBox");
	if(_viewBox != undefined && _viewBox.length == 4) {
		var _xs = this.calcContentWidth / _viewBox[2].value;
		var _ys = this.calcContentHeight / _viewBox[3].value;
		this.mcContent._x = -_viewBox[0].value * _xs;
		this.mcContent._y = -_viewBox[1].value * _ys;
		this.mcContent._xscale = _xs * 100;
		this.mcContent._yscale = _ys * 100;
	}
	
	super.size();
}


DENG.CSVG_SVG.prototype.position = function()
{
	return this.calcContentHeight;
}


DENG.CSVG_SVG.prototype.paint = function()
{
	var w = this.calcContentWidth;
	var h = this.calcContentHeight;

	// paint mask
	with(this.mcMask) {
		clear();
		lineStyle();
		beginFill(0xff0000, 100);
		moveTo(0, 0);
		lineTo(w, 0);
		lineTo(w, h);
		lineTo(0, h);
		endFill();
	}

	if(!this.$pathsPainted) {
		this.$pathsPainted = true;
		super.paint();
		if(this.$paths.length) {
			this.mcContent.onEnterFrame = function() {
				this.classRef.onEnterFrameDrawPath();
			}
		}
	}
}


DENG.CSVG_SVG.prototype.onEnterFrameDrawPath = function()
{
	if(this.$_currentPathDrawing == undefined || this.$currentPathDrawing == 0) {
		this.$_currentPathDrawing = 0;
	}
	var _t = getTimer();
	while(getTimer() - _t < 150) {
		this.$paths[this.$_currentPathDrawing++].drawPath();
		if(this.$_currentPathDrawing == this.$paths.length) {
			delete this.$_currentPathDrawing;
			this.onPathsPainted();
			break;
		}
	}
}


DENG.CSVG_SVG.prototype.onPathsPainted = function()
{
	delete this.mcContent.onEnterFrame;
}
