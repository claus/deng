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
//   class DENG.CSVGCssProperties
// ===========================================================================================

DENG.CSVGCssProperties = function(callback)
{
	if(callback) {
		super(callback);
	}
}

DENG.CSVGCssProperties.prototype = new DENG.CCssProperties();


DENG.CSVGCssProperties.prototype.getShorthand = function()
{
	return {
		font: "getShorthandFont",
		marker: "getShorthandMarker"
	};
}


DENG.CSVGCssProperties.prototype.getInherited = function()
{
	return {
		cliprule: true,
		color: true,
		colorinterpolation: true,
		colorinterpolationfilters: true,
		colorprofile: true,
		colorrendering: true,
		cursor: true,
		direction: true,
		fill: true,
		fillopacity: true,
		fillrule: true,
		fontfamily: true,
		fontsize: true,
		fontsizeadjust: true,
		fontstretch: true,
		fontstyle: true,
		fontvariant: true,
		fontweight: true,
		glyphorientationhorizontal: true,
		glyphorientationvertical: true,
		imagerendering: true,
		kerning: true,
		letterspacing: true,
		marker: true,
		markerend: true,
		markermid: true,
		markerstart: true,
		pointerevents: true,
		shaperendering: true,
		stroke: true,
		strokedasharray: true,
		strokedashoffset: true,
		strokelinecap: true,
		strokelinejoin: true,
		strokemiterlimit: true,
		strokeopacity: true,
		strokewidth: true,
		textanchor: true,
		textrendering: true,
		visibility: true,
		wordspacing: true,
		writingmode: true
	};
}


DENG.CSVGCssProperties.prototype.getInitial = function()
{
	return {
		alignmentbaseline: "auto",
		baselineshift: "baseline",
		clip: "auto",
		clippath: "none",
		cliprule: "nonzero",
		color: 0,
		colorinterpolation: "sRGB",
		colorinterpolationfilters: "linearRGB",
		colorprofile: "auto",
		colorrendering: "auto",
		cursor: "auto",
		direction: "ltr",
		display: "inline",
		dominantbaseline: "auto",
		enablebackground: "accumulate",
		fill: 0,
		fillopacity: 1,
		fillrule: "nonzero",
		filter: "none",
		floodcolor: 0,
		floodopacity: 1,
		fontfamily: "_sans",
		fontsize: 10,
		fontsizeadjust: "none",
		fontstretch: "normal",
		fontstyle: "normal",
		fontvariant: "normal",
		fontweight: "normal",
		glyphorientationhorizontal: 0,
		glyphorientationvertical: "auto",
		imagerendering: "auto",
		kerning: "auto",
		letterspacing: "normal",
		lightingcolor: 0xffffff,
		markerend: "none",
		markermid: "none",
		markerstart: "none",
		mask: "none",
		opacity: 1,
		overflow: "visible",
		pointerevents: "visiblePainted",
		shaperendering: "auto",
		stopcolor: 0,
		stopopacity: 1,
		stroke: "none",
		strokedasharray: "none",
		strokedashoffset: 0,
		strokelinecap: "butt",
		strokelinejoin: "miter",
		strokemiterlimit: 4,
		strokeopacity: 1,
		strokewidth: 1,
		textanchor: "start",
		textdecoration: "none",
		textrendering: "auto",
		unicodebidi: "normal",
		visibility: "visible",
		wordspacing: "normal",
		writingmode: "lr-tb"
	};
}

