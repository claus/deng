package org.w3c.css.sac
{
	public class ConditionTypes
	{
		/**
		 * This condition checks exactly two conditions.
		 * 
		 * @example <listing>
		 * .part1:lang(fr)</listing>
		 * 
		 * @see ICombinatorCondition
		 */
		public static const SAC_AND_CONDITION:uint = 0;
		
		/**
		 * This condition checks an attribute.
		 * 
		 * @example <listing>
		 * [simple]
		 * [restart="never"]</listing>
		 * 
		 * @see IAttributeCondition
		 */
		public static const SAC_ATTRIBUTE_CONDITION:uint = 1;
		
		/**
		 * This condition checks if the value is in a hypen-separated list of values in a specified attribute.
		 * 
		 * @example <listing>
		 * [languages|="fr"]</listing>
		 * 
		 * @see IAttributeCondition
		 */
		public static const SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION:uint = 2;
		
		/**
		 * This condition checks for a specified class.
		 * 
		 * @example <listing>
		 * .example</listing>
		 * 
		 * @see IAttributeCondition
		 */
		public static const SAC_CLASS_CONDITION:uint = 3;
		
		/**
		 * This condition checks the content of a node.
		 * 
		 * @see IContentCondition
		 */
		public static const SAC_CONTENT_CONDITION:uint = 4;
		
		/**
		 * This condition checks an id attribute.
		 * 
		 * @example <listing>
		 * #myId</listing>
		 * 
		 * @see IAttributeCondition
		 */
		public static const SAC_ID_CONDITION:uint = 5;
		
		/**
		 * This condition checks the language of the node.
		 * 
		 * @example <listing>
		 * :lang(fr)</listing>
		 * 
		 * @see ILangCondition
		 */
		public static const SAC_LANG_CONDITION:uint = 6;
		
		/**
		 * This condition checks that a condition can't be applied to a node.
		 * 
		 * @see INegativeCondition
		 */
		public static const SAC_NEGATIVE_CONDITION:uint = 7;
		
		/**
		 * This condition checks for a value in the space-separated values of a specified attribute.
		 * 
		 * @example <listing>
		 * [values~="10"]</listing>
		 * 
		 * @see IAttributeCondition
		 */
		public static const SAC_ONE_OF_ATTRIBUTE_CONDITION:uint = 8;
		
		/**
		 * This condition checks if a node is the only one in the node list.
		 */
		public static const SAC_ONLY_CHILD_CONDITION:uint = 9;
		
		/**
		 * This condition checks if a node is the only one of his type.
		 */
		public static const SAC_ONLY_TYPE_CONDITION:uint = 10;
		
		/**
		 * This condition checks one of two conditions.
		 * 
		 * @see ICombinatorCondition
		 */
		public static const SAC_OR_CONDITION:uint = 11;
		
		/**
		 * This condition checks a specified position.
		 * 
		 * @example <listing>
		 * :first-child</listing>
		 * 
		 * @see IPositionalCondition
		 */
		public static const SAC_POSITIONAL_CONDITION:uint = 12;
		
		/**
		 * This condition checks for the link pseudo class.
		 * 
		 * @example <listing>
		 * :link
		 * :visited
		 * :hover</listing>
		 * 
		 * @see IAttributeCondition
		 */
		public static const SAC_PSEUDO_CLASS_CONDITION:uint = 13;
	}
}