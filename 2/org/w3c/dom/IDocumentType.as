package org.w3c.dom
{
	public interface IDocumentType extends INode
	{
		function get name():String;
		function get entities():INamedNodeMap;
		function get notations():INamedNodeMap;

		// Introduced in DOM Level 2:
		
		function get publicId():String;
		function get systemId():String;
		function get internalSubset():String;
	}
}
