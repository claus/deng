package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/ContentCondition.html
	/**
	 * @see ICondition#SAC_CONTENT_CONDITION
	 * @copy ICondition#SAC_CONTENT_CONDITION
	 */
	public interface IContentCondition extends ICondition
	{
		/**
		 * Returns the content
		 */
		function getData():String;
	}
}