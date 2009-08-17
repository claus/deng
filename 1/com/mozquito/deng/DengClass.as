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

#include "com/mozquito/deng/deng.as"
#include "com/mozquito/deng/dengXHTML.as"
#include "com/mozquito/deng/dengSVG.as"
#include "com/mozquito/deng/dengXFrames.as"
#include "com/mozquito/deng/dengEvents.as"
#include "com/mozquito/deng/dengXForms.as"
#include "com/mozquito/deng/dengMMCustomActions.as"
#include "com/mozquito/deng/dengDENGProxyResponse.as"
#include "com/mozquito/deng/dengSMIL.as"

function DengClass() {
	this.init();
}

DengClass.prototype = new MovieClip();

DengClass.prototype.documentUri_param = "";
DengClass.prototype.xmlSource_param = "";
DengClass.prototype.userStylesheets_param = [];
DengClass.prototype.proxyScript_param = "";
DengClass.prototype.forceProxyScript_param = true;
DengClass.prototype.enableDefaultStylesheets_param = true;
DengClass.prototype.enableUserStylesheets_param = true;
DengClass.prototype.enableAuthorStylesheets_param = true;
DengClass.prototype.embeddedFonts_param = [];

DengClass.prototype.init = function()
{
	// create DENG dom 
	// and reference main movieclip (this component)
	this.dom = new DENG.CDom(this);
	this.dom.mc = this;
	this.dom.pos = {};
	
	// hook callback handlers
	this.dom.onLoadXML = function(succes, status) { this.callback.onLoadXML(succes, status); };
	this.dom.onParseCSS = function() { this.callback.onParseCSS(); };
	this.dom.onCreate = function() { this.callback.onCreate(); };
	this.dom.onSize = function() { this.callback.onSize(); };
	this.dom.onPosition = function() { this.callback.onPosition(); };
	this.dom.onRender = function() { this.callback.onRender(); };
	this.dom.onClickHandler = function(obj, linkUrl, targetStyle, targetPosition, targetName) {
		this.callback.onClickHandler(obj, linkUrl, targetStyle, targetPosition, targetName);
	};
	this.dom.onScroll = function(obj, y) {
		this.callback.onScroll(obj, y);
	};
	
	// initialize component properties
	this.proxyScript = this.proxyScript_param;
	this.forceProxyScript = this.forceProxyScript_param;
	this.userStylesheets = this.userStylesheets_param;
	this.enableDefaultStylesheets = this.enableDefaultStylesheets_param;
	this.enableUserStylesheets = this.enableUserStylesheets_param;
	this.enableAuthorStylesheets = this.enableAuthorStylesheets_param;
	this.embeddedFonts = this.embeddedFonts_param;
	
	// initialize listeners
	ASBroadcaster.initialize(this);

	// anti distortion
	this.componentWidth = this._width;
	this.componentHeight = this._height;
	this._xscale = this._yscale = 100;
	this.boundingBox_mc._visible = false;
	this.setSize(this.componentWidth, this.componentHeight);
}

DengClass.prototype.render = function()
{
	if(this.xmlSource_param == "") {
		this.dom.load(this.documentUri_param);
	} else {
		this.dom.onData(this.xmlSource_param);
	}
}

DengClass.prototype.setSize = function(w, h)
{
	// anti distortion
	this.componentWidth = this.boundingBox_mc._width = w;
	this.componentHeight = this.boundingBox_mc._height = h;

	this.dom.pos.x = this._x;
	this.dom.pos.y = this._y;
	this.dom.pos.width = w;
	this.dom.pos.height = h;

	this.dom.size();
}

DengClass.prototype.getSource = function()
{
	return this.dom.getSource();
}

DengClass.prototype.cleanUp = function()
{
	this.dom.cleanUp();
	delete this.dom;
}

DengClass.prototype.addEmbeddedFont = function(name, defaultSize)
{
	if(defaultSize == 0 || defaultSize == undefined) {
		defaultSize = -1;
	}
	this.embeddedFonts_param.push(name);
	DENG.$fonts[name] = defaultSize;
}


// ===========================================================
//  getter/setter
// ===========================================================


DengClass.prototype.getDocumentUri = function() {
	return this.documentUri_param;
}
DengClass.prototype.setDocumentUri = function(documentUri) {
	this.documentUri_param = documentUri;
	this.xmlSource_param = "";
}


DengClass.prototype.getXmlSource = function() {
	return this.xmlSource_param;
}
DengClass.prototype.setXmlSource = function(xmlSource) {
	this.xmlSource_param = xmlSource;
	this.documentUri_param = "";
}


DengClass.prototype.getUserStylesheets = function() {
	return this.userStylesheets_param;
}
DengClass.prototype.setUserStylesheets = function(userStylesheets) {
	if(typeof userStylesheets == "string") {
		userStylesheets = [userStylesheets];
	}
	delete this.userStylesheets_param;
	this.userStylesheets_param = userStylesheets;
	delete this.dom.cssUser;
	this.dom.cssUser = [];
	for(var _i = 0; _i < userStylesheets.length; _i++) {
		this.dom.addUserStylesheet(userStylesheets[_i]);
	}
}


DengClass.prototype.getProxyScript = function() {
	return this.proxyScript_param;
}
DengClass.prototype.setProxyScript = function(proxyScript) {
	this.proxyScript_param = DENG.$redirecturl = proxyScript;
}


DengClass.prototype.getForceProxyScript = function() {
	return this.forceProxyScript_param;
}
DengClass.prototype.setForceProxyScript = function(forceProxyScript) {
	this.forceProxyScript_param = DENG.$forceProxy = forceProxyScript;
}


DengClass.prototype.getEnableDefaultStylesheets = function() {
	return this.enableDefaultStylesheets_param;
}
DengClass.prototype.setEnableDefaultStylesheets = function(enableDefaultStylesheets) {
	this.enableDefaultStylesheets_param = this.dom.$enableDefaultStylesheets = enableDefaultStylesheets;
}


DengClass.prototype.getEnableUserStylesheets = function() {
	return this.enableUserStylesheets_param;
}
DengClass.prototype.setEnableUserStylesheets = function(enableUserStylesheets) {
	this.enableUserStylesheets_param = this.dom.$enableUserStylesheets = enableUserStylesheets;
}


DengClass.prototype.getEnableAuthorStylesheets = function() {
	return this.enableAuthorStylesheets_param;
}
DengClass.prototype.setEnableAuthorStylesheets = function(enableAuthorStylesheets) {
	this.enableAuthorStylesheets_param = this.dom.$enableAuthorStylesheets = enableAuthorStylesheets;
}


DengClass.prototype.getDengVersion = function() {
	return { major:DENG.$version, minor:DENG.$minor, build:DENG.$build };
}


DengClass.prototype.getEmbeddedFonts = function() {
	return this.embeddedFonts_param;
}
DengClass.prototype.setEmbeddedFonts = function(embeddedFonts) {
	var _i;
	for(var _i in this.embeddedFonts_param) {
		delete DENG.$fonts[this.embeddedFonts_param[_i]];
	}
	if(typeof embeddedFonts == "string") {
		embeddedFonts = [embeddedFonts];
	}
	delete this.embeddedFonts_param;
	this.embeddedFonts_param = [];
	for(_i in embeddedFonts) {
		this.addEmbeddedFont(embeddedFonts[_i]);
	}
}

DengClass.prototype.getContentHeight = function() {
	return this.dom.uiDom.contentHeight;
}


DengClass.prototype.addProperty("documentUri", DengClass.prototype.getDocumentUri, DengClass.prototype.setDocumentUri); 
DengClass.prototype.addProperty("xmlSource", DengClass.prototype.getXmlSource, DengClass.prototype.setXmlSource); 
DengClass.prototype.addProperty("userStylesheets", DengClass.prototype.getUserStylesheets, DengClass.prototype.setUserStylesheets); 
DengClass.prototype.addProperty("proxyScript", DengClass.prototype.getProxyScript, DengClass.prototype.setProxyScript); 
DengClass.prototype.addProperty("forceProxyScript", DengClass.prototype.getForceProxyScript, DengClass.prototype.setForceProxyScript); 
DengClass.prototype.addProperty("enableDefaultStylesheets", DengClass.prototype.getEnableDefaultStylesheets, DengClass.prototype.setEnableDefaultStylesheets); 
DengClass.prototype.addProperty("enableUserStylesheets", DengClass.prototype.getEnableUserStylesheets, DengClass.prototype.setEnableUserStylesheets); 
DengClass.prototype.addProperty("enableAuthorStylesheets", DengClass.prototype.getEnableAuthorStylesheets, DengClass.prototype.setEnableAuthorStylesheets); 
DengClass.prototype.addProperty("dengVersion", DengClass.prototype.getDengVersion, null); 
DengClass.prototype.addProperty("embeddedFonts", DengClass.prototype.getEmbeddedFonts, DengClass.prototype.setEmbeddedFonts); 
DengClass.prototype.addProperty("contentHeight", DengClass.prototype.getContentHeight, null); 


// ===========================================================
// internal callback handlers
// ===========================================================

DengClass.prototype.onLoadXML = function(success, status) {
	this.broadcastMessage("onLoadXML", success, status);
}

DengClass.prototype.onParseCSS = function() {
	this.broadcastMessage("onParseCSS");
}

DengClass.prototype.onCreate = function() {
	this.broadcastMessage("onCreate");
}

DengClass.prototype.onSize = function() {
	this.broadcastMessage("onSize");
}

DengClass.prototype.onPosition = function() {
	this.broadcastMessage("onPosition");
}

DengClass.prototype.onRender = function() {
	this.broadcastMessage("onRender");
}

DengClass.prototype.onClickHandler = function(obj, linkUrl, targetStyle, targetPosition, targetName) {
	this.broadcastMessage("onClickHandler", linkUrl, targetStyle, targetPosition, targetName);
}

DengClass.prototype.onScroll = function(obj, y) {
	this.broadcastMessage("onScroll", y);
}


Object.registerClass("FDengSymbol", DengClass);

