package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/CSSParseException.html
	/**
	 * Encapsulate a CSS parse error or warning.
	 * <p>This exception will include information for locating the error in the original CSS document. Note that although the application will receive a CSSParseException as the argument to the handlers in the ErrorHandler interface, the application is not actually required to throw the exception; instead, it can simply read the information in it and take a different action.</p>
	 * <p>Since this exception is a subclass of CSSException, it inherits the ability to wrap another exception.</p>
	 */
	public interface ICSSParseException extends ICSSException
	{

		/**
		 * Create a new CSSParseException.
		 * 
		 * @param message The error or warning message.
		 * @param locator The locator object for the error or warning.
		 * @param uri The URI of the document that generated the error or warning.
		 * @param lineNumber The line number of the end of the text that caused the error or warning.
		 * @param columnNumber The column number of the end of the text that cause the error or warning.
		 * @param e Another exception to embed in this one.
		 * @see ILocator
		 * @see Parser#setLocale
		 */
		function ICSSParseException( message:String, locator:ILocator=null, uri:String=null, lineNumber:uint=0, columnNumber:uint=0, e:Error=null):void;
		//function ICSSParseException( message:String, locator:ILocator ):void;
		//function ICSSParseException( message:String, locator:ILocator, e:Error ):void;
		//function ICSSParseException( message:String, uri:String,  lineNumber:uint, columnNumber:uint ):void;
		//function ICSSParseException( message:String, uri:String,  lineNumber:uint, columnNumber:uint, e:Error ):void;
		
		/**
		 * The column number of the end of the text where the exception occurred.
		 * <p>The first column in a line is position 1.</p>
		 * @returns An integer representing the column number, or -1 if none is available.
		 * @see ILocator#getColumnNumber
		 */
		function getColumnNumber():uint;

		/**
		 * The line number of the end of the text where the exception occurred.
		 * @returns An integer representing the line number, or -1 if none is available.
		 * @see ILocator#getLineNumber
		 */
		function getLineNumber():uint;

		/**
		 * Get the URI of the document where the exception occurred.
		 * <p>The URI will be resolved fully.</p>
		 * @returns A string containing the URI, or null if none is available.
		 * @see ILocator#getURI
		 */
		function getURI():String;
	}
}