package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/CharacterDataSelector.html
	/**
	 * @see Selector#SAC_TEXT_NODE_SELECTOR
	 * @see Selector#SAC_CDATA_SECTION_NODE_SELECTOR
	 * @see Selector#SAC_COMMENT_NODE_SELECTOR
	 */
	public interface ICharacterDataSelector extends ISimpleSelector
	{
		/**
		 * Returns the character data.
		 */
		function getData():String;
	}
}