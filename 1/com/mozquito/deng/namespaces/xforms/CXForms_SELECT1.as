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
//   class DENG.CXForms_SELECT1
// ===========================================================================================

DENG.CXForms_SELECT1 = function()
{
	super();
}

DENG.CXForms_SELECT1.extend(DENG.CXFormsItemListWnd);

DENG.CXForms_SELECT1.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.appearance = this.node.attributes.appearance;
	switch (this.appearance) {
		case "minimal":
			break;
		default:
			// TODO: appearance='full' is not implemented yet
			this.appearance = "compact";
			break;
	}
};

DENG.CXForms_SELECT1.prototype.create = function()
{
	super.create();
};

DENG.CXForms_SELECT1.prototype.size = function()
{
	/*if (this.appearance == "minimal") {
		this.pulldown.mc._visible = false;
		//this.pulldown.css.dom.propertyTableAttr.display = "none";
		//this.xmlDomRef.position();
		//this.xmlDomRef.size();
	}*/
	super.size();
	if (this.$initControlDone == undefined) {
		this.initControl();
		this.$initControlDone = true;
	}
};
/*
DENG.CXForms_SELECT1.prototype.position = function()
{
	var ret = super.position();
	if (this.appearance == "minimal") {
		this.xmlDomRef.infoMsg(ret);
		var point = new Object();
		this.xmlDomRef.infoMsg(point.x = this.mc._x);
		this.xmlDomRef.infoMsg(point.y = this.mc._y);
		this.mc._parent.localToGlobal(point);
		this.xmlDomRef.infoMsg(point.x);
		this.xmlDomRef.infoMsg(point.y);
		this.pulldown.mc._x = point.x;
		this.pulldown.mc._y = point.y +this.mc._height;
	}
	return ret
};*/

DENG.CXForms_SELECT1.prototype.position = function()
{
	return super.position();
};

DENG.CXForms_SELECT1.prototype.paint = function()
{
	super.paint();
	if (this.appearance == "minimal") {
		this.xmlDomRef.infoMsg(ret);
		var point = new Object();
		this.xmlDomRef.infoMsg(point.x = this.mc._x);
		this.xmlDomRef.infoMsg(point.y = this.mc._y);
		this.mc._parent.localToGlobal(point);
		this.xmlDomRef.infoMsg(point.x);
		this.xmlDomRef.infoMsg(point.y);
		this.pulldown.mc._x = point.x;
		this.pulldown.mc._y = point.y +this.mc._height;
	}
};
DENG.CXForms_SELECT1.prototype.createControl = function()
{
	if (this.appearance == "compact") {
		var _ctrl = this.control = new DENG.CElemPseudoChoices();
		_ctrl.childNodes = [];
		_ctrl.rootNode = this.rootNode;
		_ctrl.xmlDomRef = this.xmlDomRef;

		var i = 0;
		var _cno_next;
		var _cno = this.childNodes[0];
		if(_cno) {
			do {
				_cno_next = _cno.nextSibling;
				if(_cno.node.nsNodeName != "label") {
					this.moveChildnode(i, _ctrl);
				} else {
					i++;
				}
			}
			while(_cno = _cno_next);
		}

		_ctrl.regChildnode(this, this.node);
		// default styles
		this.setDefaultControlStyles(_ctrl);
		
	} else {
		// only if appearance = 'minimal'
		var _pdn = this.pulldown = new DENG.CElemPseudoChoices();
		_pdn.childNodes = [];
		_pdn.rootNode = this.rootNode;
		_pdn.xmlDomRef = this.xmlDomRef;

		var i = 0;
		var _cno_next;
		var _cno = this.childNodes[0];
		if(_cno) {
			do {
				_cno_next = _cno.nextSibling;
				if(_cno.node.nsNodeName != "label") {
					this.moveChildnode(i, _pdn);
				} else {
					i++;
				}
			}
			while(_cno = _cno_next);
		}

		var _ctrl = this.control = new DENG.CElemPseudoValue();


		_ctrl.regChildnode(this, this.node);
		_pdn.regChildnode(this, this.node);

		// default styles
		this.setDefaultControlStyles(_crtl);
		this.setDefaultPulldownStyles(_pdn);
	}
};

DENG.CXForms_SELECT1.prototype.setDefaultControlStyles = function (ctrlObj)
{
	var _pta = ctrlObj.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.backgroundcolor = 0xffffff;
	_pta.paddingtop = _pta.paddingbottom = _pta.paddingleft = _pta.paddingright = 2;
	_pta.bordertopstyle = _pta.borderrightstyle = _pta.borderbottomstyle = _pta.borderleftstyle = "inset";
	_pta.bordertopwidth = _pta.borderrightwidth = _pta.borderbottomwidth = _pta.borderleftwidth = 2;
	_pta.bordertopcolor = _pta.borderrightcolor = _pta.borderbottomcolor = _pta.borderleftcolor = 0xffffff;	
};

DENG.CXForms_SELECT1.prototype.setDefaultPulldownStyles = function (ctrlObj)
{
	var _pta = ctrlObj.css.dom.propertyTableAttr;
	_pta.display = "block";
	_pta.position = "absolute"
	_pta.backgroundcolor = 0xffffff;
	_pta.paddingtop = _pta.paddingbottom = _pta.paddingleft = _pta.paddingright = 2;
	_pta.bordertopstyle = _pta.borderrightstyle = _pta.borderbottomstyle = _pta.borderleftstyle = "inset";
	_pta.bordertopwidth = _pta.borderrightwidth = _pta.borderbottomwidth = _pta.borderleftwidth = 2;
	_pta.bordertopcolor = _pta.borderrightcolor = _pta.borderbottomcolor = _pta.borderleftcolor = 0xffffff;	
};

// initialize/update select UI
DENG.CXForms_SELECT1.prototype.initControl = function () {
	if (this.appearance == "minimal") {
		this.control._parent.onRelease = function () {
			this.classRef.pulldown.mc._visible = !this.classRef.pulldown.mc._visible;
			if (this.classRef.pulldown.mc._visible) {
				var point = new Object();
				point.x = this._x;
				point.y = this._y;
				this.localToGlobal(point);
				this.classRef.pulldown.mc._x = point.x;
				this.classRef.pulldown.mc._y = point.y +this._height;
			}
		};
		this.control._parent.onReleaseOutside = function () {
			if (this.classRef.pulldown.mc._visible) {
				this.classRef.pulldown.mc._visible = false;
			}
		};
	}
	this.updateControl();
};

DENG.CXForms_SELECT1.prototype.updateControl = function () {
	this.select(this.binding.instanceValue);
};

// set the new value of the node bound to this select and update UI
DENG.CXForms_SELECT1.prototype.select = function (value, label) {
	this.binding.instanceValue = value;
	this.updateInstance();
	var i, item, items = this.items;
	for (i in items) {
		item = items[i];
		if (item.valueText != value) {
			item.lo();
		} else {
			item.hi();
			if (label == undefined) {
				var label = item.labelText;
			}
		}
	}
	if (this.appearance == "minimal") {
		this.pulldown.mc._visible = false;
		this.control.text = label;
	}
};
