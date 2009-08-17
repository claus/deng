package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/ConditionalSelector.html
	/**
	 * @see Selector#SAC_CONDITIONAL_SELECTOR
	 */
	public interface IConditionalSelector extends ISimpleSelector
	{
		/**
		 * Returns the condition to be applied on the simple selector.
		 */
		function getCondition():ICondition;
		
		/**
		 * Returns the simple selector.
		 * The simple selector can't be a ConditionalSelector.
		 */
		function getSimpleSelector():ISimpleSelector;
	}
}