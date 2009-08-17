package org.w3c.css.dom
{

	/**
	 * The CSSStyleDeclaration interface represents a single CSS declaration block.
	 * This interface may be used to determine the style properties currently set in a block or to set style properties explicitly within the block.
	 * <p>While an implementation may not recognize all CSS properties within a CSS declaration block, it is expected to provide access to all specified properties in the style sheet through the CSSStyleDeclaration interface. Furthermore, implementations that support a specific level of CSS should correctly handle CSS shorthand properties for that level. For a further discussion of shorthand properties, see the CSS2Properties interface.</p>
	 * <p>This interface is also used to provide a read-only access to the computed values of an element. See also the ViewCSS interface.</p>
	 * <p><strong>Note</strong>: The CSS Object Model doesn't provide an access to the specified or actual values of the CSS cascade.</p>
	 */
	public interface ICSSStyleDeclaration
	{

		/**
		 * The parsable textual representation of the declaration block (excluding the surrounding curly braces).
		 * Setting this attribute will result in the parsing of the new value and resetting of all the properties in the declaration block including the removal or addition of properties.
		 */
		function get cssText():String;

		/**
		 * @throws IDOMException
		 * SYNTAX_ERR: Raised if the specified CSS string value has a syntax error and is unparsable.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this declaration is readonly or a property is readonly.
		 */
		function set cssText(value:String):void;

		/**
		 * Used to retrieve the value of a CSS property if it has been explicitly set within this declaration block.
		 * @param propertyName The name of the CSS property. See the CSS property index.
		 * @returns Returns the value of the property if it has been explicitly set for this declaration block. Returns the empty string if the property has not been set.
		 */
		function getPropertyValue(propertyName:String):String;

		/**
		 * Used to retrieve the object representation of the value of a CSS property if it has been explicitly set within this declaration block. This method returns null if the property is a shorthand property. Shorthand property values can only be accessed and modified as strings, using the getPropertyValue and setProperty methods.
		 * @param propertyName The name of the CSS property. See the CSS property index.
		 * @returns Returns the value of the property if it has been explicitly set for this declaration block. Returns null if the property has not been set.
		 */
		function getPropertyCSSValue(propertyName:String):ICSSValue;

		/**
		 * Used to remove a CSS property if it has been explicitly set within this declaration block.
		 * @param propertyName The name of the CSS property. See the CSS property index.
		 * @throws IDOMException
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this declaration is readonly or the property is readonly.
		 * @returns Returns the value of the property if it has been explicitly set for this declaration block. Returns the empty string if the property has not been set or the property name does not correspond to a known CSS property.
		 */
		function removeProperty(propertyName:String):String;

		/**
		 * Used to retrieve the priority of a CSS property (e.g. the "important" qualifier) if the property has been explicitly set in this declaration block.
		 * @param propertyName The name of the CSS property. See the CSS property index.
		 * @returns A string representing the priority (e.g. "important") if one exists. The empty string if none exists.
		 * 
		function getPropertyPriority(propertyName:String):String;

		/**
		 * Used to set a property value and priority within this declaration block.
		 * @param propertyName The name of the CSS property. See the CSS property index.
		 * @param value The new value of the property.
		 * @param priority The new priority of the property (e.g. "important").
		 * @throws IDOMException
		 * SYNTAX_ERR: Raised if the specified value has a syntax error and is unparsable.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this declaration is readonly or the property is readonly.
		 */
		function setProperty(propertyName:String, value:String, priority:String):void;

		/**
		 * The number of properties that have been explicitly set in this declaration block. The range of valid indices is 0 to length-1 inclusive.
		 */
		function get length():uint;

		/**
		 * Used to retrieve the properties that have been explicitly set in this declaration block. The order of the properties retrieved using this method does not have to be the order in which they were set. This method can be used to iterate over all properties in this declaration block.
		 * @param index Index of the property name to retrieve.
		 * @returns The name of the property at this ordinal position. The empty string if no property exists at this position.
		 */
		function item(index:uint):String;

		/**
		 * The CSS rule that contains this declaration block or null if this CSSStyleDeclaration is not attached to a CSSRule.
		 */
		function get parentRule():ICSSRule;
	}

}