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
//   class DENG.CSVG_LINE
// ===========================================================================================

DENG.CSVG_LINE = function()
{
	super();
	
	this.cssPropAttr = {
		x1: true,
		y1: true,
		x2: true,
		y2: true,
		transform: true
	};
}

// it inherits from CSVGWnd class 
DENG.CSVG_LINE.prototype = new DENG.CSVGWnd();

DENG.CSVG_LINE.prototype.create = function()
{
	// create mc
	this.mc = this.mcContent = this.parentNode.mcContent.createEmptyMovieClipExt();
	this.mc.classRef = this.mcContent.classRef = this; // callback to this object

	super.create();
}


DENG.CSVG_LINE.prototype.position = null;
DENG.CSVG_LINE.prototype.size = null;


DENG.CSVG_LINE.prototype.paint = function(){
	
	var x1 = this.resolveCssProperty("x1");
	var y1 = this.resolveCssProperty("y1");
	var x2 = this.resolveCssProperty("x2");
	var y2 = this.resolveCssProperty("y2");
	
	this.mcContent._alpha = this.resolveCssProperty("opacity") * 100;
	var _sw = this.resolveCssProperty("strokewidth");
	var _so = this.resolveCssProperty("strokeopacity") * 100;
	var _sc = this.resolveCssPropertyColor("stroke");
	if(_sc == "currentColor") {
		_sc = this.resolveCssPropertyColor("color");
	}

	this.mcContent.clear();

	// paint line
	// uses ZoodeGeometries2D package (drawing API abstraction)
	var svg_line = new Line2D(this.mcContent);
	svg_line.setLine(x1, y1, x2, y2);
	svg_line.setStroke(_sw, _sc, _so);
	svg_line.draw();
	
	super.paint();

}


