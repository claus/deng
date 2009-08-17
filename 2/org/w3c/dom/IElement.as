package org.w3c.dom
{
	public interface IElement
	{
		function get tagName():String;
		
		function getAttribute(name:String):String;
		function setAttribute(name:String, value:String):void;
		function removeAttribute(name:String):void;
		function getAttributeNode(name:String):IAttr;
		function setAttributeNode(newAttr:IAttr, name:String):IAttr;
		function removeAttributeNode(oldAttr:IAttr):IAttr;
		function getElementsByTagName(name:String):INodeList;

		// Introduced in DOM Level 2:
		
		function getAttributeNS(namespaceURI:String, localName:String):String;
		function setAttributeNS(namespaceURI:String, qualifiedName:String, value:String):void;
		function removeAttributeNS(namespaceURI:String, localName:String):void;
		function getAttributeNodeNS(namespaceURI:String, localName:String):IAttr;
		function setAttributeNodeNS(newAttr:IAttr):void;
		function getElementsByTagNameNS(namespaceURI:String, localName:String):INodeList;
		function hasAttribute(name:String):Boolean;
		function hasAttributeNS(namespaceURI:String, localName:String):Boolean;
		
		// Introduced in DOM Level 3:
		
		function get schemaTypeInfo():ITypeInfo;

		function setIdAttribute(name:String, isId:Boolean):void;
		function setIdAttributeNS(namespaceURI:String, localName:String, isId:Boolean):void;
		function setIdAttributeNode(idAttr:IAttr, isId:Boolean):void;
	}
}
