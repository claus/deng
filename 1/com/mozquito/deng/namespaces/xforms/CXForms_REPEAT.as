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
//   class DENG.CXForms_REPEAT
// ===========================================================================================

DENG.CXForms_REPEAT = function()
{
	super();
}

DENG.CXForms_REPEAT.extend(DENG.CXFormsControlWnd);

// this is added to all repeats with number="1"
// this implementation now assumes number="1" 
// therefore it is currently added to all repeats
// NOTE: the fancy prefixes are supposed to be an optimization :-)
DENG.CXForms_REPEAT.templateMinimal = 
							 "<table class='_xforms_repeat' xmlns='http://www.w3.org/1999/xhtml' xmlns:dengxf='http://www.w3.org/2002/xforms/cr' xmlns:dengev='http://www.w3.org/2001/xml-events'>"
							+	"<tr>"
							+		"<td class='_xforms_repeat_td_prev'>"
							+			"<dengxf:trigger>"
							+				"<dengxf:label>&lt;</dengxf:label>"
							+				"<dengxf:setindex repeat='$rI' index='if(index(\"$rI\")=1,1,index(\"$rI\")-1)' dengev:event='click'/>"
							+			"</dengxf:trigger>"
							+		"</td><td class='_xforms_repeat_td_index'>"
							+			"<dengxf:output value='index(\"$rI\")' />"
							+		"</td><td class='_xforms_repeat_td_of'><span>of</span></td><td class='_xforms_repeat_td_total'>"
							+			"<dengxf:output value='last()' />"
							+		"</td><td class='_xforms_repeat_td_next'>"
							+			"<dengxf:trigger>"
							+				"<dengxf:label>&gt;</dengxf:label>"
							+				"<dengxf:setindex repeat='$rI' index='if(index(\"$rI\")=last(),last(),index(\"$rI\")+1)' dengev:event='click'/>"
							+			"</dengxf:trigger>"
							+		"</td>"
							+	"</tr>"
							+"</table>";

DENG.CXForms_REPEAT.templateFull="<dengxf:group xmlns:dengxf='http://www.w3.org/2002/xforms/cr' xmlns:dengev='http://www.w3.org/2001/xml-events' xmlns='http://www.w3.org/1999/xhtml'>"
							+     "<table cellpadding='0' cellspacing='0'>"
							+	  "<tr><td width='33%'>"
							+     "<dengxf:trigger>"
							+         "<dengxf:label>Previous</dengxf:label>"
							+         "<dengxf:setindex repeat='$rI' index='if(index(\"$rI\")=1,1,index(\"$rI\")-1)' dengev:event='click'/>"
							+     "</dengxf:trigger></td>"
							+	  "<td width='34%'>"
							+	  "<dengxf:output value='last()'><dengxf:label>Total items</dengxf:label></dengxf:output>"
							+     "<dengxf:output value='index(\"$rI\")'><dengxf:label>Current item</dengxf:label></dengxf:output></td>"
							+	  "<td width='33%'>"
							+     "<dengxf:trigger>"
							+         "<dengxf:label>Next</dengxf:label>"
							+         "<dengxf:setindex repeat='$rI' index='if(index(\"$rI\")=last(),last(),index(\"$rI\")+1)' dengev:event='click'/>"
							+     "</dengxf:trigger></td></tr></table>"
							+"</dengxf:group>";


DENG.CXForms_REPEAT.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
		
	var attrs = this.node.attributes;
	if (this.check(this.id = attrs.id) && (this.check(this.xpath = attrs.nodeset) || this.check(attrs.bind))) {
		// setup default index and user-defined startindex
		this.index = 1;
		var startindex = attrs.startindex;
		this.startindex = (this.check(startindex)) ? parseInt(startindex) : 1;
		
		// build repeat ui template
		this.template = ((attrs.appearance == "full") ? DENG.CXForms_REPEAT.templateFull : DENG.CXForms_REPEAT.templateMinimal).split("$rI").join(this.id);
		// add me to this doc's repeats
		this.xmlDomRef.addRepeat(this.id, this);
	} else {
		this.checkBinding = null;
		this.xmlDomRef.errorMsg("couldn't make sense out of this repeat: " +this.node);
	}
};
DENG.CXForms_REPEAT.prototype.create = function()
{
	super.create();
};
DENG.CXForms_REPEAT.prototype.size = function()
{
	super.size();
	if (this.$initControlDone == undefined) {
		this.$initControlDone = true;
		if (this.startindex != this.index) {
			this.setIndex(this.startindex);
		}
	}
};
DENG.CXForms_REPEAT.prototype.checkBinding = function ()
{
    with (this) {
		var attrs = node.attributes;
		if (!check(this.xpath = attrs.nodeset)) {
			if (bindingRequired) {
				xmlDomRef.errorMsg("this control is missing a binding: " +node);
                                return false;
			}
			return true;
		}
		return true;
	}
};

DENG.CXForms_REPEAT.prototype.createControl = function()
{
	this.xmlDomRef.createNodeTree(this.template).createElementWrapper(this).regChildnode(this, this.panelTree, 0);
};

// recursively update repeat item UI
DENG.CXForms_REPEAT.prototype.updateItem = function (n) {
	//trace("updating: " +n.node.nodeName +" --> " +n.node)
	// TODO: refactor to avoid this check on all controls
	// if the control is a repeat, reset its index
	if (n instanceof DENG.CXForms_REPEAT) n.index = 1;
	// update control binding
	n.updateBinding();
	// update control UI
	n.updateControl();
	// update children
	if (n.childNodes.length) this.updateItem(n.childNodes[0]);
	//  update siblings
	if (n.nextSibling) this.updateItem(n.nextSibling);
	
};

// override superclass to determine the current repeat context
DENG.CXForms_REPEAT.prototype.updateBinding = function () {
	var ret = super.updateBinding();
	var nodes = this.binding.boundNodes;
	this.repeatcontext = {contextNode: nodes[this.index-1], nodeSet: nodes};
	return ret;
};

// update the repeat template with the values 
// from the repeat context (item at current index)
DENG.CXForms_REPEAT.prototype.updateControl = function () {
	this.setIndex(this.index);
};

// set the new repeat index, recalculate context and update UI
DENG.CXForms_REPEAT.prototype.setIndex = function (newI, forceUpdate) {
	with (this) {
		//xmlDomRef.infoMsg("setIndex invoked on this repeat: " +node);
		// "normalize" new index value
		var items = repeatcontext.nodeSet;
		newI = checkIndex(newI, items.length);
		// do not update context and UI if the index is not changed
		if (index == newI && forceUpdate == undefined) return;
		// set new index
		this.index = newI;
		// determine new context node
		repeatcontext.contextNode = items[--newI];
		// update UI
		updateItem(childNodes[0]);
	}
};

DENG.CXForms_REPEAT.prototype.checkIndex = function (i, max) 
{
	if (isNaN(i) || i < 1) {
		return 1;
	} else if (i > max) {
		return max;
	} else return i;
};

// returns the context of the current item in the repeat
DENG.CXForms_REPEAT.prototype.getContext = function () {
	//this.xmlDomRef.infoMsg("getContext invoked on this repeat: " +this.node);
	return this.repeatcontext;
};

