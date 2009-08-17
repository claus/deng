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
//   class DENG.CXFramesWnd
// ===========================================================================================

DENG.CXFramesWnd = function()
{
	super();
}

DENG.CXFramesWnd.extend(DENG.CWnd);
DENG.CXFramesWnd.prototype.position = null;


DENG.CXFramesWnd.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	// if the style attribute is set (inline styles)
	if(this.node.attributes.style != undefined) {
		// add inline styles to queue
		this.xmlDomRef.cssParseQueue.push({ type: 2, css: this.node.attributes.style, obj: this });
	}
}

DENG.CXFramesWnd.prototype.create = function()
{
	this.isBlockElement = true;
	this.getBorderCssProperties();

	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.create();
		}
		while(_cno = _cno.nextSibling);
	}
}

DENG.CXFramesWnd.prototype.size = function()
{
	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.size();
		}
		while(_cno = _cno.nextSibling);
	}
}



DENG.CXFramesWnd.prototype.registerFrame = function()
{
	// first check the id attribute:
	// if no id was given or the given id is already in use
	// then create a random id
	var _id = this.node.attributes.id;
	var _frames = this.rootNode.$frames;
	if(_id == undefined || !_id.length || _frames[_id] != undefined) {
		do {
			_id = "$id" + Math.floor(Math.random() * 65536).toString(16);
		}
		while(_frames[_id] != undefined);
	}

	// add the id to the parent node's childFrames array
	// (so the parent, either <frames> or <group>, can determine frame sizes, etc)
	this.parentNode.$childFrames.push(_id);

	// register frame in the root node's $frames object
	// (so the root can cycle through all frames and create them sequentially, etc)
	_frames[_id] = {
		obj: this,
		width: this.resolveCssProperty("width"),
		height:this.resolveCssProperty("height")
	};
	
	// remember my own id
	this.$id = _id;
}



DENG.CXFramesWnd.prototype.calcChildFrames = function()
{
	var _compose = this.resolveCssProperty("compose");
	switch(_compose)
	{
		case "horizontal":
		case "vertical":
			var _isHor = (_compose == "horizontal");
			var _sumAbs = 0; // sum of absolute width values
			var _sumPerc = 0; // sum of percent values
			var _nPerc = 0; // number of percentage elements
			var _nAuto = 0; // number of autosized elements
			var _nTotal = 0; // total number of elements

			// LOOP 1: resolve local variables above
			var _fil = this.$childFrames.length;
			for(var _i = 0; _i < _fil; _i++) {
				++_nTotal;
				var _valid = true;
				var _pos = 0;
				var _val = 0;
				var _fi = this.rootNode.$frames[this.$childFrames[_i]];
				var _fiw = _isHor ? _fi.width : _fi.height;
				switch(typeof _fiw) {
					case "number":
						_sumAbs += _fiw;
						_val = _fiw;
						break;
					case "string":
						if(_fiw == "auto") {
							++_nAuto;
							_pos = 1;
						} else {
							_valid = false;
						};
						break;
					case "object":
						if(_fiw[0].type == 5) {
							_sumPerc += _fiw[0].value;
							++_nPerc;
							_pos = 2;
							_val = _fiw[0].value;
						} else {
							_valid = false;
						};
						break;
					default:
						_valid = false;
						break;
				}
				if(_valid) {
					_fi.pos = _pos;
					_fi.value = _val;
					if(_isHor) {
						_fi.calcY = this.calcContentY;
						_fi.calcHeight = this.calcContentHeight;
					} else {
						_fi.calcX = this.calcContentX;
						_fi.calcWidth = this.calcContentWidth;
					}
				}
				_fi.valid = _valid;
			}

			// prepare to scale everything to 100%
			var _sizeAvail = _isHor ? this.calcContentWidth : this.calcContentHeight;
			var _absScale;
			var _percScale;
			var _autoSize;
			if(_sumAbs) {
				_absScale = ((_sumAbs > _sizeAvail) || (!_nPerc && !_nAuto)) ? _sizeAvail / _sumAbs : 1;
				_sizeAvail -= Math.round(_sumAbs * _absScale);
			}
			if(_nAuto && _sizeAvail > 0) {
				_autoSize = Math.round(_sizeAvail / (_nAuto + _nPerc));
				_sizeAvail -= Math.round(_autoSize * _nAuto);
			} else {
				_autoSize = Math.round(_sizeAvail / _nPerc);
			}
			if(_nPerc && _sizeAvail > 0) {
				_percScale = 100 / _sumPerc;
			}

			// LOOP 2: determine the calculated size
			var _totalSize = 0;
			var _cfil = this.$childFrames.length;
			for(var _i = 0; _i < _cfil; _i++) {
				var _fi = this.rootNode.$frames[this.$childFrames[_i]];
				switch(_fi.pos) {
					case 0:
						if(_isHor) {
							_fi.calcWidth = Math.round(_fi.value * _absScale);
						} else {
							_fi.calcHeight = Math.round(_fi.value * _absScale);
						}
						break;
					case 1:
						if(_isHor) {
							_fi.calcWidth = _autoSize;
						} else {
							_fi.calcHeight = _autoSize;
						}
						break;
					case 2:
						if(_isHor) {
							_fi.calcWidth = Math.round(_autoSize * _nPerc * _fi.value * _percScale / 100);
						} else {
							_fi.calcHeight = Math.round(_autoSize * _nPerc * _fi.value * _percScale / 100);
						}
						break;
				}
				if(_isHor) {
					_fi.calcX = this.calcContentX + _totalSize;
					_totalSize += _fi.calcWidth;
				} else {
					_fi.calcY = this.calcContentY + _totalSize;
					_totalSize += _fi.calcHeight;
				}
				delete _fi.pos;
				delete _fi.value;
			}
			break;

		case "tabbed":
			break;

		case "free":
			break;
	}
}



