package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/SiblingSelector.html
	/**
	 * @see SelectorTypes#SAC_DIRECT_ADJACENT_SELECTOR
	 */
	public interface ISiblingSelector extends ISelector
	{
		//public static const ANY_NODE:uint = 0;

		/**
		 * The node type to considered in the siblings list.
		 * All DOM node types are supported. In order to support the "any" node type, the code ANY_NODE is added to the DOM node types.
		 */
		function getNodeType():uint;

		/**
		 * Returns the first selector.
		 */
		function getSelector():ISelector;

		/**
		 * 
		 */
		function getSiblingSelector():ISimpleSelector;
	}
}