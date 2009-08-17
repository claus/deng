package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/ProcessingInstructionSelector.html
	/**
	 * @see SelectorTypes#SAC_PROCESSING_INSTRUCTION_NODE_SELECTOR
	 * @copy SelectorTypes#SAC_PROCESSING_INSTRUCTION_NODE_SELECTOR
	 */
	public interface IProcessingInstructionSelector extends ISimpleSelector
	{
		/**
		 * Returns the character data.
		 */
		function getData():String;

		/**
		 * Returns the target of the processing instruction.
		 */
		function getTarget():String;
	}
}