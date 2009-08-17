package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/LangCondition.html
	/**
	 * @see ConditionTypes#SAC_LANG_CONDITION
	 * @copy ConditionTypes#SAC_LANG_CONDITION
	 */
	public interface ILangCondition extends ICondition
	{
		/**
		 * Returns the language
		 */
		function getLang():String;
	}
}