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
//   class DENG.CEventsWnd
// ===========================================================================================

DENG.CEventsWnd = function()
{
	super();
};

DENG.CEventsWnd.extend(DENG.CWnd);

DENG.CEventsWnd.prototype.initialize = function (node, parent) {
	super.initialize(node, parent);
	var event = this.getEventAttribute("event");
	if (event != null) {
		var observer = this.getEventAttribute("observer");
		var handler  = this.getEventAttribute("handler");
		var phase    = this.getEventAttribute("phase");
		if (this.check(handler)) {
			this.handler = this.xmlDomRef.getElementById(handler.substring(1));
			if (this.handler == null) {
				this.xmlDomRef.errorMsg("couldn't get handler at this url: " +handler);
			}
		} else {
			this.handler = this;
		}
		if (this.check(observer)) {
			this.observer = this.xmlDomRef.getElementById(observer);
			if (this.observer == null) {
				this.xmlDomRef.errorMsg("no observer found with this id: " +observer);
				return;
			}
		} else {
			if (this.check(handler)) {
				this.observer = this;
			} else {
				this.observer = this.parentNode;
			}
		}
		if (phase != null) {
			this.phase = phase;
		} else {
			this.phase = "";
		}
		this.target =        this.getEventAttribute("target");
    	this.propagate =     this.getEventAttribute("propagate");
		this.defaultAction = this.getEventAttribute("defaultAction");
		//trace("attaching listener: " +this.node.nsNodeName +", target: " +this.target +", handler: " +this.handler.node.nsNodeName +", phase: '" +this.phase +"' to node: "+this.observer.node)
		this.observer.addEventListener(event, this, (this.phase == "capture"));
	}
};
DENG.CEventsWnd.prototype.create = function()
{
	super.create();
};
DENG.CEventsWnd.prototype.size = function()
{
	super.size();
};
DENG.CEventsWnd.prototype.position = function()
{
	return super.position();
};
DENG.CEventsWnd.prototype.paint = function()
{
	super.paint();
};
///////////////////////////////////////
// EventListener interface
// (DOM Level 2 Event Model)
///////////////////////////////////////
/* 
+ interface EventListener {
*   void               handleEvent(in Event evt);
* };
*/
DENG.CEventsWnd.prototype.handleEvent = function (e) {
	if (this.check(this.target)) {
		if (this.target == e.target.attributes.id) {
			trace("TARGETED EVENT!!");
		} else {
			trace("NOT FOR US");
			return;
		}
	}
	if (this.propagate == "stop") e.stopPropagation();
	if (this.defaultAction == "cancel") e.preventDefault();
	this.handler.activate(e);
};

///////////////////////////////////////
// EventTarget interface
// (DOM Level 2 Event Model)
///////////////////////////////////////
/* 
* interface EventTarget {
*   void               addEventListener(in DOMString type, 
*                                       in EventListener listener, 
*                                       in boolean useCapture);
*   void               removeEventListener(in DOMString type, 
*                                          in EventListener listener, 
*                                          in boolean useCapture);
*   boolean            dispatchEvent(in Event evt)
*                                         raises(EventException);
* };
*/
DENG.CEventsWnd.prototype.addEventListener = function(type, listener, useCapture)
{
	if (this.check(type) && listener instanceof DENG.CEventsWnd && typeof(useCapture) == "boolean") {
		// we remove and reinsert so that we are compatible with Xerces' implementation of the spec
		this.removeEventListener(type, listener, useCapture);
		if(this.$evListeners == undefined) this.$evListeners = []; 
		if(this.$evListeners[type] == undefined) this.$evListeners[type] = [];
		if(this.$evListeners[type][useCapture] == undefined) this.$evListeners[type][useCapture] = [];
		this.$evListeners[type][useCapture].push(listener);
		//trace("added a " +type +" " +((useCapture)?"capturing":"bubbling") +" to listeners table for: " +this.node);
	}
};
DENG.CEventsWnd.removeEventListener = function(type, listener, useCapture)
{
	var i, l = this.$evListeners[type][useCapture];
	for(i = 0; i < l.length; i++) {
		if(l[i] == listener) {
			l.splice(i, 1);
			break;
		}
	}
};
DENG.CEventsWnd.prototype.dispatchEvent = function (e) {
	e.target = this;
	e.stopPropagation = e.preventDefault = false;
	var i, l, listeners, parentChain = [], n = this.parentNode;
	do {
	    parentChain.push(n);
	} while (n = n.parentNode);
	
	e.eventPhase = Event.CAPTURING_PHASE;
	for (i = parentChain.length-1; i >= 0; i--) {
		if (e.stopPropagation) break;
		n = e.currentTarget = parentChain[i];
		listeners = n.$evListeners[e.type][true];
		for (l = 0; l < listeners.length; l++) 
			listeners[l].handleEvent(e);
	}
	
	e.eventPhase = Event.AT_TARGET;
	if (!e.stopPropagation) {
		e.currentTarget = this;
		listeners = this.$evListeners[e.type][false];
		for (l = 0; l < listeners.length; l++) 
			listeners[l].handleEvent(e);
	}
	
	if (e.bubbles) {
		e.eventPhase = Event.BUBBLING_PHASE;
		for (i = 0; i < parentChain.length; i++) {
			if (e.stopPropagation) break;
			n = e.currentTarget = parentChain[i];
			listeners = n.$evListeners[e.type][false];
			for (l = 0; l < listeners.length; l++) 
				listeners[l].handleEvent(e);
		}
	}
	
	return e.preventDefault;
};
DENG.CEventsWnd.prototype.getEventAttribute = function (name) {
	return this.node.getAttributeNS("http://www.w3.org/2001/xml-events", name);
};

// this is used also by XForms classes, OK since XForms depends on XML Events anyway
DENG.CEventsWnd.prototype.check = function (a)
{
	if ((a != undefined) && (a.length > 0)) {
		return true;
	} else {
		return false;
	}
};
