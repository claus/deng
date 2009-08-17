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
//   class DENG.CSMIL_ANIMATE
// ===========================================================================================


DENG.CSMIL_ANIMATE = function () {
	super();
}

DENG.CSMIL_ANIMATE.extend(DENG.CWnd);

DENG.CSMIL_ANIMATE.attributeMap = {
	left: 	"_x",
	top: 		"_y",
	width: 	"_width",
	height: "_height"
};

DENG.CSMIL_ANIMATE.prototype.initialize = function(node, parent) {
	super.initialize(node, parent);
	var attrs = this.node.attributes;
	this.id = attrs.id;
	this.target = this.xmlDomRef.smilLayout[attrs.targetElement];
	this.targetProp = DENG.CSMIL_ANIMATE.attributeMap[attrs.attributeName];
	this.from = parseInt(attrs.from);
	this.to = parseInt(attrs.to);
	this.range = this.to -this.from;
	this.dur = parseInt(attrs.dur.split("s")[0]);
	this.repeatCount = parseFloat(this.parentNode.node.attributes.repeatCount);
	if (isNaN(this.repeatCount)) {
		this.repeatCount = Infinity;
	}

	this.xmlDomRef.registerAnimation(this.id, this);
}

DENG.CSMIL_ANIMATE.prototype.startAnimation = function () {
	this.tween = new DENG.Tween(this.parentNode.mc, this.targetProp, Math.linearTween, this.from, this.to, this.dur, true, this.repeatCount);
	//this.tween.addListener(this);
}

/*DENG.CSMIL_ANIMATE.prototype.onMotionStopped = function () {
	if (--this.repeatCount > 0) {
		this.startAnimation();
	}
}

*/