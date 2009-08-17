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
//   class DENG.CQueue
// ===========================================================================================

// -------------------------------------------------------------------------------------------
// CQueue constructor
// -------------------------------------------------------------------------------------------
// arguments:
// - numSlots (integer) optional
//   the number of slots for simultaneous loading
//   (defaults to 2 - this is the recommended value)
// -------------------------------------------------------------------------------------------
DENG.CQueue = function(numSlots)
{
	this.$queue = [];
	this.$queueNeedsSort = false;
	
	this.$slots = [];
	if(numSlots == undefined || numSlots < 1) { numSlots = 2; }
	for(var _i = 0; _i < numSlots; _i++) {
		this.$slots.push( { status:"empty", timeoutStart:null } );
	}
	
	this.$mcObserverIVID = null;
	this.$processQueueIVID = null;
	this.addProperty("run", this.getRun, this.setRun);
	this.addProperty("timeout", this.getTimeout, this.setTimeout);
}


// ===========================================================================================
//   properties
// ===========================================================================================

DENG.CQueue.prototype.$run = false;
DENG.CQueue.prototype.$timeout = 1000;


// ===========================================================================================
//   property getter/setter
// ===========================================================================================

DENG.CQueue.prototype.getRun = function() {
	return this.$run;
}

DENG.CQueue.prototype.setRun = function(_run) {
	if(_run && !this.$run) {
		// start
		this.$run = true;
		this.processQueue();
	} else if(!_run && this.$run) {
		// stop
		this.$run = false;
		// todo: stopping items in slots?
	}
}

DENG.CQueue.prototype.getTimeout = function() {
	return this.$timeout;
}

DENG.CQueue.prototype.setTimeout = function(_timeout) {
	this.$timeout = _timeout;
}


// ===========================================================================================
//   public methods
// ===========================================================================================

// -------------------------------------------------------------------------------------------
// CQueue.addObject
// -------------------------------------------------------------------------------------------
// arguments:
// - prio (integer)
//   specify a priority
//   0..9999: may still load after rendering is done (low priority)
//   10000-19999: must be finished before size (medium priority)
//   20000 and above: must be finished before create (high priority)
// - targetObj (XML/LoadVars/MovieClip)
// - uri (string)
// -------------------------------------------------------------------------------------------
// returns: nada
// -------------------------------------------------------------------------------------------
DENG.CQueue.prototype.addObject = function(prio, targetObj, uri) {
	this.$queue.push( { status:"idle", prio:prio, target:targetObj, uri:uri } );
	this.$queueNeedsSort = true;
	if(this.getRun()) {
		this.processQueue();
	}
}

// -------------------------------------------------------------------------------------------
// CQueue.getPendingObjects
// -------------------------------------------------------------------------------------------
// arguments:
// - minPrio (integer) optional
// -------------------------------------------------------------------------------------------
// returns: (integer)
// the amount of pending items in the queue 
// (if minPrio is specified, only those with a priority >= minPrio)
// -------------------------------------------------------------------------------------------
DENG.CQueue.prototype.getPendingObjects = function(minPrio) {
	var _num = 0;
	for(var _i in this.$queue) {
		if(minPrio == undefined || this.$queue[_i].prio >= minPrio) {
			++_num;
		}
	}
	return _num;
}


// ===========================================================================================
//   private methods
// ===========================================================================================

DENG.CQueue.prototype.processQueue = function() {
	clearInterval(this.$processQueueIVID);
	this.$processQueueIVID = null;
	// clean up queue (remove objects that are "done")
	var _i = this.$queue.length;
	while(--_i -(-1)) {
		if(this.$queue[_i].status == "done") {
			this.$queue.splice(_i, 1);
		}
	}
	if(this.getRun() && this.$queue.length) {
		var _boringQueue = false;
		var _emptySlot = this.getEmptySlot();
		while(!_boringQueue && _emptySlot) {

			// eventually sort queue by prio
			if(this.$queueNeedsSort) {
				// sort $queue
				this.$queue.sort(this.sortQueueByPrio);
				this.$queueNeedsSort = false;
			}

			// try to find an idle queue item
			// if none is found, nothing is to be done. the queue is "boring"
			// if there is an idle item, connect it to the free slot and initiate loading process
			_boringQueue = true;
			var _i = this.$queue.length;
			while(--_i -(-1)) {
				var _qitem = this.$queue[_i];
				if(_qitem.status == "idle") {
					_qitem.slot = _emptySlot;
					_qitem.status = "processing";
					_emptySlot.queueItemRef = _qitem;
					_emptySlot.status = "loading";
					_emptySlot.originalOnLoad = _qitem.target.onLoad;

					if(typeof _qitem.target == "movieclip") {
						// the target is a movieclip:
						// load the movieclip/jpeg
						_qitem.target.loadMovie(_qitem.uri);
						// and observe the loading status
						this.observeSlots();
					} else {
						// target is XML or LoadVars:
						// hijack the onLoad handler
						_qitem.target.__$queueCallback$__ = this;
						_qitem.target.__$queueItemCallback$__ = _qitem;
						_qitem.target.onLoad = function(success) {
							this.__$queueCallback$__.onLoadHandler(this, this.__$queueItemCallback$__, success);
						}
						// and load the data
						_qitem.target.load(_qitem.uri);
					}
					_boringQueue = false;
					_emptySlot = this.getEmptySlot();
					break;
				}
			}
		}
	}
}

DENG.CQueue.prototype.observeSlots = function() {
	if(this.$mcObserverIVID == null) {
		this.$mcObserverIVID = setInterval(this, "observer", 1);
	}
}

DENG.CQueue.prototype.observer = function() {
	var _nothingToObserve = true;
	for(var _i in this.$slots) {
		var _slot = this.$slots[_i];
		var _slotTarget = _slot.queueItemRef.target;
		if(_slot.status == "loading" && typeof _slotTarget == "movieclip") {
			var _bl = _slotTarget.getBytesLoaded();
			var _bt = _slotTarget.getBytesTotal();
			if(_bl > 0 && _bt > 0) {
				if(_bl == _bt) {
					this.onLoadHandler(_slotTarget, _slot.queueItemRef, true);
				} else {
					_nothingToObserve = false;
				}
			} else {
				if(_slot.timeoutStart != null) {
					if(getTimer() - _slot.timeoutStart > this.getTimeout()) {
						this.onLoadHandler(_slotTarget, _slot.queueItemRef, false);
					} else {
						_nothingToObserve = false;
					}
				} else {
					_slot.timeoutStart = getTimer();
					_nothingToObserve = false;
				}
			}
		}
	}
	if(_nothingToObserve) {
		clearInterval(this.$mcObserverIVID);
		this.$mcObserverIVID = null;
	}
}

DENG.CQueue.prototype.sortQueueByPrio = function(a, b) {
	return (a.prio > b.prio);
}

DENG.CQueue.prototype.getEmptySlot = function() {
	for(var _i in this.$slots) {
		if(this.$slots[_i].status == "empty") {
			return this.$slots[_i];
		}
	}
	return null;
}

DENG.CQueue.prototype.onLoadHandler = function(target, queueItemRef, success) {
	var _slot = queueItemRef.slot;
	_slot.status = "empty";
	_slot.timeoutStart = null;
	target.onLoad = _slot.originalOnLoad;
	if(typeof(target) == "movieclip") {
		delete target.__$queueCallback$__;
		delete target.__$queueItemCallback$__;
	}
	delete _slot.originalOnLoad;
	delete _slot.queueItemRef;
	queueItemRef.status = "done";
	queueItemRef.target.onLoad(success);
	if(this.$processQueueIVID == null) {
		this.$processQueueIVID = setInterval(this, "processQueue", 100);
	}
}

