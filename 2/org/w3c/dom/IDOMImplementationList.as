package org.w3c.dom
{
	public interface IDOMImplementationList
	{
		function get length():int;
		
		function item(index:int):IDOMImplementation;
	}
}
