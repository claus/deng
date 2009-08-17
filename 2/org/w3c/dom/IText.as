package org.w3c.dom
{
	public interface IText extends ICharacterData
	{
		function splitText(offset:int):IText;
		
		// Introduced in DOM Level 3:
		
		function get wholeText():String;

		function isWhitespaceInElementContent():Boolean;
		function replaceWholeText(content:String):IText;
	}
}
