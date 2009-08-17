package org.w3c.css.dom
{

	public class CSSValueTypes
	{

		/**
		 * The value is inherited and the cssText contains "inherit".
		 */
		public static const CSS_INHERIT:uint = 0;

		/**
		 * The value is a primitive value and an instance of the CSSPrimitiveValue interface can be obtained by using binding-specific casting methods on this instance of the CSSValue interface.
		 */
		public static const CSS_PRIMITIVE_VALUE:uint = 1;

		/**
		 * The value is a CSSValue list and an instance of the CSSValueList interface can be obtained by using binding-specific casting methods on this instance of the CSSValue interface.
		 */
		public static const CSS_VALUE_LIST:uint = 2;

		/**
		 * The value is a custom value.
		 */
		public static const CSS_CUSTOM:uint = 3;

	}
}