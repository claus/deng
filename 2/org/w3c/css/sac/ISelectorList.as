package org.w3c.css.sac
{
	/**
	 * The SelectorList interface provides the abstraction of an ordered collection of selectors, without defining or constraining how this collection is implemented.
	 */
	public interface ISelectorList
	{
		/**
		 * Returns the length of this selector list
		 */
		function getLength():uint;

		/**
		 * Returns the selector at the specified index, or null if this is not a valid index.
		 */
		function item( index:uint ):ISelector;
	}
}