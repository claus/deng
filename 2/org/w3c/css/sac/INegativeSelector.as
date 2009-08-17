package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/NegativeSelector.html
	/**
	 * @see SelectorTypes#SAC_NEGATIVE_SELECTOR
	 * @copy SelectorTypes#SAC_NEGATIVE_SELECTOR
	 */
	public interface INegativeSelector extends ISimpleSelector
	{
		/**
		 * Returns the simple selector.
		 */
		function getSimpleSelector():ISimpleSelector;
	}
}