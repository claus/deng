package org.w3c.dom
{
	public interface IDocument extends INode
	{
		function get doctype():IDocumentType; // Modified in DOM Level 3
		function get implementation():IDOMImplementation; // Modified in DOM Level 3
		function get documentElement():IElement; // Modified in DOM Level 3
		
		function createElement(tagName:String):IElement;
		function createDocumentFragment():IDocumentFragment;
		function createTextNode(data:String):IText;
		function createComment(data:String):IComment;
		function createCDATASection(data:String):ICDATASection;
		function createProcessingInstruction(target:String, data:String):IProcessingInstruction;
		function createAttribute(name:String):IAttr;
		function createEntityReference(name:String):IEntityReference;
		function getElementsByTagName(tagname:String):INodeList;
		
		// Introduced in DOM Level 2
		
		function importNode(importedNode:INode, deep:Boolean):INode;
		function createElementNS(namespaceURI:String, qualifiedName:String):IElement;
		function createAttributeNS(namespaceURI:String, qualifiedName:String):IAttr;
		function getElementsByTagNameNS(namespaceURI:String, localName:String):INodeList;
		function getElementById(elementId:String):IElement;
		
		// Introduced in DOM Level 3
		
		function get actualEncoding():String;
		function get xmlEncoding():String;
		function set xmlEncoding(value:String):void;
		function get xmlStandalone():Boolean;
		function set xmlStandalone(value:Boolean):void;
		function get xmlVersion():String;
		function set xmlVersion(value:String):void;
		function get strictErrorChecking():Boolean;
		function set strictErrorChecking(value:Boolean):void;
		function get documentURI():String;
		function set documentURI(value:String):void;
		function get config():IDOMConfiguration;
		
		function adoptNode(source:INode):INode;
		function normalizeDocument():void;
		function renameNode(node:INode, namespaceURI:String, qualifiedName:String):INode;
	}
}
