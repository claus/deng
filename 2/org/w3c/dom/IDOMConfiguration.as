package org.w3c.dom
{
	public interface IDOMConfiguration
	{
		function setParameter(name:String, value:Object):void;
		function getParameter(name:String):Object;
		function canSetParameter(name:String, value:Object):Boolean;
		
		// Parameters:
		// ---------------------
		// canonical-form
		// cdata-sections
		// check-character-normalization
		// comments
		// datatype-normalization
		// entities
		// error-handler
		// infoset
		// namespaces
		// namespace-declarations
		// normalize-characters
		// schema-location
		// schema-type
		// split-cdata-sections
		// validate
		// validate-if-schema
		// well-formed
		// whitespace-in-element-content
	}
}
