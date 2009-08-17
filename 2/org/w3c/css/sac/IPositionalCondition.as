package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/PositionalCondition.html
	/**
	 * @see ConditionTypes#SAC_POSITIONAL_CONDITION
	 * @copy ConditionTypes#SAC_POSITIONAL_CONDITION
	 */
	public interface IPositionalCondition extends ICondition
	{
		/**
		 * Returns the position in the tree.
		 * <p>A negative value means from the end of the child node list.</p>
		 * <p>The child node list begins at 0.</p>
		 */
		function getPosition():int;

		/**
		 * <code>true</code> if the node should have the same node type (for element, same namespaceURI and same localName).
		 */
		function getType():Boolean;

		/**
		 * <code>true</code> if the child node list only shows nodes of the same type of the selector (only elements, only PIS, ...)
		 */
		function getTypeNode():Boolean;
	}
}