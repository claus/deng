package org.w3c.dom
{
	public interface INode
	{
		function get nodeName():String;
		function get nodeValue():String;
		function set nodeValue(value:String):void;
		function get nodeType():int;
		function get parentNode():INode;
		function get childNodes():INodeList;
		function get firstChild():INode;
		function get lastChild():INode;
		function get previousSibling():INode;
		function get nextSibling():INode;
		function get attributes():INamedNodeMap;
		function get ownerDocument():IDocument; // Modified in DOM Level 2
		function get hasAttributes():Boolean;
		
		function insertBefore(newChild:INode, refChild:INode):INode; // Modified in DOM Level 3
		function replaceChild(newChild:INode, oldChild:INode):INode; // Modified in DOM Level 3
		function removeChild(oldChild:INode):INode; // Modified in DOM Level 3
		function appendChild(newChild:INode):INode;
		function hasChildNodes():Boolean;
		function cloneNode(deep:Boolean):INode;
		function normalize():void; // Modified in DOM Level 2

		// Introduced in DOM Level 2:
		
		function get namespaceURI():String;
		function get prefix():String;
		function set prefix(value:String):void;
		function get localName():String;

		function isSupported(feature:String, version:String):Boolean; // Modified in DOM Level 2

		// Introduced in DOM Level 3:
		
		function get baseURI():String;
		function get textContent():String;
		function set textContent(value:String):void;
		
		function compareDocumentPosition(other:INode):int;
		function isSameNode(other:INode):Boolean;
		function lookupPrefix(namespaceURI:String):String;
		function isDefaultNamespace(namespaceURI:String):Boolean;
		function lookupNamespaceURI(prefix:String):String;
		function isEqualNode(other:INode):Boolean;
		function getFeature(feature:String, version:String):*;
		function setUserData(key:String, data:Object, handler:IUserDataHandler):Object;
		function getUserData(key:String):Object;

		// NodeType:
		// ------------------------------------
		// ELEMENT_NODE                   = 1;
		// ATTRIBUTE_NODE                 = 2;
		// TEXT_NODE                      = 3;
		// CDATA_SECTION_NODE             = 4;
		// ENTITY_REFERENCE_NODE          = 5;
		// ENTITY_NODE                    = 6;
		// PROCESSING_INSTRUCTION_NODE    = 7;
		// COMMENT_NODE                   = 8;
		// DOCUMENT_NODE                  = 9;
		// DOCUMENT_TYPE_NODE             = 10;
		// DOCUMENT_FRAGMENT_NODE         = 11;
		// NOTATION_NODE                  = 12;

		// DocumentPosition:
		// --------------------------------------------------
		// DOCUMENT_POSITION_DISCONNECTED            = 0x01;
		// DOCUMENT_POSITION_PRECEDING               = 0x02;
		// DOCUMENT_POSITION_FOLLOWING               = 0x04;
		// DOCUMENT_POSITION_CONTAINS                = 0x08;
		// DOCUMENT_POSITION_CONTAINED_BY            = 0x10;
		// DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 0x20;
	}
}
