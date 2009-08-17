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
//   interface DENG.ISMIL_HostDoc
// ===========================================================================================


DENG.ISMIL_HostDoc = {};

DENG.ISMIL_HostDoc.initSMILHostDoc = function() {
	this.smilLayout = {};
	this.smilAnimations = {};
	this.initEventSource();
	this.initCallback();
}

DENG.ISMIL_HostDoc.initEventSource = function () {
	AsBroadcaster.initialize(MovieClip);
	//var mc = _level0.createEmptyMovieClip("$enterframe_source", 9876);
	var mc = _level0.createEmptyMovieClipExt();
	mc.onEnterFrame = function ( ) {
		_global.MovieClip.broadcastMessage("onEnterFrame");
	};
}

DENG.ISMIL_HostDoc.initCallback = function () {
	var callbackObj = {};
	callbackObj.controller = this;
	callbackObj.onRender = function () {
		this.controller.smilAnimate();
	};
	this.callback.addListener(callbackObj);
}

DENG.ISMIL_HostDoc.registerAnimation = function (id, a) {
	this.smilAnimations[id] = a;
}

DENG.ISMIL_HostDoc.smilAnimate = function () {
	for (var i in this.smilAnimations) {
		this.smilAnimations[i].startAnimation();
	}
}


