package deng.util
{
	import flash.utils.ByteArray;
	
	public class XML11Char
	{
		/** Character flags for XML 1.1. */
		private static var XML11CHARS:ByteArray = new ByteArray();
		
		/** XML 1.1 Valid character mask. */
		public static const MASK_XML11_VALID:uint = 0x01;
		
		/** XML 1.1 Space character mask. */
		public static const MASK_XML11_SPACE:uint = 0x02;
		
		/** XML 1.1 Name start character mask. */
		public static const MASK_XML11_NAME_START:uint = 0x04;
		
		/** XML 1.1 Name character mask. */
		public static const MASK_XML11_NAME:uint = 0x08;
		
		/** XML 1.1 control character mask */
		public static const MASK_XML11_CONTROL:uint = 0x10;

		/** XML 1.1 content for external entities (valid - "special" chars - control chars) */
		public static const MASK_XML11_CONTENT:uint = 0x20;
		
		/** XML namespaces 1.1 NCNameStart */
		public static const MASK_XML11_NCNAME_START:uint = 0x40;
		
		/** XML namespaces 1.1 NCName */
		public static const MASK_XML11_NCNAME:uint = 0x80;
		
		/** XML 1.1 content for internal entities (valid - "special" chars) */
		public static const MASK_XML11_CONTENT_INTERNAL:uint = MASK_XML11_CONTROL | MASK_XML11_CONTENT; 

		private static var initialized:Boolean = init();

		private static function fill(ba:ByteArray, indexFrom:uint, indexTo:uint, value:int):void {
			for(var i:uint = indexFrom; i < indexTo; i++) {
				ba[i] = value;
			}
		}
		
		private static function init():Boolean {
			XML11CHARS.length = 0x10000;
			fill(XML11CHARS, 1, 9, 17); // Fill 8 of value 17
			XML11CHARS[9] = 35;
			XML11CHARS[10] = 3;
			fill(XML11CHARS, 11, 13, 17); // Fill 2 of value 17
			XML11CHARS[13] = 3;
			fill(XML11CHARS, 14, 32, 17); // Fill 18 of value 17
			XML11CHARS[32] = 35;
			fill(XML11CHARS, 33, 38, 33); // Fill 5 of value 33
			XML11CHARS[38] = 1;
			fill(XML11CHARS, 39, 45, 33); // Fill 6 of value 33
			fill(XML11CHARS, 45, 47, -87); // Fill 2 of value -87
			XML11CHARS[47] = 33;
			fill(XML11CHARS, 48, 58, -87); // Fill 10 of value -87
			XML11CHARS[58] = 45;
			XML11CHARS[59] = 33;
			XML11CHARS[60] = 1;
			fill(XML11CHARS, 61, 65, 33); // Fill 4 of value 33
			fill(XML11CHARS, 65, 91, -19); // Fill 26 of value -19
			fill(XML11CHARS, 91, 93, 33); // Fill 2 of value 33
			XML11CHARS[93] = 1;
			XML11CHARS[94] = 33;
			XML11CHARS[95] = -19;
			XML11CHARS[96] = 33;
			fill(XML11CHARS, 97, 123, -19); // Fill 26 of value -19
			fill(XML11CHARS, 123, 127, 33); // Fill 4 of value 33
			fill(XML11CHARS, 127, 133, 17); // Fill 6 of value 17
			XML11CHARS[133] = 35;
			fill(XML11CHARS, 134, 160, 17); // Fill 26 of value 17
			fill(XML11CHARS, 160, 183, 33); // Fill 23 of value 33
			XML11CHARS[183] = -87;
			fill(XML11CHARS, 184, 192, 33); // Fill 8 of value 33
			fill(XML11CHARS, 192, 215, -19); // Fill 23 of value -19
			XML11CHARS[215] = 33;
			fill(XML11CHARS, 216, 247, -19); // Fill 31 of value -19
			XML11CHARS[247] = 33;
			fill(XML11CHARS, 248, 768, -19); // Fill 520 of value -19
			fill(XML11CHARS, 768, 880, -87); // Fill 112 of value -87
			fill(XML11CHARS, 880, 894, -19); // Fill 14 of value -19
			XML11CHARS[894] = 33;
			fill(XML11CHARS, 895, 8192, -19); // Fill 7297 of value -19
			fill(XML11CHARS, 8192, 8204, 33); // Fill 12 of value 33
			fill(XML11CHARS, 8204, 8206, -19); // Fill 2 of value -19
			fill(XML11CHARS, 8206, 8232, 33); // Fill 26 of value 33
			XML11CHARS[8232] = 35;
			fill(XML11CHARS, 8233, 8255, 33); // Fill 22 of value 33
			fill(XML11CHARS, 8255, 8257, -87); // Fill 2 of value -87
			fill(XML11CHARS, 8257, 8304, 33); // Fill 47 of value 33
			fill(XML11CHARS, 8304, 8592, -19); // Fill 288 of value -19
			fill(XML11CHARS, 8592, 11264, 33); // Fill 2672 of value 33
			fill(XML11CHARS, 11264, 12272, -19); // Fill 1008 of value -19
			fill(XML11CHARS, 12272, 12289, 33); // Fill 17 of value 33
			fill(XML11CHARS, 12289, 55296, -19); // Fill 43007 of value -19
			fill(XML11CHARS, 57344, 63744, 33); // Fill 6400 of value 33
			fill(XML11CHARS, 63744, 64976, -19); // Fill 1232 of value -19
			fill(XML11CHARS, 64976, 65008, 33); // Fill 32 of value 33
			fill(XML11CHARS, 65008, 65534, -19); // Fill 526 of value -19
			return true;
		}

		public static function isXML11Space(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_SPACE) != 0);
		}
		
		public static function isXML11Valid(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_VALID) != 0) || (0x10000 <= c && c <= 0x10FFFF);
		}

		public static function isXML11Invalid(c:int):Boolean {
			return !isXML11Valid(c);
		}

		public static function isXML11ValidLiteral(c:int):Boolean {
			return ((c < 0x10000 && ((XML11CHARS[c] & MASK_XML11_VALID) != 0 && (XML11CHARS[c] & MASK_XML11_CONTROL) == 0))
					|| (0x10000 <= c && c <= 0x10FFFF)); 
		}

		public static function isXML11Content(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_CONTENT) != 0) || (0x10000 <= c && c <= 0x10FFFF);
		}

		public static function isXML11InternalEntityContent(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_CONTENT_INTERNAL) != 0) || (0x10000 <= c && c <= 0x10FFFF);
		}

		public static function isXML11NameStart(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_NAME_START) != 0) || (0x10000 <= c && c < 0xF0000);
		}

		public static function isXML11Name(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_NAME) != 0) || (c >= 0x10000 && c < 0xF0000);
		}

		public static function isXML11NCNameStart(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_NCNAME_START) != 0) || (0x10000 <= c && c < 0xF0000);
		}

		public static function isXML11NCName(c:int):Boolean {
			return (c < 0x10000 && (XML11CHARS[c] & MASK_XML11_NCNAME) != 0) || (0x10000 <= c && c < 0xF0000);
		}

		public static function isXML11NameHighSurrogate(c:int):Boolean {
			return (0xD800 <= c && c <= 0xDB7F);
		}

		/**
		 * Check to see if a string is a valid Name according to [5]
		 * in the XML 1.1 Recommendation:
		 * 
		 * [5] Name ::= NameStartChar NameChar*
		 *
		 * @param name string to check
		 * @return true if name is a valid Name
		 */
		public static function isXML11ValidName(name:String):Boolean {
			var len:int = name.length;
			if(len == 0) {
				return false;
			}
			var i:int = 1;
			var ch:int = name.charCodeAt(0);
			var ch2:int;
			if(!isXML11NameStart(ch)) {
				if(len > 1 && isXML11NameHighSurrogate(ch)) {
					ch2 = name.charCodeAt(1);
					if(!XMLChar.isLowSurrogate(ch2) || !isXML11NameStart(XMLChar.supplemental(ch, ch2))) {
						return false;
					}
					i = 2;
				} else {
					return false;
				}
			}
			while(i < len) {
				ch = name.charCodeAt(i);
				if(!isXML11Name(ch)) {
					if(++i < len && isXML11NameHighSurrogate(ch)) {
						ch2 = name.charCodeAt(i);
						if(!XMLChar.isLowSurrogate(ch2) || !isXML11Name(XMLChar.supplemental(ch, ch2))) {
							return false;
						}
					} else {
						return false;
					}
				}
				++i;
			}
			return true;
		}
		
		/**
		 * Check to see if a string is a valid NCName according to [4]
		 * from the XML Namespaces 1.1 Recommendation
		 *
		 * [4] NCName ::= NCNameStartChar NCNameChar*
		 * 
		 * @param ncName string to check
		 * @return true if name is a valid NCName
		 */
		public static function isXML11ValidNCName(ncName:String):Boolean {
			var len:int = ncName.length;
			if(len == 0) {
				return false;
			}
			var i:int = 1;
			var ch:int = ncName.charCodeAt(0);
			var ch2:int;
			if(!isXML11NCNameStart(ch)) {
				if(len > 1 && isXML11NameHighSurrogate(ch)) {
					ch2 = ncName.charCodeAt(1);
					if(!XMLChar.isLowSurrogate(ch2) || !isXML11NCNameStart(XMLChar.supplemental(ch, ch2))) {
						return false;
					}
					i = 2;
				} else {
					return false;
				}
			}
			while(i < len) {
				ch = ncName.charCodeAt(i);
				if(!isXML11NCName(ch)) {
					if(++i < len && isXML11NameHighSurrogate(ch)) {
						ch2 = ncName.charCodeAt(i);
						if(!XMLChar.isLowSurrogate(ch2) || !isXML11NCName(XMLChar.supplemental(ch, ch2))) {
							return false;
						}
					} else {
						return false;
					}
				}
				++i;
			}
			return true;
		}

		/**
		 * Check to see if a string is a valid Nmtoken according to [7]
		 * in the XML 1.1 Recommendation
		 *
		 * [7] Nmtoken ::= (NameChar)+
		 * 
		 * @param nmtoken string to check
		 * @return true if nmtoken is a valid Nmtoken 
		 */
		public static function isXML11ValidNmtoken(nmtoken:String):Boolean {
			var len:int = nmtoken.length;
			if(len == 0) {
				return false;
			}
			for(var i:int = 0; i < len; ++i) {
				var ch:int = nmtoken.charCodeAt(i);
				if(!isXML11Name(ch)) {
					if(++i < len && isXML11NameHighSurrogate(ch)) {
						var ch2:int = nmtoken.charCodeAt(i);
						if(!XMLChar.isLowSurrogate(ch2) || !isXML11Name(XMLChar.supplemental(ch, ch2))) {
							return false;
						}
					} else {
						return false;
					}
				}
			}
			return true;
		}
	}
}