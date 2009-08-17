package org.w3c.dom
{
	public interface IEntity
	{
		function get publicId():String;
		function get systemId():String;
		function get notationName():String;
		
		// Introduced in DOM Level 3:
		
		function get actualEncoding():String;
		function get xmlEncoding():String;
		function set xmlEncoding(value:String):void;
		function get xmlVersion():String;
		function set xmlVersion(value:String):void;
	}
}
