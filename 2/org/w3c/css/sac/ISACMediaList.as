package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/SACMediaList.html
	public interface ISACMediaList
	{
		/**
		 * Returns the length of this media list
		 */
		function getLength():uint;

		/**
		 * Returns the medium at the specified index, or null if this is not a valid index.
		 */
		function item( index:uint ):String;
	}
}