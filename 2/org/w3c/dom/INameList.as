package org.w3c.dom
{
	public interface INameList
	{
		function get length():int;

		function getName(index:int):String;
		function getNamespaceURI(index:int):String;
	}
}
