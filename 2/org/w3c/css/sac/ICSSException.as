package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/CSSException.html
	/**
	 * @see CSSExceptionTypes
	 */
	public interface ICSSException
	{
		
		//protected code:uint;
		//protected e:Error;
		//protected s:String;
		//protected S_SAC_NOT_SUPPORTED_ERR:String;
		//protected S_SAC_SYNTAX_ERR:String;
		//protected S_SAC_UNSPECIFIED_ERR:String;
		
		/**
		 * Creates a new CSSException
		 * @param e embeded exception
		 * @param code specific code
		 * @param s specified message
		 */
		function ICSSException( e:Error=null, code:uint=0, s:String=null):void;
		//function ICSSException( e:Error ):void;
		//function ICSSException( code:uint ):void;
		//function ICSSException( code:uint, s:String, e:Error ):void;
		//function ICSSException( s:String ):void;

		/**
		 * Returns the error code for this exception.
		 */
		function getCode():uint;

		/**
		 * Returns the internal exception if any, null otherwise.
		 */
		function getException():Error;

		/**
		 * Returns the detail message.
		 */
		function getMessage():String;
	}
}