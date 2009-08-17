package org.w3c.dom
{
	public interface IDOMLocator
	{
		function get lineNumber():int;
		function get columnNumber():int;
		function get offset():int;
		function get relatedNode():INode;
		function get uri():String;
	}
}
