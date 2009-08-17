package org.w3c.dom
{
	public interface IAttr
	{
		function get name():String;
		function get specified():Boolean;
		function get value():String;
		function set value(value:String):void;
		
		// Introduced in DOM Level 2:
		
		function get ownerElement():IElement;
		function get schemaTypeInfo():ITypeInfo;
		
		// Introduced in DOM Level 3:
		
		function isId():Boolean;
	}
}
