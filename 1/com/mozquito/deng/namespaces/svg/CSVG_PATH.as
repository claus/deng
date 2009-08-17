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
//   class DENG.CSVG_PATH
// ===========================================================================================

// includes String methods for parsing path data 
// (ported from Helen Triolo's codebase)

#include "com/mozquito/deng/protos/protoString.as"

DENG.CSVG_PATH = function()
{
	super();
	
	this.cssPropAttr = {
		transform: true
	};
}

// it inherits from CSVGWnd class 
DENG.CSVG_PATH.prototype = new DENG.CSVGWnd();
DENG.CSVG_PATH.prototype.$pathPainted = false;
DENG.CSVG_PATH.prototype.$gp = null;


DENG.CSVG_PATH.prototype.create = function()
{
	// create mc
	this.mc = this.mcContent = this.parentNode.mcContent.createEmptyMovieClipExt();
	this.mc.classRef = this.mcContent.classRef = this; // callback to this object
	
	super.create();
}


DENG.CSVG_PATH.prototype.position = null;


DENG.CSVG_PATH.prototype.paint = function()
{
	// register this wrapper object in paths queue
	// for asynchronous painting
	this.rootNode.$paths.push(this);
	
	super.paint();
}


DENG.CSVG_PATH.prototype.drawPath = function()
{
	// parsePathCoords method is defined in com/mozquito/deng/protos/protoString.as
	var cmds = this.node.attributes.d.parsePathCoords();
	
	// get styles
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
	
	// paint path
	// uses ZoodeGeometries2D package (drawing API abstraction)
	
	var gp = this.$gp = new GeneralPath(this.mcContent);
	if(_sc != "none") {
		gp.setStroke(_sw, _sc, _so);
	} else {
		gp.setStroke(0, 0, 0); // none
	}
	if(_fc != "none") {
		gp.setFillColor(_fc, _fo);
	}
	
	// uses Helen Triolo's path data parsing/rendering routine
	// drawing methods are replaced by methods defined in Geometries2D package
	// TODO :: A/a (ARC) commands needs to be implemented
	
	var i = 0;
	var firstP, lastP, lastC, cmd;
	var pts = [];
	
	do
	{
		cmd = cmds[i++];
		switch(cmd)
		{
			case "M" :
				firstP = {x:Number(cmds[i]), y:Number(cmds[i+1])};
				lastP = firstP;
				gp.move(firstP.x, firstP.y);
				i += 2;
				// subsequent pairs are treated as implicit lineto commands
				if (i < cmds.length && !isNaN(Number(cmds[i]))) {  
					do {
						lastP = {x:Number(cmds[i]), y:Number(cmds[i+1])};
						gp.addLine(lastP.x, lastP.y);
						i += 2;
					} while (i < cmds.length && !isNaN(Number(cmds[i])));
				}
				break;
			
			case "m" :
				// If a relative moveto (m) appears as the first element of the path, 
				// then it is treated as a pair of absolute coordinates. 
				if (i <= 1) { // first element of the path ?
				firstP = {x:Number(cmds[i]), y:Number(cmds[i+1])};
				lastP = firstP;
				} else {
				firstP = {x:lastP.x+Number(cmds[i]), y:lastP.y+Number(cmds[i+1])};
				lastP = firstP;	
				}
				gp.move(firstP.x, firstP.y);
				i += 2;
				// subsequent pairs are treated as implicit lineto commands
				if (i < cmds.length && !isNaN(Number(cmds[i]))) {  
					do {
						lastP = {x:Number(cmds[i]), y:Number(cmds[i+1])};
						gp.addLine(lastP.x, lastP.y);
						i += 2;
					} while (i < cmds.length && !isNaN(Number(cmds[i])));
				}
				break;
				
			case "l" :
				do {
					lastP = {x:lastP.x+Number(cmds[i]), y:lastP.y+Number(cmds[i+1])};
					gp.addLine(lastP.x, lastP.y);
					i += 2;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "L" :
				do {
					lastP = {x:Number(cmds[i]), y:Number(cmds[i+1])};
					gp.addLine(lastP.x, lastP.y);
					i += 2;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
			
			
			case "h" :
				do {
					lastP = {x:lastP.x+Number(cmds[i]), y:lastP.y};
					gp.addLine(lastP.x, lastP.y);
					i += 1;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "H" :
				do {
					lastP = {x:Number(cmds[i]), y:lastP.y};
					gp.addLine(lastP.x, lastP.y);
					i += 1;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "v" :
				do {
					lastP = {x:lastP.x, y:lastP.y+Number(cmds[i])};
					gp.addLine(lastP.x, lastP.y);
					i += 1;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "V" :
				do {
					lastP = {x:lastP.x, y:Number(cmds[i])};
					gp.addLine(lastP.x, lastP.y);
					i += 1;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
			
			// quadratic and cubic BEZIER CURVES
			
			case "q" :
				do {
					lastC = {x:lastP.x+Number(cmds[i]), y:lastP.y+Number(cmds[i+1])};
					lastP = {x:lastP.x+Number(cmds[i+2]), y:lastP.y+Number(cmds[i+3])};
					gp.addQuad(lastC.x, lastC.y, lastP.x, lastP.y);
					i += 4;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "Q" :
				do {
					lastC = {x:Number(cmds[i]), y:Number(cmds[i+1])};
					lastP = {x:Number(cmds[i+2]), y:Number(cmds[i+3])};
					gp.addQuad(lastC.x, lastC.y, lastP.x, lastP.y);
					i += 4;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
			
			case "t" :
				do {
					gp.addQuad(lastP.x + (lastP.x - lastC.x), lastP.y + (lastP.y - lastC.y), lastP.x+Number(cmds[i]), lastP.y+Number(cmds[i+1]));
					lastC = {x:lastP.x+(lastP.x - lastC.x), y:lastP.y+(lastP.y - lastC.y)};
					lastP = {x:lastP.x+Number(cmds[i]), y:lastP.y+Number(cmds[i+1])};	
					i += 2;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "T" :
				do {
					gp.addQuad(lastP.x + (lastP.x - lastC.x), lastP.y + (lastP.y - lastC.y), Number(cmds[i]), Number(cmds[i+1]));
					lastC = {x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)};
					lastP = {x:Number(cmds[i]), y:Number(cmds[i+1])};	
					i += 2;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
			
			case "c" :
				do {
					gp.addCubic(lastP.x+Number(cmds[i]), lastP.y+Number(cmds[i+1]), lastP.x+Number(cmds[i+2]), lastP.y+Number(cmds[i+3]), lastP.x+Number(cmds[i+4]), lastP.y+Number(cmds[i+5]));
					lastC = {x:lastP.x+Number(cmds[i+2]), y:lastP.y+Number(cmds[i+3])};
					lastP = {x:lastP.x+Number(cmds[i+4]), y:lastP.y+Number(cmds[i+5])};							
					i += 6;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "C" :
				do {
					gp.addCubic(Number(cmds[i]), Number(cmds[i+1]), Number(cmds[i+2]), Number(cmds[i+3]), Number(cmds[i+4]), Number(cmds[i+5]));
					lastC = {x:Number(cmds[i+2]), y:Number(cmds[i+3])};
					lastP = {x:Number(cmds[i+4]), y:Number(cmds[i+5])};					
					i += 6;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
	
			case "s" :
				do {
					gp.addCubic(lastP.x + (lastP.x - lastC.x), lastP.y + (lastP.y - lastC.y), lastP.x+Number(cmds[i]), lastP.y+Number(cmds[i+1]), lastP.x+Number(cmds[i+2]), lastP.y+Number(cmds[i+3]));
					lastC = {x:lastP.x+Number(cmds[i]), y:lastP.y+Number(cmds[i+1])};
					lastP = {x:lastP.x+Number(cmds[i+2]), y:lastP.y+Number(cmds[i+3])};	
					i += 4;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
				
			case "S" :
				do {
					gp.addCubic(lastP.x + (lastP.x - lastC.x), lastP.y + (lastP.y - lastC.y), Number(cmds[i]), Number(cmds[i+1]), Number(cmds[i+2]), Number(cmds[i+3]));
					lastC = {x:Number(cmds[i]), y:Number(cmds[i+1])};
					lastP = {x:Number(cmds[i+2]), y:Number(cmds[i+3])};	
					i += 4;
				} while (i < cmds.length && !isNaN(Number(cmds[i])));
				break;
	
			// close path
	
			case "z" :
			case "Z" :
				if (firstP.x != lastP.x || firstP.y != lastP.y) {
					gp.closePath();
				}
				// do not augment the counter when closing path
				break;		
				
		} // end switch

	}
	while(i < cmds.length);
	
	// draw the defined path;
	gp.draw();
}


