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
//   class DENG.CElemPseudoBefore
// ===========================================================================================

DENG.CElemPseudoBefore = function() { super(); }

DENG.CElemPseudoBefore.prototype = new DENG.CWnd();

DENG.CElemPseudoBefore.prototype.cssPseudoClass = "before";

DENG.CElemPseudoBefore.prototype.create = function()
{
	var _pc = new DENG.CElemPseudo_Text();
	_pc.regChildnode(this, this.node);
	super.create();
	if(this.isMarker) {
		var _txt = this.childNodes[0].tf;
		_txt.multiline = false;
		_txt.wordWrap = false;
		//_txt.autoSize = "none";
		//mytrace(_txt, "CWnd", "create");
	}
}

DENG.CElemPseudoBefore.prototype.size = function()
{
	with(this) {
		if(isMarker) {
			this.cbX = cbObj.calcContentX;
			this.cbY = cbObj.calcContentY;
			this.getBorderCssProperties();
			// calculate x/y coordinates of contained blocks
			this.calcPaddingX = $cssBorder.l.w;
			this.calcPaddingY = $cssBorder.t.w;
			this.calcContentX = calcPaddingX + this.resolveCssPropertyPercentage("paddingleft", cbObj.calcContentWidth);
			this.calcContentY = calcPaddingY + this.resolveCssPropertyPercentage("paddingtop", cbObj.calcContentHeight);
			// initialize flowOffset
			this.flowOffset = 0;
			// reset element's content width to 0
			this.calcContentWidth = 100;
			this.calcContentHeight = 0;
			// size child
			this.childNodes[0].size();
		} else {
			super.size();
		}
	}
}

DENG.CElemPseudoBefore.prototype.position = function()
{
	with(this) {
		if(isMarker) {
			var _top = this.contentHeight = this.resolveCssPropertyPercentage("paddingtop", cbObj.calcContentHeight) + $cssBorder.t.w;
			// calculate movieclip positions
			var y = cbObj.calcContentY + cbObj.flowOffset;
			var x = cbObj.calcContentX;
			// position childr
			this.contentHeight += this.childNodes[0].position();
			// add bottom margin/border/padding
			this.contentHeight += this.resolveCssPropertyPercentage("paddingbottom", cbObj.calcContentHeight) + $cssBorder.b.w;

			this.$height = this.contentHeight;
			this.cbWidth = this.childNodes[0].tf._width
								+ $cssBorder.l.w 
								+ $cssBorder.r.w
								+ this.resolveCssPropertyPercentage("paddingright", cbObj.calcContentWidth)
								+ this.resolveCssPropertyPercentage("paddingleft", cbObj.calcContentWidth);
			
			// position main movieclip
			mc._x = x - this.cbWidth - 2;
			mc._y = y - _top;
			return 0;
		} else {
			return super.position();
		}
	}
}

DENG.CElemPseudoBefore.prototype.toString = function()
{
	return "<" + this.node.nodeName + "::before>";
}

