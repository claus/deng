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
//   class DENG.CTableWrapper
// ===========================================================================================

DENG.CTableWrapper = function() { super(); }

DENG.CTableWrapper.prototype = new DENG.CWnd();

DENG.CTableWrapper.prototype.create = function()
{
	//mytrace(this.toString(), "CTableWrapper", "create");
	var _cno = this.childNodes[0];
	if(_cno) {
		do {
			_cno.create();
		}
		while(_cno = _cno.nextSibling);
	}
}

DENG.CTableWrapper.prototype.size = function()
{
	//mytrace("available width: " + this.parentNode.calcContentWidth, "CTableWrapper", "size");
	var _cno = this.childNodes[0];
	if(_cno) {
		var _init = true;
		do {
			if(_init) {
				_init = false;
				if(this.columns == undefined) {
					this.columns = [];
				} else {
					while(this.columns.length) {
						delete this.columns.pop();
					}
				}
				var i = 0;
				var _gcno = _cno.childNodes[0];
				if(_gcno) {
					var _sum_abs = 0;
					var _sum_auto = 0;
					do {
						var _w = _gcno.resolveCssProperty("width");
						if(typeof _w == "number") {
							_sum_abs += _w;
						} else if(_w == "auto") {
							_sum_auto++;
						} else if(_w[0].type == 5) {
							_w = Math.round(_w[0].value * this.parentNode.calcContentWidth / 100);
							_sum_abs += _w;
						}
						this.columns[i] = { w:_w };
						i++;
					}
					while(_gcno = _gcno.nextSibling);
					//mytrace("sumAbs:" + _sum_abs + " sumAuto:" + _sum_auto, "CTableWrapper", "size");

					var _availWidth = this.parentNode.calcContentWidth - _sum_abs;
					if(_availWidth < 0) {
						var _deltaIdx;
						var _first = true;
						var _sum_abs_new = 0;
						var _norm = this.parentNode.calcContentWidth / _sum_abs;
						for(i in this.columns) {
							if(typeof this.columns[i].w == "number") {
								if(_first) {
									_first = false;
									_deltaIdx = i;
								}
								this.columns[i].w *= _norm;
								_sum_abs_new += this.columns[i].w;
							}
						}
						this.columns[_deltaIdx].w += this.parentNode.calcContentWidth - _sum_abs_new;
						_availWidth = 0;

						if(_sum_auto) {
							for(i in this.columns) {
								if(this.columns[i].w == "auto") {
									this.columns[i].w = 0;
								}
							}
						}
					} else {
						if(_sum_auto) {
							var _deltaIdx;
							var _first = true;
							var _sum_abs_new = 0;
							for(i in this.columns) {
								if(this.columns[i].w == "auto") {
									if(_first) {
										_first = false;
										_deltaIdx = i;
									}
									this.columns[i].w = Math.round(_availWidth / _sum_auto);
								}
								_sum_abs_new += this.columns[i].w;
							}
							this.columns[_deltaIdx].w += this.parentNode.calcContentWidth - _sum_abs_new;
						}
					}

					var __sum = 0;
					var __cl = this.columns.length;
					for(i = 0; i < __cl; i++) {
						this.columns[i].x = __sum;
						__sum += this.columns[i].w;
					}
				}
			}
			_cno.size();
		}
		while(_cno = _cno.nextSibling);
	}
}

DENG.CTableWrapper.prototype.toString = function()
{
	return "<" + this.node.nodeName + "> [tablewrapper]";
}
