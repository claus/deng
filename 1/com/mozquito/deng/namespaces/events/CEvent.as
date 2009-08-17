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

///////////////////////////////////////
// Event interface
// (DOM Level 2 Event Model)
///////////////////////////////////////
/*
* // Introduced in DOM Level 2:
* interface Event {
* 
*   // PhaseType
*   const unsigned short      CAPTURING_PHASE                = 1;
*   const unsigned short      AT_TARGET                      = 2;
*   const unsigned short      BUBBLING_PHASE                 = 3;
* 
*   readonly attribute DOMString        type;
*   readonly attribute EventTarget      target;
*   readonly attribute EventTarget      currentTarget;
*   readonly attribute unsigned short   eventPhase;
*   readonly attribute boolean          bubbles;
*   readonly attribute boolean          cancelable;
*   readonly attribute DOMTimeStamp     timeStamp;
*   void               stopPropagation();
*   void               preventDefault();
*   void               initEvent(in DOMString eventTypeArg, 
*                                in boolean canBubbleArg, 
*                                in boolean cancelableArg);
* };
*/

_global.Event = DENG.CEvent = function() {
	// uncomment this for full compliance, I guess it would be slow
	//this.timeStamp = new Date().getMilliseconds()
	this.bubbles = true;
	this.cancelable = this.stopPropagation = this.preventDefault = false;
}

Event.CAPTURING_PHASE = 1;
Event.AT_TARGET       = 2;
Event.BUBBLING_PHASE  = 3;

DENG.CEvent.prototype.initEvent = function (type, bubbles, cancelable) {
	this.type = type;
	this.bubbles = bubbles;
	this.cancelable = cancelable;
};
DENG.CEvent.prototype.stopPropagation = function () {
	this.stopPropagation = true;
};
DENG.CEvent.prototype.preventDefault = function () {
	this.preventDefault = true;
};
