package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/Condition.html
	public interface ICondition
	{
		/**
		 * An unsigned integer indicating the type of Condition.
		 * 
		 * @see ConditionTypes
		 */
		function getConditionType():uint;
	}
}