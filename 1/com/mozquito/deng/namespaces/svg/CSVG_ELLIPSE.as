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
//   class DENG.CSVG_ELLIPSE
// ===========================================================================================

DENG.CSVG_ELLIPSE = function()
{
	super();
	
	this.cssPropAttr = {
		cx: true,
		cy: true,
		rx: true,
		ry: true,
		transform: true
	};
}

DENG.CSVG_ELLIPSE.prototype = new DENG.CSVGWnd();

DENG.CSVG_ELLIPSE.prototype.create = function()
{
	// create mc
	this.mc = this.mcContent = this.parentNode.mcContent.createEmptyMovieClipExt();
	this.mc.classRef = this.mcContent.classRef = this; // callback to this object
	
	super.create();
}


DENG.CSVG_ELLIPSE.prototype.position = null;
DENG.CSVG_ELLIPSE.prototype.size = null;


DENG.CSVG_ELLIPSE.prototype.paint = function()
{
	var cx = this.resolveCssProperty("cx");
	var cy = this.resolveCssProperty("cy");
	var rx = this.resolveCssProperty("rx");
	var ry = this.resolveCssProperty("ry");

	this.mcContent._alpha = this.resolveCssProperty("opacity") * 100;
	var _fo = this.resolveCssProperty("fillopacity") * 100;
	var _fc = this.resolveCssPropertyColor("fill");
	if(_fc == "currentColor") {
		_fc = this.resolveCssPropertyColor("color");
	}
	var _sw = this.resolveCssProperty("strokewidth");
	var _so = this.resolveCssProperty("strokeopacity") * 100;
	var _sc = this.resolveCssPropertyColor("stroke");
	if(_sc == "currentColor") {
		_sc = this.resolveCssPropertyColor("color");
	}

	this.mcContent.clear();

	// paint ellipse
	// uses ZoodeGeometries2D package (drawing API abstraction)
	var svg_ellipse = new Ellipse2D(this.mcContent);
	svg_ellipse.setEllipse(cx, cy, rx, ry);
	if(_sc != "none") {
		svg_ellipse.setStroke(_sw, _sc, _so);
	} else {
		svg_ellipse.setStroke(0, 0, 0); // no stroke
	}
	if(_fc != "none") {
		svg_ellipse.setFillColor(_fc, _fo);
	} 
	svg_ellipse.draw();

	super.paint();
}

