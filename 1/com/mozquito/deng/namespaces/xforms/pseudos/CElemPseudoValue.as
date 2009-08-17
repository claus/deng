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
//   class DENG.CElemPseudoValue
// ===========================================================================================

DENG.CElemPseudoValue = function() { super(); }

DENG.CElemPseudoValue.extend(DENG.CWnd);

DENG.CElemPseudoValue.prototype.cssPseudoClass = "value";

DENG.CElemPseudoValue.prototype.create = function()
{
	// create the actual control (textfield)
	new DENG.CElemPseudo_BoundText().regChildnode(this, this.node);

	super.create();
	
	var _txt = this.parentNode.control;
	if(this.resolveCssProperty("height") != "auto") {
		//mytrace(this.parentNode.node.nodeName, "CXForms", "create");
		_txt.autoSize = "none";
	}
	// alternative onChanged handler
	// (fixes various bugs)
	_txt.onSetFocus = function() {
		this.$textTmp = this.text;
		this.$changeIntervalID = setInterval(this, "changeMonitor", 10);
	}
	_txt.onKillFocus = function() {
		clearInterval(this.$changeIntervalID);
	}
	_txt.changeMonitor = function() {
		if(this.$textTmp != this.text) {
			this.$textTmp = this.text;
			this.broadcastMessage("onChangedDelay");
		}
	}
}

DENG.CElemPseudoValue.prototype.checkPseudos_value = function () {return true;}

DENG.CElemPseudoValue.prototype.toString = function()
{
	return "<" + this.node.nodeName + "::value>";
}
