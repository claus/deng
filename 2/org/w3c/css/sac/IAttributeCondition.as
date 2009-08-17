package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/AttributeCondition.html
	/**
	 * @see ConditionTypes#SAC_ATTRIBUTE_CONDITION
	 * @see ConditionTypes#SAC_ONE_OF_ATTRIBUTE_CONDITION
	 * @see ConditionTypes#SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION
	 * @see ConditionTypes#SAC_ID_CONDITION
	 * @see ConditionTypes#SAC_CLASS_CONDITION
	 * @see ConditionTypes#SAC_PSEUDO_CLASS_CONDITION
	 * @copy ConditionTypes#SAC_ATTRIBUTE_CONDITION
	 */
	public interface IAttributeCondition extends ICondition
	{
		/**
		 * Returns the local part of the qualified name of this attribute.
		 * <p><code>Null</code> if :
		 * <ul>
		 * <li>this attribute condition can match any attribute.</li>
		 * <li>this attribute is a class attribute.</li>
		 * <li>this attribute is an id attribute.</li>
		 * <li>this attribute is a pseudo-class attribute.</li>
		 * </ul></p>
		 */
		function getLocalName():String;
		
		/**
		 * Returns the namespace URI of this attribute condition.
		 * <p><code>Null</code> if :
		 * <ul>
		 * <li>this attribute condition can match any namespace.</li>
		 * <li>this attribute is an id attribute.</li>
		 * </ul></p>
		 */
		function getNamespaceURI():String;
		
		/**
		 * Returns <code>true</code> if the attribute must have an explicit value in the original document, <code>false</code> otherwise.
		 */
		function getSpecified():Boolean;
		
		/**
		 * Returns the value of the attribute.
		 * If this attribute is a class or a pseudo class attribute, you'll get the class name (or psedo class name) without the '.' or ':'.
		 */
		function getValue():String;
	}
}