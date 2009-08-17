package org.w3c.dom
{
	public interface IDOMError
	{
		function get severity():int;
		function get message():String;
		function get relatedException():Object;
		function get relatedData():Object;
		function get location():IDOMLocator;
		
		// ErrorSeverity
		// ---------------------------
		// SEVERITY_WARNING      = 0;
		// SEVERITY_ERROR        = 1;
		// SEVERITY_FATAL_ERROR  = 2;		
	}
}
