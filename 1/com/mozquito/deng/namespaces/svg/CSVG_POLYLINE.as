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
//   class DENG.CSVG_POLYLINE
// ===========================================================================================

DENG.CSVG_POLYLINE = function()
{
	super();
	
	this.cssPropAttr = {
		points: true,
		transform: true
	};
}

// it inherits from CSVGWnd class 
DENG.CSVG_POLYLINE.prototype = new DENG.CSVGWnd();

DENG.CSVG_POLYLINE.prototype.create = function()
{
	// create mc
	this.mc = this.mcContent = this.parentNode.mcContent.createEmptyMovieClipExt();
	this.mc.classRef = this.mcContent.classRef = this; // callback to this object
	
	super.create();
}


DENG.CSVG_POLYLINE.prototype.size = null;
DENG.CSVG_POLYLINE.prototype.position = null;


DENG.CSVG_POLYLINE.prototype.paint = function()
{
	// parsePolyCoords method is defined in com/mozquito/deng/protos/protoString.as
	var pts = this.node.attributes.points.parsePolyCoords();
	
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
	
	// paint polyline
	// uses ZoodeGeometries2D package (drawing API abstraction)
	var svg_polyline = new GeneralPath(this.mcContent);
	// az: corrected typo (moveTo -> move)
	svg_polyline.move(pts[0], pts[1]); // first move the pen
	var len = pts.length;
	for(var i = 2; i < len; i+=2) {
		svg_polyline.addLine(pts[i], pts[i+1]);
	}
	if(_sc != "none") {
		svg_polyline.setStroke(_sw, _sc, _so);
	} else {
		svg_polyline.setStroke(0, 0, 0); // no stroke
	}
	if(_fc != "none") {
		svg_polyline.setFillColor(_fc, _fo);
	}
	svg_polyline.draw();
	
	super.paint();
}


