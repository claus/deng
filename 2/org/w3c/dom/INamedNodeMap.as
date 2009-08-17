package org.w3c.dom
{
	public interface INamedNodeMap
	{
		function get length():int;

		function getNamedItem(name:String):INode;
		function setNamedItem(arg:INode):INode;
		function removeNamedItem(name:String):INode;
		function item(index:int):INode;
		
		// Introduced in DOM Level 2:
		
		function getNamedItemNS(namespaceURI:String, localName:String):INode;
		function setNamedItemNS(arg:INode):INode;
		function removeNamedItemNS(namespaceURI:String, localName:String):INode;
	}
}
