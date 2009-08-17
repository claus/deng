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
//   class DENG.CSVG_RECT
// ===========================================================================================

DENG.CSVG_RECT = function()
{
	super();
	
	this.cssPropAttr = {
		x: true,
		y: true,
		rx: true,
		ry: true,
		width: true,
		height: true,
		transform: true
	};
}

DENG.CSVG_RECT.prototype = new DENG.CSVGWnd();

DENG.CSVG_RECT.prototype.create = function()
{
	// create mc
	this.mc = this.mcContent = this.parentNode.mcContent.createEmptyMovieClipExt();
	this.mc.classRef = this.mcContent.classRef = this; // callback to this object
	
	super.create();
}


DENG.CSVG_RECT.prototype.paint = function()
{
	var x = this.resolveCssProperty("x");
	var y = this.resolveCssProperty("y");
	var w = this.resolveCssProperty("width");
	var h = this.resolveCssProperty("height");
	
	// az:: those properties are undefined for regular rectangles
	// they define arcWidth and arcHeight for rounded rectangles
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
	
	// paint rect
	// az:: here we use ZoodeGeometries2D package (drawing API abstraction)
	if (rx == undefined && ry == undefined)
	{
		// regular rectangle
		var svg_rect = new Rectangle2D(this.mcContent);
		svg_rect.setRect(x, y, w, h);
		if(_sc != "none") {
			svg_rect.setStroke(_sw, _sc, _so);
		} else {
			svg_rect.setStroke(0, 0, 0); // no stroke
		}
		if(_fc != "none") {
			svg_rect.setFillColor(_fc, _fo);
		} 
		svg_rect.draw();
	}
	else
	{
		// rounded rectangle
		// as ASV, we assign the same value if one of the rx/ry attributes are omitted
		rx = (rx == undefined) ? ry : rx;
		ry = (ry == undefined) ? rx : ry;
		var svg_roundrect = new RoundRectangle2D(this.mcContent);
		svg_roundrect.setRoundRect(x, y, w, h, rx, ry);
		if(_sc != "none") {
			svg_roundrect.setStroke(_sw, _sc, _so);
		} else {
			svg_roundrect.setStroke(0, 0, 0); // no stroke
		}
		if(_fc != "none") {
			svg_roundrect.setFillColor(_fc, _fo);
		} 
		svg_roundrect.draw();
	}
	
	super.paint();
}



