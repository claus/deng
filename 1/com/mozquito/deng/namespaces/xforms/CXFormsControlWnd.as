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
//   class DENG.CXFormsControlWnd
// ===========================================================================================

DENG.CXFormsControlWnd = function()
{
	super();
	// is a binding mandatory for this XForms control? default: true
	// may be overridden (trigger, group, etc. do not require a binding)
	this.bindingRequired = true;
};

DENG.CXFormsControlWnd.extend(DENG.CXFormsWnd);

DENG.CXFormsControlWnd.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
	
	this.css.dom.propertyTableAttr.display = "block";
	
	// parse css in the style attribute
	// if the style attribute is set (inline styles)
	var inlineStyle = this.node.attributes.style;
	if(this.check(inlineStyle)) {
		// add inline styles to queue
		this.xmlDomRef.cssParseQueue.push({ type: 2, css: inlineStyle, obj: this });
	}

	this.bound = false;
};

DENG.CXFormsControlWnd.prototype.setDefaultLabelStyles = function (label) {
	label.css.dom.propertyTableAttr.fontweight = "bold";
};

DENG.CXFormsControlWnd.prototype.create = function()
{

	this.setDefaultLabelStyles(this.label);
	//this.xmlDomRef.infoMsg("##########" +this.node.nsNodeName.toUpperCase() +"##########");
	//this.xmlDomRef.infoMsg(this.node);
	// try to make sense out of this control by examining its binding
	if (this.bound = this.createBinding()) {
		// create, initialize and add to childNodes our control...
		this.createControl();
		// ...before this element and all descendants get created
		super.create();
	} else {
	    super.create();
	}
};

DENG.CXFormsControlWnd.prototype.size = function()
{
	super.size();
};

DENG.CXFormsControlWnd.prototype.position = function()
{
	return super.position();
};

DENG.CXFormsControlWnd.prototype.paint = function()
{
	super.paint();
};

DENG.CXFormsControlWnd.prototype.createControl = function ()
{
	// add the wrapper for the fake node to UI DOM
	var _c = new DENG.CElemPseudoValue();
	_c.regChildnode(this, this.node);
	// default styles
	this.setDefaultControlStyles(_c);
};

// updates the display value of this control, may be overridden by form controls
DENG.CXFormsControlWnd.prototype.updateControl = function ()
{
    if (this.binding.boundNode) {
		this.control.text = this.binding.instanceValue;
	} else {
		this.control.text = "";		
	}
};

// update the instance node bound to this control and
// update the controls bound to the same instance node
// NOTE: new value is already set/calculated when this is called
DENG.CXFormsControlWnd.prototype.updateInstance = function ()
{
	var bn = this.binding.boundNode; 
	var value = this.binding.instanceValue;
	if (bn) {
		with (bn) {
			if (nodeType == 1) {
				if (firstChild) {
					firstChild.nodeValue = value;
				} else {
					appendChild(root().pop().createTextNode(value));
				}
				updateControls(this);
			} else if (nodeType == 5) {
			    parentNode.attributes[nodeName] = value;
				parentNode.updateControls(this);
			} else if (nodeType == 3) {
				bn.nodeValue = value;
				updateControls(this);
			} 
		}
	}
};

// CXFormsControlWnd.createBinding()
// determines: model and binding from the bind reference OR the binding attributes
// returns: true if this form control is bound, false otherwise
DENG.CXFormsControlWnd.prototype.createBinding = function () {
	var attrs = this.node.attributes;
	var bindRef = attrs.bind;
	if (this.check(bindRef)) {
		// get the model from the bind
		if (this.bind = this.xmlDomRef.getBind(bindRef)) {
			// OK: got bind and model
			this.model = this.bind.model;
			this.binding = this.bind;
		} else {
			// KO: error
			this.xmlDomRef.errorMsg("wrong bind reference: " +bindRef);
			return false;
		}
	} else {
		if (this.getModel(attrs.model) && this.checkBinding()) {
    		this.binding = this;
		} else {
			return false;
		}
	}

	//trace("OK: this form control has a model: " +this.binding.model.node)
	//trace("OK: this form control has a binding: " +this.binding.xpath)
	return this.updateBinding();
};

// determine bound nodes by evaluating our XPath binding expression
DENG.CXFormsControlWnd.prototype.updateBinding = function () {
	return this.binding.doBind();
};

DENG.CXFormsControlWnd.prototype.checkBinding = function () 
{
    with (this) {
		var attrs = node.attributes;
		if (!check(this.xpath = attrs.ref)) {
			if (!check(this.xpath = attrs.nodeset)) {
				if (bindingRequired) {
					xmlDomRef.errorMsg("this control is missing a binding: " +node);
				} 
				return false;
			}
		}
		return true;
	}
};

// boolean CXFormsWnd.getModel([String model_ID])
// expects: nothing, you may provide the model ID
// determines: the model from parameter OR model attribute OR bound ancestor's model attribute OR default model
// returns: true if a model is found for this XForms element, false otherwise
DENG.CXFormsControlWnd.prototype.getModel = function (modelRef) {
	with (this) {
		if (modelRef == undefined) {
			var modelRef = node.attributes.model;
		}
		if (check(modelRef)) {
			// model attribute found
			this.model = xmlDomRef.getModel(modelRef);
			if (!model) {
				// KO: error
				xmlDomRef.errorMsg("wrong model reference: " +modelRef);
				return false;
			}
		} else {
			// inherit or default
			var n = this;
			do {
				n = n.parentNode;
				this.model = n.model;
				if (model != undefined) break;
			} while (n != n.rootNode);
			if (model == undefined) {
				this.model = xmlDomRef.defaultModel;
			}
		}
		model.controls.push(this);
		return true;
	}
};
// returns the XPath binding context for this control
DENG.CXFormsControlWnd.prototype.getParentContext = function () 
{
	var pb = this.parentBoundElement = this.getParentBoundElement();	
	this.parentContext = (pb == null) ? this.model.getContext() : pb.getContext();
	return this.parentContext;
};

// returns the closest ancestor that has a binding in the same model
DENG.CXFormsControlWnd.prototype.getParentBoundElement = function () 
{
	this.getParentBoundElement = function () {return this.parentBoundElement;}
	var n = this;
	do {
		n = n.parentNode;
		if (n.bound && n.model == this.model) return n;
	} while (n != n.rootNode);
	return null;
};

// returns XPath binding context for our descendants
DENG.CXFormsControlWnd.prototype.getContext = function () {
	return this.binding.context;
};

