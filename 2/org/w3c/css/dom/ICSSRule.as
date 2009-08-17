package org.w3c.css.dom
{

	/**
	 * The ICSSRule interface is the abstract base interface for any type of CSS statement.
	 * This includes both rule sets and at-rules. An implementation is expected to preserve all rules specified in a CSS style sheet, even if the rule is not recognized by the parser. Unrecognized rules are represented using the CSSUnknownRule interface.
	 * @see RuleTypes
	 */
	public interface ICSSRule
	{

		/**
		 * The type of the rule.
		 * The expectation is that binding-specific casting methods can be used to cast down from an instance of the CSSRule interface to the specific derived interface implied by the type.
		 * @see RuleTypes
		 */
		function get type():uint;

		/**
		 * The parsable textual representation of the rule.
		 * This reflects the current state of the rule and not its initial value.
		 */
		function get cssText():String;

		/**
		 * @throws DOMException
		 * SYNTAX_ERR: Raised if the specified CSS string value has a syntax error and is unparsable.
		 * INVALID_MODIFICATION_ERR: Raised if the specified CSS string value represents a different type of rule than the current one.
		 * HIERARCHY_REQUEST_ERR: Raised if the rule cannot be inserted at this point in the style sheet.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if the rule is readonly.
		 */
		function set cssText( value:String ):void;

		/**
		 * The style sheet that contains this rule.
		 */
		function get parentStyleSheet():ICSSStyleSheet;

		/**
		 * If this rule is contained inside another rule (e.g. a style rule inside a media block), this is the containing rule. If this rule is not nested inside any other rules, this returns null.
 		 */
		function get parentRule():ICSSRule;

	}


}