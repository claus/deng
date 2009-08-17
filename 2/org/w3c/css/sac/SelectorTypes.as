package org.w3c.css.sac
{
	/**
	 * <strong>Remarks</strong>: Not all the following selectors are supported (or will be supported) by CSS.
	 * <p>All examples are CSS2 compliant.</p>
	 */
	public class SelectorTypes
	{
		/**
		 * This selector matches any node.
		 */
		public static const SAC_ANY_NODE_SELECTOR:uint = 0;
		
		/**
		 * This selector matches only cdata node.
		 */
		public static const SAC_CDATA_SECTION_NODE_SELECTOR:uint = 1;
		
		/**
		 * This selector matches a childhood relationship between two elements. example:
		 * <p>E > F</p>
		 */
		public static const SAC_CHILD_SELECTOR:uint = 2;
		
		/**
		 * This selector matches only comment node.
		 */
		public static const SAC_COMMENT_NODE_SELECTOR:uint = 3;
		
		/**
		 * This is a conditional selector. example:
		 * <p>simple[role="private"]
		 * <br/>.part1
		 * <br/>H1#myId
		 * <br/>P:lang(fr).p1</p>
		 */
		public static const SAC_CONDITIONAL_SELECTOR:uint = 4;
		
		/**
		 * This selector matches an arbitrary descendant of some ancestor element. example:
		 * <p>E F</p>
		 */
		public static const SAC_DESCENDANT_SELECTOR:uint = 5;
		
		/**
		 * This selector matches two selectors who shared the same parent in the document tree and the element represented by the first sequence immediately precedes the element represented by the second one. example:
		 * <p>E + F</p>
		 */
		public static const SAC_DIRECT_ADJACENT_SELECTOR:uint = 6;
		
		/**
		 * This selector matches only element node. example:
		 * <p>H1
		 * <br/>animate</p>
		 */
		public static const SAC_ELEMENT_NODE_SELECTOR:uint = 7;
		
		/**
		 * This selector matches only node that are different from a specified one.
		 */
		public static const SAC_NEGATIVE_SELECTOR:uint = 8;
		
		/**
		 * This selector matches only processing instruction node.
		 */
		public static const SAC_PROCESSING_INSTRUCTION_NODE_SELECTOR:uint = 9;
		
		/**
		 * This selector matches the 'first line' pseudo element. example:
		 * <p>:first-line</p>
		 */
		public static const SAC_PSEUDO_ELEMENT_SELECTOR:uint = 10;
		
		/**
		 * This selector matches the root node.
		 */
		public static const SAC_ROOT_NODE_SELECTOR:uint = 11;
		
		/**
		 * This selector matches only text node.
		 */
		public static const SAC_TEXT_NODE_SELECTOR:uint = 12;
	}
}