package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/Selector.html
	/**
	 * This interface defines a selector.
	 * @see SelectorTypes
	 */
	public interface ISelector
	{
		/**
		 * An unsigned integer indicating the type of Selector
		 * @see SelectorTypes
		 */
		function getSelectorType():uint;
	}
}