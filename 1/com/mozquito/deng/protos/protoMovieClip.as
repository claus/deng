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
//   MovieClip prototypes
// ===========================================================================================

// -------------------------------------------------------------------------------------------
// MovieClip.createTextFieldExt
// extended createTextField method
// instance name and depth are determined internally
// depth for movieclips are in the range ]10000,..]
// -------------------------------------------------------------------------------------------
// parameters: none
// -------------------------------------------------------------------------------------------
// returns: the created textfield
// -------------------------------------------------------------------------------------------
MovieClip.prototype.$mcCount = 10000;
MovieClip.prototype.createEmptyMovieClipExt = function(instanceName)
{
	var _depth = ++this.$mcCount;
	return this.createEmptyMovieClip((instanceName == undefined) ? "$"+_depth : instanceName, _depth);
}


// -------------------------------------------------------------------------------------------
// MovieClip.createTextFieldExt
// extended createTextField method
// instance name and depth are determined internally
// depth for textfields are in the range ]100,5000[
// -------------------------------------------------------------------------------------------
// parameters: none
// -------------------------------------------------------------------------------------------
// returns: the created textfield
// -------------------------------------------------------------------------------------------
MovieClip.prototype.$tfCount = 100;
MovieClip.prototype.$tfActive = null;
MovieClip.prototype.createTextFieldExt = function()
{
	var _depth = ++this.$tfCount;
	if(_depth < 5000) {
		var _tfName = "$t" + _depth;
		this.createTextField(_tfName, _depth, 0, 0, 4, 4);
		return (this.$tfActive = this[_tfName]);
	} else {
		return null;
	}
}


// -------------------------------------------------------------------------------------------
// MovieClip.paintFrame
// paints a frame with border and background
// -------------------------------------------------------------------------------------------
// parameters:
// b [object] - border properties (see CWnd.getBorderCssProperties)
//   .t [object] - top
//   .r [object] - right
//   .b [object] - bottom
//   .l [object] - left
//      .s [string] - style
//      .w [number] - width
//      .c [number] - color
//   .tr [number/object] - radius top right
//   .br [number/object] - radius bottom right
//   .bl [number/object] - radius bottom left
//   .tl [number/object] - radius top left
// bgc [number] - background-color (null: no/transparent background)
// x,y [number] - top left corner
// w,h [number] - width and height
// -------------------------------------------------------------------------------------------
// returns: nothing
// -------------------------------------------------------------------------------------------
MovieClip.prototype.paintFrame2 = function(b, bgc, bgo, x, y, w, h)
{
	// top edge
	if(b.t.w) {
		var _edge = b.t;
		//this.paintFrameEdge(0, b.t, x, x+b.l.w, x+w-b.r.w, x+w);
		
	}
	//mytrace("border-radius: " + b.tr, "MovieClip", "paintFrame2");
	this.clear();
	this.paintFrame(b.t.s, b.t.w, b.t.c, (bgc == "transparent") ? null : bgc, bgo, x, y, w, h);
}

/*
MovieClip.prototype.paintFrameEdge = function(edge, bprop, p1, p1a, p2a, p2)
{
	switch(edge) {
		case 0:
			
			break;
		case 1:
			break;
		case 2:
			break;
		case 3:
			break;
	}
}
*/

MovieClip.prototype.paintFrame = function(bs, bw, bc, bgc, bgo, x, y, w, h)
{
	if((bs == "none" || bs == "hidden") && bgc != null) {
		// draw frame with no border, but with background
		this.lineStyle();
		this.beginFill(bgc, bgo);
		this.moveTo(x,y+h);
		this.lineTo(x,y);
		this.lineTo(x+w,y);
		this.lineTo(x+w,y+h);
		this.endFill();
		return;
	}

	var bwi, bwo, bwm;
	var isEmbossed = {outset:true, inset:true, ridge:true, groove:true };

	if(isEmbossed[bs])
	{
		// determine border shade colors
		// (we do it the ie 6 way..)
		var _bc = bc;
		var b = (_bc & 0xff) >> 2; // blue
		var g = ((_bc>>=8) & 0xff) >> 2; // green
		var r = ((_bc>>=8) & 0xff) >> 2; // red
		var c25 = (r<<16) | (g<<8) | b; // 25%
		var c50 = (r<<17) | (g<<9) | b+b; // 50%
		var c75 = (r+r+r<<16) | (g+g+g<<8) | b+b+b; // 75%
		var btlo, bbro, btli, bbri;
	
		switch(bs)
		{
			case "outset":
				btlo = c75; bbro = c50; btli = bc; bbri = c25;
				break;
			case "inset":
				btlo = c25; bbro = bc; btli = c50; bbri = c75;
				break;
			case "groove":
				btlo = bbri = c50; bbro = btli = bc;
				break;
			case "ridge":
				btlo = bbri = bc; bbro = btli = c50;
				break;
		}

		bwi = bw >> 1;
		bwo = bw - bwi;
		bwm = 0;
		this.paintEmbossFrame(bwo, btlo, bbro, bgc, bgo, x, y, w, h);
		var bwo2 = bwo + bwo;
		this.paintEmbossFrame(bwi, btli, bbri, bgc, bgo, x+bwo, y+bwo, w-bwo2, h-bwo2);
	}
	else if(bs == "double")
	{
		if(bw == 1) {
			bwo = 1; bwm = bwi = 0;
		} else {
			bwo = bwi = Math.round(bw / 3);
			bwm = bw - bwo - bwi;
		}
		this.paintSolidFrame(bwo, bc, bgc, bgo, x, y, w, h);
		if(bwi) {
			var bwo2 = 2*bwo + 2*bwm;
			this.paintSolidFrame(bwi, bc, null, 100, x+bwo+bwm, y+bwo+bwm, w-bwo2, h-bwo2);
		}
	}
	else
	{
		// solid
		this.paintSolidFrame(bw, bc, bgc, x, y, w, h);
	}
}

MovieClip.prototype.paintSolidFrame = function(bw, bc, bgc, bgo, x, y, w, h)
{
	var xw = x+w;
	var yh = y+h;
	if(bw == 1) {
		this.lineStyle(0, bc, 100);
		if(bgc) { this.beginFill(bgc, bgo); }
		this.moveTo(x,yh);
		this.lineTo(x,y);
		this.lineTo(xw,y);
		this.lineTo(xw,yh);
		this.lineTo(x,yh);
		if(bgc) { this.endFill(); }
	} else {
		if(bgc) {
			this.lineStyle();
			this.beginFill(bgc, bgo);
			this.moveTo(x,yh);
			this.lineTo(x,y);
			this.lineTo(xw,y);
			this.lineTo(xw,yh);
			this.lineTo(x,yh);
			this.endFill();
		}
		this.lineStyle();
		this.beginFill(bc, 100);
		this.moveTo(x,yh);
		this.lineTo(x,y);
		this.lineTo(xw,y);
		this.lineTo(xw,yh);
		this.lineTo(x,yh);
		this.moveTo(x+bw,yh-bw);
		this.lineTo(x+bw,y+bw);
		this.lineTo(xw-bw,y+bw);
		this.lineTo(xw-bw,yh-bw);
		this.lineTo(x+bw,yh-bw);
		this.endFill();
	}
}

MovieClip.prototype.paintEmbossFrame = function(bw, tlc, brc, bgc, bgo, x, y, w, h)
{
	var xw = x+w;
	var yh = y+h;
	if(bw == 1) {
		this.lineStyle(0, tlc, 100);
		if(bgc) { this.beginFill(bgc, bgo); }
		this.moveTo(x,yh);
		this.lineTo(x,y);
		this.lineTo(xw,y);
		this.lineStyle(0, brc, 100);
		this.lineTo(xw,yh);
		this.lineTo(x,yh);
		if(bgc) { this.endFill(); }
	} else {
		if(bgc) {
			this.lineStyle();
			this.beginFill(bgc, bgo);
			this.moveTo(x,yh);
			this.lineTo(x,y);
			this.lineTo(xw,y);
			this.lineTo(xw,yh);
			this.lineTo(x,yh);
			this.endFill();
		}
		this.lineStyle();
		this.beginFill(tlc, 100);
		this.moveTo(x,yh);
		this.lineTo(x,y);
		this.lineTo(xw,y);
		this.lineTo(xw-bw,y+bw);
		this.lineTo(x+bw,y+bw);
		this.lineTo(x+bw,yh-bw);
		this.lineTo(x,yh);
		this.endFill();
		this.lineStyle();
		this.beginFill(brc, 100);
		this.moveTo(x,yh);
		this.lineTo(xw,yh);
		this.lineTo(xw,y);
		this.lineTo(xw-bw,y+bw);
		this.lineTo(xw-bw,yh-bw);
		this.lineTo(x+bw,yh-bw);
		this.lineTo(x,yh);
		this.endFill();
	}
}

// example
//_level0.createEmptyMovieClip("frame", 1);
//_level0.frame.paintFrame("double", 16, 0xff0000, 0xdddddd, 0, 0, 200, 200);
//_level0.frame.paintFrame("groove", 16, 0xff0000, 0xdddddd, 250, 0, 200, 200);
//_level0.frame.paintFrame("solid", 16, 0xff0000, 0xdddddd, 0, 250, 200, 200);
//_level0.frame.paintFrame("inset", 16, 0xff0000, 0xdddddd, 250, 250, 200, 200);

