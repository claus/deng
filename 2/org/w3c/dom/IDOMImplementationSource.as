package org.w3c.dom
{
	public interface IDOMImplementationSource
	{
		function getDOMImplementation(features:String):IDOMImplementation;
		function getDOMImplementations(features:String):IDOMImplementationList;
	}
}
