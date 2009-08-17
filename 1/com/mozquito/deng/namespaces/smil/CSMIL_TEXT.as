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
//   class DENG.CSMIL_TEXT
// ===========================================================================================

DENG.CSMIL_TEXT = function () {
	super();
}

DENG.CSMIL_TEXT.extend(DENG.CSMIL_MediaObjectWnd);

DENG.CSMIL_TEXT.prototype.initialize = function (node, parent) {
	super.initialize(node, parent);
}

DENG.CSMIL_TEXT.prototype.create = function () {
	//super.create();
	// create mcs
	this.mc = this.xmlDomRef.mc.createEmptyMovieClipExt();
	this.mcMask = this.mc.createEmptyMovieClipExt("_MASK_");
	this.mcContent = this.mc.createEmptyMovieClipExt("_CONTENT_");
	this.mcContent.setMask(this.mcMask);
	this.mc.classRef = this.mcContent.classRef = this;

	var _src = this.node.attributes.src;
	if(_src != undefined && _src.length > 0) {
		// the source attribute was defined:
		// create a new DENG instance
		this.mcContent.attachMovie("FDengSymbol", "__DENG__", 1);
		this.mcDeng = this.mcContent.__DENG__;
		this.mcDeng.addListener(this);
		// set the document url
		var _u = new DENG.CUri(_src, this.xmlDomRef.getBaseUrl());
		this.mcDeng.documentUri = _u.getAbsolute();
		this.mcDeng.forceProxyScript = this.xmlDomRef.callback.forceProxyScript;
		this.mcDeng.proxyScript = this.xmlDomRef.callback.proxyScript;
	}

	this.isBlockElement = true;
}

DENG.CSMIL_TEXT.prototype.size = function () {
	// get the calculated bounds of this MediaObject from
	// the corresponding region info object in layout
	// (calculated in the parent element's size method,
	// see call to calcChildFrames in FRAMES and GROUP)
	var _fi = this.region;
	//this.cbX = this.mc._x = parseInt(_fi.left);
	//this.cbY = this.mc._y = parseInt(_fi.top);
	this.cbWidth = parseInt(_fi.width);
	this.cbHeight = this.$height = parseInt(_fi.height);

	this.getBorderCssProperties();

	var _mt = this.resolveCssProperty("margintop");
	var _mr = this.resolveCssProperty("marginright");
	var _mb = this.resolveCssProperty("marginbottom");
	var _ml = this.resolveCssProperty("marginleft");
	var _pt = this.resolveCssProperty("paddingtop");
	var _pr = this.resolveCssProperty("paddingright");
	var _pb = this.resolveCssProperty("paddingbottom");
	var _pl = this.resolveCssProperty("paddingleft");
	var _cx = _ml + _pl + this.$cssBorder.l.w;
	var _cy = _mt + _pt + this.$cssBorder.t.w;
	this.calcContentX = this.cbX + _cx;
	this.calcContentY = this.cbY + _cy;
	this.calcContentWidth = this.cbWidth - _cx - _mr - _pr - this.$cssBorder.r.w;
	this.calcContentHeight = this.cbHeight - _cy - _mb - _pb - this.$cssBorder.b.w;

	if(this.mcDeng != undefined) {
		this.mcDeng._x = this.calcContentX - this.cbX;
		this.mcDeng._y = this.calcContentY - this.cbY;
		this.mcDeng.setSize(this.calcContentWidth, this.calcContentHeight);
	}

	this.mcDeng.render();
}

DENG.CSMIL_TEXT.prototype.position = function () {
	return super.position();
}



