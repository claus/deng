package org.w3c.css.dom
{

	/**
	 * The CSSStyleRule interface represents a single rule set in a CSS style sheet.
	 */
	public interface ICSSStyleRule extends ICSSRule
	{

		/**
		 * The textual representation of the selector for the rule set.
		 * The implementation may have stripped out insignificant whitespace while parsing the selector.
		 */
		function get selectorText():String;

		/**
		 * @throws IDOMException
		 * SYNTAX_ERR: Raised if the specified CSS string value has a syntax error and is unparsable.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this rule is readonly.
		 */
		function set selectorText(value:String):void;

		/**
		 * The declaration-block of this rule set.
		 */
		function get style():ICSSStyleDeclaration;

	}

}