package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/DescendantSelector.html
	/**
	 * @see Selector#SAC_DESCENDANT_SELECTOR
	 * @see Selector#SAC_CHILD_SELECTOR
	 */
	public interface IDescendantSelector extends ISelector
	{
		/**
		 * Returns the parent selector
		 */
		function getAncestorSelector():ISelector;

		function getSimpleSelector():ISimpleSelector;
	}
}