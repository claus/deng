package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/NegativeCondition.html
	/**
	 * @see ConditionTypes#SAC_NEGATIVE_CONDITION
	 * @copy ConditionTypes#SAC_NEGATIVE_CONDITION
	 */
	public interface INegativeCondition extends ICondition
	{
		/**
		 * Returns the condition.
		 */
		function getCondition():ICondition;
	}
}