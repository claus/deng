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
//   class DENG.CXForms_BIND
// ===========================================================================================

DENG.CXForms_BIND = function()
{
	super();
}

DENG.CXForms_BIND.extend(DENG.CXFormsWnd);

DENG.CXForms_BIND.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	if (this.getModel()) {
		var attrs = this.node.attributes;
		if (this.check(this.xpath = attrs.nodeset)) {
			this.xmlDomRef.addBind(attrs.id, this);
		} else {
			this.xmlDomRef.errorMsg("no nodeset attribute on this bind: " +this.node);
		}
	}
};

DENG.CXForms_BIND.prototype.getParentContext = function () {
    return this.parentNode.getContext();
};

DENG.CXForms_BIND.prototype.getContext = function () {
    // TODO: doing lazy evaluation for binds for now 
	// (if a bind is not referenced by any control it will NOT be evaluated 
	// until a nested bind needs its parent context)
	if (!this.context) this.doBind();
	return this.context;
};
