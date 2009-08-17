package org.w3c.css.sac
{
	/**
	 * Holds lexical unit type designations.
	 * <p>All examples are CSS2 compliant.</p>
	 */
	public class LexicalUnitTypes
	{
		/**
		 * Attribute: attr(...)
		 * @see ILexicalUnit#getStringValue()
		 */
		public static const SAC_ATTR:uint = 0;

		/**
		 * Absolute length cm.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_CENTIMETER:uint = 1;

		/**
		 * function counter.
		 * @see ILexicalUnit#getFunctionName()
		 * @see ILexicalUnit#getParameters()
		 */
		public static const SAC_COUNTER_FUNCTION:uint = 2;

		/**
		 * function counters.
		 * @see ILexicalUnit#getFunctionName()
		 * @see ILexicalUnit#getParameters()
		 */
		public static const SAC_COUNTERS_FUNCTION:uint = 3;

		/**
		 * Angle deg.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_DEGREE:uint = 4;

		/**
		 * unknown dimension.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_DIMENSION:uint = 5;

		/**
		 * Relative length em.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_EM:uint = 6;

		/**
		 * Relative lengthex.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText() 
		 */
		public static const SAC_EX:uint = 7;

		/**
		 * unknown function.
		 * @see ILexicalUnit#getFunctionName()
		 * @see ILexicalUnit#getParameters()
		 */
		public static const SAC_FUNCTION:uint = 8;

		/**
		 * Angle grad.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_GRADIAN:uint = 9;

		/**
		 * Frequency Hz.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_HERTZ:uint = 10;

		/**
		 * any identifier except inherit.
		 * @see ILexicalUnit#getStringValue()
		 */
		public static const SAC_IDENT:uint = 11;

		/**
		 * Absolute length in.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_INCH:uint = 12;

		/**
		 * identifier inherit.
		 */
		public static const SAC_INHERIT:uint = 13;

		/**
		 * Integers.
		 * @see ILexicalUnit#getIntegerValue()
		 */
		public static const SAC_INTEGER:uint = 14;

		/**
		 * Frequency kHz.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_KILOHERTZ:uint = 15;

		/**
		 * Absolute length mm.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_MILLIMETER:uint = 16;

		/**
		 * Time ms.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_MILLISECOND:uint = 17;

		/**
		 * ,
		 */
		public static const SAC_OPERATOR_COMMA:uint = 18;

		/**
		 * ^
		 */
		public static const SAC_OPERATOR_EXP:uint = 19;

		/**
		 * >=
		 */
		public static const SAC_OPERATOR_GE:uint = 20;

		/**
		 * >
		 */
		public static const SAC_OPERATOR_GT:uint = 21;

		/**
		 * <=
		 */
		public static const SAC_OPERATOR_LE:uint = 22;

		/**
		 * <
		 */
		public static const SAC_OPERATOR_LT:uint = 23;

		/**
		 * -
		 */
		public static const SAC_OPERATOR_MINUS:uint = 24;

		/**
		 * %
		 */
		public static const SAC_OPERATOR_MOD:uint = 25;

		/**
		 * \*
		 */
		public static const SAC_OPERATOR_MULTIPLY:uint = 26;

		/**
		 * +
		 */
		public static const SAC_OPERATOR_PLUS:uint = 27;

		/**
		 * /
		 */
		public static const SAC_OPERATOR_SLASH:uint = 28;

		/**
		 * ~
		 */
		public static const SAC_OPERATOR_TILDE:uint = 29;

		/**
		 * Percentage.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_PERCENTAGE:uint = 30;

		/**
		 * Absolute length pc.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_PICA:uint = 31;

		/**
		 * Relative length px.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_PIXEL:uint = 32;

		/**
		 * Absolute length pt.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_POINT:uint = 33;

		/**
		 * Angle rad.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_RADIAN:uint = 34;

		/**
		 * reals.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_REAL:uint = 35;

		/**
		 * function rect.
		 * @see ILexicalUnit#getFunctionName()
		 * @see ILexicalUnit#getParameters()
		 */
		public static const SAC_RECT_FUNCTION:uint = 36;

		/**
		 * RGB Colors. rgb(0, 0, 0) and #000
		 * @see ILexicalUnit#getFunctionName()
		 * @see ILexicalUnit#getParameters()
		 */
		public static const SAC_RGBCOLOR:uint = 37;

		/**
		 * Time s.
		 * @see ILexicalUnit#getFloatValue()
		 * @see ILexicalUnit#getDimensionUnitText()
		 */
		public static const SAC_SECOND:uint = 38;

		/**
		 * A string.
		 * @see ILexicalUnit#getStringValue()
		 */
		public static const SAC_STRING_VALUE:uint = 39;

		/**
		 * sub expressions (a) (a + b) (normal/none)
		 * @see ILexicalUnit#getSubValues()
		 */
		public static const SAC_SUB_EXPRESSION:uint = 40;

		/**
		 * A unicode range. @@TO BE DEFINED
		 */
		public static const SAC_UNICODERANGE:uint = 41;

		/**
		 * URI: uri(...).
		 * @see ILexicalUnit#getStringValue()
		 */
		public static const SAC_URI:uint = 42;
	}
}