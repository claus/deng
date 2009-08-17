package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/SelectorFactory.html
	/**
	 * @see SelectorTypes
	 * @see ISelector
	 */
	public interface ISelectorFactory
	{
		/**
		 * Creates an any node selector.
		 * @throws ICSSException If this selector is not supported.
		 * @returns the any node selector.
		 * @see SelectorTypes#SAC_ANY_NODE_SELECTOR
		 */
		function createAnyNodeSelector():ISimpleSelector;

		/**
		 * Creates a cdata section node selector.
		 * @param data the data
		 * @throws ICSSException If this selector is not supported.
		 * @returns the cdata section node selector
		 * @see SelectorTypes#SAC_CDATA_SECTION_NODE_SELECTOR
		 */
		function createCDataSectionSelector( data:String ):ICharacterDataSelector;

		/**
		 * Creates a child selector.
		 * @param parent the parent selector
		 * @param child the child selector
		 * @throws ICSSException If this selector is not supported.
		 * @returns the combinator selector.
		 * @see SelectorTypes#SAC_CHILD_SELECTOR
		 */
		function createChildSelector( parent:ISelector, child:ISimpleSelector ):IDescendantSelector;

		/**
		 * Creates a comment node selector.
		 * @param data the data
		 * @throws ICSSException If this selector is not supported.
		 * @returns the comment node selector
		 * @see SelectorTypes#SAC_COMMENT_NODE_SELECTOR
		 */
		function createCommentSelector( data:String ):ICharacterDataSelector;

		/**
		 * Creates a conditional selector.
		 * @param selector a selector.
		 * @param condition a condition
		 * @throws ICSSException If this selector is not supported.
		 * @returns the conditional selector.
		 * @see SelectorTypes#SAC_CONDITIONAL_SELECTOR
		 */
		function createConditionalSelector( selector:ISimpleSelector, condition:ICondition ):IConditionalSelector;

		/**
		 * Creates a descendant selector.
		 * @param parent the parent selector
		 * @param descendant the descendant selector
		 * @throws ICSSException If this selector is not supported.
		 * @returns the combinator selector.
		 * @see SelectorTypes#SAC_DESCENDANT_SELECTOR
		 */
		function createDescendantSelector( parent:ISelector, descendant:ISimpleSelector ):IDescendantSelector;

		/**
		 * Creates a sibling selector.
		 * @param nodeType the type of nodes in the siblings list.
		 * @param child the child selector
		 * @param adjacent the direct adjacent selector
		 * @throws ICSSException If this selector is not supported.
		 * @returns the sibling selector with nodeType equals to org.w3c.dom.Node.ELEMENT_NODE
		 * @see SelectorTypes#SAC_DIRECT_ADJACENT_SELECTOR
		 */
		function createDirectAdjacentSelector( nodeType:uint, child:ISelector, directAdjacent:ISimpleSelector ):ISiblingSelector;

		/**
		 * Creates an element selector.
		 * @param namespaceURI the namespace URI of the element selector.
		 * @param tagName the local part of the element name. NULL if this element selector can match any element.
		 * @throws ICSSException If this selector is not supported.
		 * @returns the element selector
		 * @see SelectorTypes#SAC_ELEMENT_NODE_SELECTOR
		 */
		function createElementSelector( namespaceURI:String, tagName:String ):IElementSelector;

		/**
		 * Creates an negative selector.
		 * @param selector a selector.
		 * @throws ICSSException If this selector is not supported.
		 * @returns the negative selector.
		 * @see SelectorTypes#SAC_NEGATIVE_SELECTOR
		 */
		function createNegativeSelector( selector:ISimpleSelector ):INegativeSelector;

		/**
		 * Creates a processing instruction node selector.
		 * @param target the target 
		 * @param data the data
		 * @throws ICSSException If this selector is not supported.
		 * @returns the processing instruction node selector
		 * @see SelectorTypes#SAC_PROCESSING_INSTRUCTION_NODE_SELECTOR
		 */
		function createProcessingInstructionSelector( target:String, data:String ):IProcessingInstructionSelector;

		/**
		 * Creates a pseudo element selector.
		 * @param pseudoName the pseudo element name. NULL if this element selector can match any pseudo element.
		 * @throws ICSSException If this selector is not supported.
		 * @returns the element selector
		 * @see SelectorTypes#SAC_PSEUDO_ELEMENT_SELECTOR
		 */
		function createPseudoElementSelector( namespaceURI:String, pseudoName:String ):IElementSelector;

		/**
		 * Creates an root node selector.
		 * @throws ICSSException If this selector is not supported.
		 * @returns the root node selector.
		 * @see SelectorTypes#SAC_ROOT_NODE_SELECTOR
		 */
		function createRootNodeSelector():ISimpleSelector;

		/**
		 * Creates a text node selector.
		 * @param data the data
		 * @throws ICSSException If this selector is not supported.
		 * @returns the text node selector
		 * @see SelectorTypes#SAC_TEXT_NODE_SELECTOR
		 */
		function createTextNodeSelector( data:String ):ICharacterDataSelector;
	}
}