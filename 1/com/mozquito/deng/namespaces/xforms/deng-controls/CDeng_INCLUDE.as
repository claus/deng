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
//   class DENG.CDeng_INCLUDE
// ===========================================================================================

DENG.CDeng_INCLUDE = function()
{
	super();
}

DENG.CDeng_INCLUDE.extend(DENG.CXForms_TEXTAREA);

DENG.CDeng_INCLUDE.template="<dengxf:group xmlns:dengxf='http://www.w3.org/2002/xforms/cr' xmlns:dengev='http://www.w3.org/2001/xml-events' xmlns='http://www.w3.org/1999/xhtml' xmlns:dengui='http://claus.packts.net/deng'>"
+     "<table cellpadding='0' cellspacing='0'>"
+	  "<tr><td><dengui:file><dengxf:label>File name: </dengxf:label></dengui:file></td>"
+		  "<td><dengxf:trigger><dengxf:label>Load file</dengxf:label><dengxf:load dengev:event='click'/></dengxf:trigger></td></tr>"
+     "<tr><td><dengxf:trigger>"
+     		    "<dengxf:label>Include as text</dengxf:label>"
+				"<dengui:copy ref='.' as='text' dengev:event='click'/>"
+     		  "</dengxf:trigger></td>"
+     "<td><dengxf:trigger>"
+         		"<dengxf:label>Include as XML</dengxf:label>"
+				"<dengui:copy ref='.' as='xml' dengev:event='click'/>"
+     	  "</dengxf:trigger></td></tr></table>"
+"</dengxf:group>";

DENG.CDeng_INCLUDE.prototype.initialize = function(node, parent)
{
	// initialize element wrapper
	super.initialize(node, parent);
};
DENG.CDeng_INCLUDE.prototype.create = function()
{
	this.controlpanel = this.xmlDomRef.createNodeTree(DENG.CDeng_INCLUDE.template);
	var w = this.controlpanel.createElementWrapper(this);
	w.regChildnode(this, this.controlpanel, 0);
	super.create();
	
};
DENG.CDeng_INCLUDE.prototype.size = function()
{
	super.size();
};
