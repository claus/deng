package org.w3c.css.dom
{

	/**
	 * The CSSRuleList interface provides the abstraction of an ordered collection of CSS rules.
	 * <p>The items in the CSSRuleList are accessible via an integral index, starting from 0.</p>
	 */
	public interface ICSSRuleList
	{
 
		/**
		 * The number of CSSRules in the list.
		 * The range of valid child rule indices is 0 to length-1 inclusive.
		 */
		function get length():uint;

		/**
		 * Used to retrieve a CSS rule by ordinal index.
		 * The order in this collection represents the order of the rules in the CSS style sheet. If index is greater than or equal to the number of rules in the list, this returns null.
		 * @param index Index into the collection
		 * @returns The style rule at the index position in the CSSRuleList, or null if that is not a valid index.
		 */
		function item(index:uint):ICSSRule;

	}

}