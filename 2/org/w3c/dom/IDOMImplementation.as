package org.w3c.dom
{
	public interface IDOMImplementation
	{
		function hasFeature(feature:String, version:String):Boolean;
		
		// Introduced in DOM Level 2:
		
		function createDocumentType(qualifiedName:String, publicId:String, systemId:String):IDocumentType;
		function createDocument(namespaceURI:String, qualifiedName:String, doctype:IDocumentType):IDocument;

		// Introduced in DOM Level 3:
		
		function getFeature(feature:String, version:String):Object;
	}
}
