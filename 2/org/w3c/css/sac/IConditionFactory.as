package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/ConditionFactory.html
	public interface IConditionFactory
	{
		/**
		 * Creates an and condition
		 * @param first the first condition
		 * @param second the second condition
		 * @returns a combinator condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_AND_CONDITION
		 */
		function createAndCondition( fist:ICondition, second:ICondition ):ICombinatorCondition;
		
		/**
		 * Creates an attribute condition
		 * @param localName the localName of the attribute
		 * @param namespaceURI the namespace URI of the attribute
		 * @param specified true if the attribute must be specified in the document.
		 * @param value the value of this attribute.
		 * @returns An attribute condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_ATTRIBUTE_CONDITION
		 */
		function createAttributeCondition( localName:String, namespaceURI:String, specified:Boolean, value:String ):IAttributeCondition;
		
		/**
		 * Creates a "begin hyphen" attribute condition
		 * @param localName the localName of the attribute
		 * @param namespaceURI the namespace URI of the attribute
		 * @param specified true if the attribute must be specified in the document.
		 * @param value the value of this attribute.
		 * @returns A "begin hyphen" attribute condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION
		 */
		function createBeginHyphenAttributeCondition( localName:String, namespaceURI:String, specified:Boolean, value:String ):IAttributeCondition;
		
		/**
		 * Creates a class condition
		 * @param namespaceURI the namespace URI of the attribute
		 * @param value the value of this attribute.
		 * @returns A class condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_CLASS_CONDITION
		 */
		function createClassCondition( namespaceURI:String, value:String ):IAttributeCondition;

		/**
		 * Creates a content condition
		 * @param data the data in the content 
		 * @returns A content condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_CONTENT_CONDITION
		 */
		function createContentCondition( data:String ):IContentCondition;

		/**
		 * Creates an id condition
		 * @param value the value of the id
		 * @returns An Id condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_ID_CONDITION
		 */
		function createIdCondition( value:String ):IAttributeCondition;

		/**
		 * Creates a lang condition
		 * @param lang the value of the language
		 * @returns A lang condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_LANG_CONDITION
		 */
		function createLangCondition( lang:String ):ILangCondition;

		/**
		 * Creates a negative condition
		 * @param condition the condition
		 * @returns A negative condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_NEGATIVE_CONDITION
		 */
		function createNegativeCondition( condition:ICondition ):INegativeCondition;

		/**
		 * Creates a "one of" attribute condition
		 * @param localName the localName of the attribute
		 * @param namespaceURI the namespace URI of the attribute
		 * @param specified true if the attribute must be specified in the document.
		 * @param value the value of this attribute.
		 * @returns A "one of" attribute condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_ONE_OF_ATTRIBUTE_CONDITION
		 */
		function createOneOfAttributeCondition( localName:String, namespaceURI:String, specified:Boolean, value:String ):IAttributeCondition;
		
		/**
		 * Creates a "only one" child condition
		 * @returns A "only one" child condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_ONLY_CHILD_CONDITION
		 */
		function createOnlyChildCondition():ICondition;

		/**
		 * Creates a "only one" type condition
		 * @returns A "only one" type condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_ONLY_TYPE_CONDITION
		 */
		function createOnlyTypeCondition():ICondition;

		/**
		 * Creates an or condition
		 * @param first the first condition
		 * @param second the second condition
		 * @returns a combinator condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_OR_CONDITION
		 */
		function createOrCondition( first:ICondition, second:ICondition ):ICombinatorCondition;

		/**
		 * Creates a positional condition
		 * @param position the position of the node in the list.
		 * @param typeNode true if the list should contain only nodes of the same type (element, text node, ...).
		 * @param type true true if the list should contain only nodes of the same node (for element, same localName and same namespaceURI).
		 * @returns A positional condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_POSITIONAL_CONDITION
		 */
		function createPositionalCondition( position:int, typeNode:Boolean, type:Boolean ):IPositionalCondition;

		/**
		 * Creates a pseudo class condition
		 * @param namespaceURI the namespace URI of the attribute
		 * @param value the value of this attribute.
		 * @returns A pseudo class condition
		 * @throws ICSSException if this selector is not supported.
		 * @see ConditionTypes#SAC_PSEUDO_CLASS_CONDITION
		 */
		function createPseudoClassCondition( namespaceURI:String, value:String ):IAttributeCondition;
	}
}