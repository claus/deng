package org.w3c.css.dom
{

	/**
	 * The CSSValue interface represents a simple or a complex value.
	 * A CSSValue object only occurs in a context of a CSS property.
	 */
	public interface ICSSValue {

		/**
		 * A string representation of the current value.
		 */
		function get cssText():String;

		/**
		 * @throws IDOMException
		 * SYNTAX_ERR: Raised if the specified CSS string value has a syntax error (according to the attached property) or is unparsable.
		 * INVALID_MODIFICATION_ERR: Raised if the specified CSS string value represents a different type of values than the values allowed by the CSS property.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this value is readonly.
		 */
		function set cssText(value:String):void;

		/**
		 * A code defining the type of the value as defined above.
		 */
		function get cssValueType():uint;
	}

}