package org.w3c.css.sac
{
	/**
	 * This is a lexical unit for CSS values.
	 * <p><strong>Remarks</strong>: Not all the following lexical units are supported (or will be supported) by CSS.</p>
	 * @see LexicalUnitTypes
	 */
	public interface ILexicalUnit
	{
		
		/**
		 * Returns the string representation of the unit.
		 * If this lexical unit represents a float, the dimension is an empty string.
		 * @see LexicalUnitTypes#SAC_REAL
		 * @see LexicalUnitTypes#SAC_DIMENSION
		 * @see LexicalUnitTypes#SAC_EM
		 * @see LexicalUnitTypes#SAC_EX
		 * @see LexicalUnitTypes#SAC_PIXEL
		 * @see LexicalUnitTypes#SAC_INCH
		 * @see LexicalUnitTypes#SAC_CENTIMETER
		 * @see LexicalUnitTypes#SAC_MILLIMETER
		 * @see LexicalUnitTypes#SAC_POINT
		 * @see LexicalUnitTypes#SAC_PICA
		 * @see LexicalUnitTypes#SAC_PERCENTAGE
		 * @see LexicalUnitTypes#SAC_DEGREE
		 * @see LexicalUnitTypes#SAC_GRADIAN
		 * @see LexicalUnitTypes#SAC_RADIAN
		 * @see LexicalUnitTypes#SAC_MILLISECOND
		 * @see LexicalUnitTypes#SAC_SECOND
		 * @see LexicalUnitTypes#SAC_HERTZ
		 * @see LexicalUnitTypes#SAC_KILOHERTZ
		 */
		function getDimensionUnitText():String;

		/**
		 * Returns the float value.
		 * If the type of LexicalUnit is one of SAC_DEGREE, SAC_GRADIAN, SAC_RADIAN, SAC_MILLISECOND, SAC_SECOND, SAC_HERTZ or SAC_KILOHERTZ, the value can never be negative.
		 * @see LexicalUnitTypes#SAC_REAL
		 * @see LexicalUnitTypes#SAC_DIMENSION
		 * @see LexicalUnitTypes#SAC_EM
		 * @see LexicalUnitTypes#SAC_EX
		 * @see LexicalUnitTypes#SAC_PIXEL
		 * @see LexicalUnitTypes#SAC_INCH
		 * @see LexicalUnitTypes#SAC_CENTIMETER
		 * @see LexicalUnitTypes#SAC_MILLIMETER
		 * @see LexicalUnitTypes#SAC_POINT
		 * @see LexicalUnitTypes#SAC_PICA
		 * @see LexicalUnitTypes#SAC_PERCENTAGE
		 * @see LexicalUnitTypes#SAC_DEGREE
		 * @see LexicalUnitTypes#SAC_GRADIAN
		 * @see LexicalUnitTypes#SAC_RADIAN
		 * @see LexicalUnitTypes#SAC_MILLISECOND
		 * @see LexicalUnitTypes#SAC_SECOND
		 * @see LexicalUnitTypes#SAC_HERTZ
		 * @see LexicalUnitTypes#SAC_KILOHERTZ
		 */
		function getFloatValue():Number;

		/**
		 * Returns the name of the function.
		 * @see LexicalUnitTypes#SAC_COUNTER_FUNCTION
		 * @see LexicalUnitTypes#SAC_COUNTERS_FUNCTION
		 * @see LexicalUnitTypes#SAC_RECT_FUNCTION
		 * @see LexicalUnitTypes#SAC_FUNCTION
		 * @see LexicalUnitTypes#SAC_RGBCOLOR
		 */
		function getFunctionName():String;

		/**
		 * Returns the integer value.
		 * @see LexicalUnitTypes#SAC_INTEGER
		 */
		function getIntegerValue():int;

		/**
		 * An integer indicating the type of LexicalUnit.
		 * @see LexicalUnitTypes
		 */
		function getLexicalUnitType():uint;

		/**
		 * Returns the next value or null if any.
		 */
		function getNextLexicalUnit():ILexicalUnit;

		/**
		 * The function parameters including operators (like the comma).
		 * #000 is converted to rgb(0, 0, 0) can return null if SAC_FUNCTION.
		 * @see LexicalUnitTypes#SAC_COUNTER_FUNCTION
		 * @see LexicalUnitTypes#SAC_COUNTERS_FUNCTION
		 * @see LexicalUnitTypes#SAC_RECT_FUNCTION
		 * @see LexicalUnitTypes#SAC_FUNCTION
		 * @see LexicalUnitTypes#SAC_RGBCOLOR
		 */
		function getParameters():ILexicalUnit;

		/**
		 * Returns the previous value or null if any.
		 */
		function getPreviousLexicalUnit():ILexicalUnit;

		/**
		 * Returns the string value.
		 * <p>If the type is SAC_URI, the return value doesn't contain uri(....) or quotes.</p>
		 * <p>If the type is SAC_ATTR, the return value doesn't contain attr(....).</p>
		 * @see LexicalUnitTypes#SAC_URI
		 * @see LexicalUnitTypes#SAC_ATTR
		 * @see LexicalUnitTypes#SAC_IDENT
		 * @see LexicalUnitTypes#SAC_STRING_VALUE
		 */
		function getStringValue():String;

		/**
		 * Returns a list of values inside the sub expression.
		 * @see LexicalUnitTypes#SAC_SUB_EXPRESSION
		 */
		function getSubValues():ILexicalUnit;
	}
}