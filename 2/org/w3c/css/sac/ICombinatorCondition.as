package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/CombinatorCondition.html
	/**
	 * @see Condition#SAC_AND_CONDITION
	 * @see Condition#SAC_OR_CONDITION
	 */
	public interface ICombinatorCondition extends ICondition
	{
		/**
		 * Returns the first condition.
		 */
		function getFirstCondition():ICondition;
		
		/**
		 * Returns the second condition.
		 */
		function getSecondCondition():ICondition;
	}
}