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
//   class DENG.CXHTML_LINK
// ===========================================================================================

DENG.CXHTML_LINK = function() { super(); }

DENG.CXHTML_LINK.prototype = new DENG.CWnd();


DENG.CXHTML_LINK.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	//mytrace("", "CXHTML_LINK", "init");
	var _attr = this.node.attributes;
	if(_attr.href != undefined && _attr.rel.toLowerCase() == "stylesheet") {
		// process uri
		var _d = new Date();
		var _u = new DENG.CUri(_attr.href, this.getBaseUrl());
		if(_u.$querySplit != undefined) {
			delete _u.$querySplit.c;
		}
		if(_u.$scheme != "file") {
			_u.addQueryVar("c", Math.round(Math.random() * _d * 100));
		}
		// add external stylesheet to queue
		this.xmlDomRef.cssParseQueue.push({ type: 0, uri: _u.getAbsolute() });
	}
}

