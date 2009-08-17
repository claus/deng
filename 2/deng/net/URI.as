package deng.net
{
	public class URI
	{
		// Components of all URIs:
		// [<scheme>:]<scheme-specific-part>[#<fragment>]
		private var scheme:String; // null: relative URI
		private var schemeSpecificPart:String;
		private var fragment:String;
		
		// Hierarchical URI components:
		// [//<authority>]<path>[?<query>]
		private var authority:String; // Registry or server
		
		// Server-based authority:
		// [<userinfo>@]<host>[:<port>]
		private var userinfo:String;
		private var host:String; // null: registry-based
		private var port:int = -1; // -1: undefined
		
		// Remaining components of hierarchical URIs
		private var path:String; // null: opaque
		private var query:String;

		// The string form of this URI
		private var string:String;
		
		private var decodedUserInfo:String = null;
		private var decodedAuthority:String = null;
		private var decodedPath:String = null;
		private var decodedQuery:String = null;
		private var decodedFragment:String = null;
		private var decodedSchemeSpecificPart:String = null;

		private var parserInput:String;
		private var parserRequireServerAuthority:Boolean;
		private var parserIPv6ByteCount:int;

		
		public function URI() {
		}
		
		
		// --------------
		//   Operations
		// --------------

		public function parseServerAuthority():URI {
			// We could be clever and cache the error message and index from the
			// exception thrown during the original parse, but that would require
			// either more fields or a more-obscure representation.
			if((host != null) || (authority == null)) {
				return this;
			}
			defineString();
			parse(string, true);
			return this;
		}


		// ----------------------------
		//   Component access methods
		// ----------------------------

		public function getScheme():String {
			return scheme;
		}

		public function isAbsolute():Boolean {
			return scheme != null;
		}

		public function isOpaque():Boolean {
			return path == null;
		}

		public function getSchemeSpecificPart():String {
			if(decodedSchemeSpecificPart == null) {
				decodedSchemeSpecificPart = decode(getRawSchemeSpecificPart());
			}
			return decodedSchemeSpecificPart;
		}

		public function getRawSchemeSpecificPart():String {
			defineSchemeSpecificPart();
			return schemeSpecificPart;
		}

		public function getAuthority():String {
			if(decodedAuthority == null) {
				decodedAuthority = decode(authority);
			}
			return decodedAuthority;
		}

		public function getRawAuthority():String {
			return authority;
		}

		public function getUserInfo():String {
			if((decodedUserInfo == null) && (userinfo != null)) {
				decodedUserInfo = decode(userinfo);
			}
			return decodedUserInfo;
		}

		public function getRawUserInfo():String {
			return userinfo;
		}

		public function getHost():String {
			return host;
		}

		public function getPort():int {
			return port;
		}

		public function getPath():String {
			if((decodedPath == null) && (path != null)) {
				decodedPath = decode(path);
			}
			return decodedPath;
		}

		public function getRawPath():String {
			return path;
		}

		public function getQuery():String {
			if((decodedQuery == null) && (query != null)) {
				decodedQuery = decode(query);
			}
			return decodedQuery;
		}

		public function getRawQuery():String {
			return query;
		}

		public function getFragment():String {
			if((decodedFragment == null) && (fragment != null)) {
				decodedFragment = decode(fragment);
			}
			return decodedFragment;
		}

		public function getRawFragment():String {
			return fragment;
		}


		// ----------------------------------------------------------------
		//   Equality, comparison, hash code, toString, and serialization
		// ----------------------------------------------------------------


		// -----------------------------------------------------------
		//   Utility methods for string-field comparison and hashing
		// -----------------------------------------------------------


		// -----------------------
		//   String construction
		// -----------------------
		
		// If a scheme is given then the path, if given, must be absolute
		private static function checkPath(s:String, scheme:String, path:String):void {
			if(scheme != null) {
				if((path != null) && ((path.length > 0) && (path.charAt(0) != '/'))) {
					//throw new URISyntaxException(s, "Relative path in absolute URI");
					throw new Error("Relative path in absolute URI");
				}
			}
		}
		
		private function appendAuthority(sb:String, authority:String, userInfo:String, host:String, port:int):String {
			if(host != null) {
				sb += "//";
				if(userInfo != null) {
					sb += quote(userInfo, L_USERINFO, H_USERINFO) + "@";
				}
				var needBrackets:Boolean = ((host.indexOf(':') >= 0) && (host.charAt(0) != "[") && (host.charAt(host.length - 1) != "]"));
				if(needBrackets) { 
					sb += '[' + host + ']';
				} else {
					sb += host;
				}
				if(port != -1) {
					sb += ':' + port.toString();
				}
			} else if(authority != null) {
				sb += "//";
				if(authority.charAt(0) == "[") {
					var end:int = authority.indexOf("]");
					if(end != -1 && authority.indexOf(":") != -1) {
						var doquote:String;
						var dontquote:String;
						if(end == authority.length) {
							dontquote = authority;
							doquote = "";
						} else {
							dontquote = authority.substring(0, end + 1);
							doquote = authority.substring(end + 1);
						}
						sb += dontquote;
						sb += quote(doquote, L_REG_NAME | L_SERVER, H_REG_NAME | H_SERVER);
					}
				}
			} else {
				sb += quote(authority, L_REG_NAME | L_SERVER, H_REG_NAME | H_SERVER);
			}
			return sb;
		}

		private function appendSchemeSpecificPart(sb:String, opaquePart:String, authority:String, userInfo:String, host:String, port:int, path:String, query:String):String {
			if(opaquePart != null) {
				// check if SSP begins with an IPv6 address
				// because we must not quote a literal IPv6 address
				if(opaquePart.substr(0, 3) == "//[") {
					var end:int = opaquePart.indexOf("]");
					if(end != -1 && opaquePart.indexOf(":") != -1) {
						var doquote:String;
						var dontquote:String;
						if(end == opaquePart.length) {
							dontquote = opaquePart;
							doquote = "";
						} else {
							dontquote = opaquePart.substring(0, end + 1);
							doquote = opaquePart.substring(end + 1);
						}
						sb += dontquote;
						sb += quote(doquote, L_URIC, H_URIC);
					}
				} else {
					sb += quote(opaquePart, L_URIC, H_URIC);
				}
			} else {
				sb = appendAuthority(sb, authority, userInfo, host, port);
				if(path != null) {
					sb += quote(path, L_PATH, H_PATH);
				}
				if(query != null) {
					sb += '?' + quote(query, L_URIC, H_URIC);
				}
			}
			return sb;
		}

		private function appendFragment(sb:String, fragment:String):String {
			if(fragment != null) {
				sb += '#' + quote(fragment, L_URIC, H_URIC);
			}
			return sb;
		}
		
		private function convertToString(scheme:String, opaquePart:String, authority:String, userInfo:String, host:String, port:int, path:String, query:String, fragment:String):String {
			var sb:String = (scheme != null) ? scheme + ":" : "";
			sb = appendSchemeSpecificPart(sb, opaquePart, authority, userInfo, host, port, path, query);
			sb = appendFragment(sb, fragment);
			return sb;
		}
		
		private function defineSchemeSpecificPart():void {
			if(schemeSpecificPart != null) {
				return;
			}
			var sb:String = "";
			sb = appendSchemeSpecificPart(sb, null, getAuthority(), getUserInfo(), host, port, getPath(), getQuery());
			if(sb.length == 0) {
				return;
			}
			schemeSpecificPart = sb;
		}
		
		private function defineString():void {
			if(string != null) {
				return;
			}
			var sb:String = (scheme != null) ? scheme + ":" : "";
			if(isOpaque()) {
				sb += schemeSpecificPart;
			} else {
				if(host != null) {
					sb += "//";
					if(userinfo != null) {
						sb += userinfo + '@';
					}
					var needBrackets:Boolean = ((host.indexOf(':') >= 0) && (host.charAt(0) != "[") && (host.charAt(host.length - 1) != "]"));
					if(needBrackets) { 
						sb += '[' + host + ']';
					} else {
						sb += host;
					}
					if(port != -1) {
						sb += ':' + port.toString();
					}
				} else if(authority != null) {
					sb += "//" + authority;
				}
				if(path != null) {
					sb += path;
				}
				if(query != null) {
					sb += '?' + query;
				}
			}
			if(fragment != null) {
				sb += '#' + fragment;
			}
			string = sb;
		}
		

		public function toString():String {
			return "[uri: " + string + "]\n" +
				"  scheme: " + scheme + "\n" +
				"  schemeSpecificPart: " + schemeSpecificPart + "\n" +
				"  authority: " + authority + "\n" +
				"  userinfo: " + userinfo + "\n" +
				"  host: " + host + "\n" +
				"  port: " + port.toString() + "\n" +
				"  path: " + path + "\n" +
				"  query: " + query + "\n" +
				"  fragment: " + fragment;
		}


		// -------------------------------
		//  Character classes for parsing
		// -------------------------------
		
		// RFC2396 precisely specifies which characters in the US-ASCII charset are
		// permissible in the various components of a URI reference.  We here
		// define a set of mask pairs to aid in enforcing these restrictions.  Each
		// mask pair consists of two longs, a low mask and a high mask.  Taken
		// together they represent a 128-bit mask, where bit i is set iff the
		// character with value i is permitted.

		// This approach is more efficient than sequentially searching arrays of
		// permitted characters.  It could be made still more efficient by
		// precompiling the mask information so that a character's presence in a
		// given mask could be determined by a single table lookup.
		
		// Compute a low-order mask for the characters
		// between first and last, inclusive
		private static function lowMask(first:Number, last:Number):uint {
			var m:uint = 0;
			var f:Number = Math.max(Math.min(first, 63), 0);
			var l:Number = Math.max(Math.min(last, 63), 0);
			for(var i:Number = f; i <= l; i++) {
				m |= 1 << i;
			}
			return m;
		}
		
		// Compute the low-order mask for the characters in the given string
		private static function lowMaskFromString(chars:String):uint {
			var n:int = chars.length;
			var m:uint = 0;
			for(var i:int = 0; i < n; i++) {
				var c:Number = chars.charCodeAt(i);
				if(chars.charCodeAt(i) < 64) {
					m |= (1 << c);
				}
			}
			return m;
		}
		
		// Compute a high-order mask for the characters
		// between first and last, inclusive
		private static function highMask(first:Number, last:Number):uint {
			var m:uint = 0;
			var f:Number = Math.max(Math.min(first, 127), 64) - 64;
			var l:Number = Math.max(Math.min(last, 127), 64) - 64;
			for(var i:Number = f; i <= l; i++) {
				m |= 1 << i;
			}
			return m;
		}
		
		// Compute the high-order mask for the characters in the given string
		private static function highMaskFromString(chars:String):uint {
			var m:uint = 0;
			var n:Number = chars.length;
			for(var i:Number = 0; i < n; i++) {
				var c:Number = chars.charCodeAt(i);
				if((c >= 64) && (c < 128)) {
					m |= (1 << (c - 64));
				}
			}
			return m;
		}
		
		// Tell whether the given character is permitted by the given mask pair
		private static function match(c:Number, lowMask:uint, highMask:uint):Boolean {
			if(c < 64) {
				return ((1 << c) & lowMask) != 0;
			}
			if(c < 128) {
				return ((1 << (c - 64)) & highMask) != 0;
			}
			return false;
		}
		
		// Character-class masks, in reverse order from RFC2396 because
		// initializers for static fields cannot make forward references.
		
		// digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
		private static var L_DIGIT:uint = lowMask(0x30, 0x39);
		private static var H_DIGIT:uint = 0;
		
		// upalpha = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" |
		//           "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" |
		//           "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
		private static var L_UPALPHA:uint = 0;
		private static var H_UPALPHA:uint = highMask(0x41, 0x5a);
		
		// lowalpha = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" |
		//            "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" |
		//            "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
		private static var L_LOWALPHA:uint = 0;
		private static var H_LOWALPHA:uint = highMask(0x61, 0x7a);
		
		// alpha = lowalpha | upalpha
		private static var L_ALPHA:uint = L_LOWALPHA | L_UPALPHA;
		private static var H_ALPHA:uint = H_LOWALPHA | H_UPALPHA;
		
		// alphanum = alpha | digit
		private static var L_ALPHANUM:uint = L_DIGIT | L_ALPHA;
		private static var H_ALPHANUM:uint = H_DIGIT | H_ALPHA;
		
		// hex = digit | "A" | "B" | "C" | "D" | "E" | "F" | "a" | "b" | "c" | "d" | "e" | "f"
		private static var L_HEX:uint = L_DIGIT;
		private static var H_HEX:uint = highMask(0x41, 0x46) | highMask(0x61, 0x66);
		
		// mark = "-" | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")"
		private static var L_MARK:uint = lowMaskFromString("-_.!~*'()");
		private static var H_MARK:uint = highMaskFromString("-_.!~*'()");
		
		// unreserved = alphanum | mark
		private static var L_UNRESERVED:uint = L_ALPHANUM | L_MARK;
		private static var H_UNRESERVED:uint = H_ALPHANUM | H_MARK;
		
		// reserved = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" | "$" | "," | "[" | "]"
		// Added per RFC2732: "[", "]"
		private static var L_RESERVED:uint = lowMaskFromString(";/?:@&=+$,[]");
		private static var H_RESERVED:uint = highMaskFromString(";/?:@&=+$,[]");
		
		// The zero'th bit is used to indicate that escape pairs and non-US-ASCII
		// characters are allowed; this is handled by the scanEscape method.
		private static var L_ESCAPED:uint = 1;
		private static var H_ESCAPED:uint = 0;
		
		// uric = reserved | unreserved | escaped
		private static var L_URIC:uint = L_RESERVED | L_UNRESERVED | L_ESCAPED;
		private static var H_URIC:uint = H_RESERVED | H_UNRESERVED | H_ESCAPED;
		
		// pchar = unreserved | escaped | ":" | "@" | "&" | "=" | "+" | "$" | ","
		private static var L_PCHAR:uint = L_UNRESERVED | L_ESCAPED | lowMaskFromString(":@&=+$,");
		private static var H_PCHAR:uint = H_UNRESERVED | H_ESCAPED | highMaskFromString(":@&=+$,");
		
		// All valid path characters
		private static var L_PATH:uint = L_PCHAR | lowMaskFromString(";/");
		private static var H_PATH:uint = H_PCHAR | highMaskFromString(";/");
		
		// Dash, for use in domainlabel and toplabel
		private static var L_DASH:uint = lowMaskFromString("-");
		private static var H_DASH:uint = highMaskFromString("-");
		
		// Dot, for use in hostnames
		private static var L_DOT:uint = lowMaskFromString(".");
		private static var H_DOT:uint = highMaskFromString(".");
		
		// userinfo = *( unreserved | escaped | ";" | ":" | "&" | "=" | "+" | "$" | "," )
		private static var L_USERINFO:uint = L_UNRESERVED | L_ESCAPED | lowMaskFromString(";:&=+$,");
		private static var H_USERINFO:uint = H_UNRESERVED | H_ESCAPED | highMaskFromString(";:&=+$,");
		
		// reg_name = 1*( unreserved | escaped | "$" | "," | ";" | ":" | "@" | "&" | "=" | "+" )
		private static var L_REG_NAME:uint = L_UNRESERVED | L_ESCAPED | lowMaskFromString("$,;:@&=+");
		private static var H_REG_NAME:uint = H_UNRESERVED | H_ESCAPED | highMaskFromString("$,;:@&=+");
		
		// All valid characters for server-based authorities
		private static var L_SERVER:uint = L_USERINFO | L_ALPHANUM | L_DASH | lowMaskFromString(".:@[]");
		private static var H_SERVER:uint = H_USERINFO | H_ALPHANUM | H_DASH | highMaskFromString(".:@[]");
		
		// Special case of server authority that represents an IPv6 address
		// In this case, a % does not signify an escape sequence
		private static var L_SERVER_PERCENT:uint = L_SERVER | lowMaskFromString("%");
		private static var H_SERVER_PERCENT:uint = H_SERVER | highMaskFromString("%");
		
		private static var L_LEFT_BRACKET:uint = lowMaskFromString("[");
		private static var H_LEFT_BRACKET:uint = highMaskFromString("[");
		
		// scheme = alpha *( alpha | digit | "+" | "-" | "." )
		private static var L_SCHEME:uint = L_ALPHA | L_DIGIT | lowMaskFromString("+-.");
		private static var H_SCHEME:uint = H_ALPHA | H_DIGIT | highMaskFromString("+-.");
		
		// uric_no_slash = unreserved | escaped |
		//                 ";" | "?" | ":" | "@" | "&" | "=" | "+" | "$" | ","
		private static var L_URIC_NO_SLASH:uint = L_UNRESERVED | L_ESCAPED | lowMaskFromString(";?:@&=+$,");
		private static var H_URIC_NO_SLASH:uint = H_UNRESERVED | H_ESCAPED | highMaskFromString(";?:@&=+$,");


		// -------------------------
		//   Escaping and encoding
		// -------------------------

		private static function escapeChar(c:Number):String {
			var s:String = c.toString(16);
			if(c < 0x10) { 
				s = '0' + s;
			}
			return '%' + s;
		}

		// Quote any characters in s that are not permitted
		// by the given mask pair
		private static function quote(s:String, lowMask:uint, highMask:uint):String {
			var n:int = s.length;
			var sb:String;
			var allowNonASCII:Boolean = ((lowMask & L_ESCAPED) != 0);
			for(var i:Number = 0; i < n; i++) {
				var c:Number = s.charCodeAt(i);
				if(c < 0x80) {
					if(!match(c, lowMask, highMask)) {
						if(sb == null) {
							sb = s.substring(0, i);
						}
						sb += escapeChar(c);
					} else {
						if(sb != null) {
							sb += String.fromCharCode(c);
						}
					}
				} else if(allowNonASCII && c == 0x20) {
					if(sb == null) {
						sb = s.substring(0, i);
					}
					sb += String.fromCharCode(c);
				} else {
					if(sb != null) {
						sb += String.fromCharCode(c);
					}
				}
			}
			return (sb == null) ? s : sb;
		}

		// Evaluates all escapes in s, applying UTF-8 decoding if needed.  Assumes
		// that escapes are well-formed syntactically, i.e., of the form %XX.
		// Exception: any "%" found between "[]" is left alone. It is an IPv6 literal
		// with a scope_id
		private static function decode(s:String):String {
			if(s == null) {
				return s;
			}
			var n:int = s.length;
			if(n == 0) {
				return s;
			}
			if(s.indexOf('%') == -1) {
				return s;
			}
			var sb:String = "";
			var c:String = s.charAt(0);
			var betweenBrackets:Boolean = false;
			for(var i:Number = 0; i < n; ) {
				if(c == '[') {
					betweenBrackets = true;
				} else if(betweenBrackets && c == ']') {
					betweenBrackets = false;
				}
				if(c != '%' || betweenBrackets) {
					sb += c;
					if(++i >= n) {
						break;
					}
					c = s.charAt(i);
					continue;
				}
				sb += String.fromCharCode(parseInt(s.substr(i + 1, 2), 16));
				i += 3;
				if(i < n) {
					c = s.charAt(i);
				}
			}
			return sb;
		}


		// ----------
		//   PARSER
		// ----------

		// [<scheme>:]<scheme-specific-part>[#<fragment>]
		public function parse(input:String, rsa:Boolean):void {
			parserInput = string = input;
			parserRequireServerAuthority = rsa;
			var ssp:int; // Start of scheme-specific part
			var n:int = input.length;
			var p:int = scan(0, n, "/?#", ":");
			if((p >= 0) && at(p, n, ':')) {
				if(p == 0) {
					failExpecting("scheme name", 0);
				}
				checkChar(0, L_ALPHA, H_ALPHA, "scheme name");
				checkChars(1, p, L_SCHEME, H_SCHEME, "scheme name");
				scheme = substring(0, p);
				p++; // Skip ':'
				ssp = p;
				if(at(p, n, '/')) {
					p = parseHierarchical(p, n);
				} else {
					var q:int = scan(p, n, "", "#");
			    	if(q <= p) {
						failExpecting("scheme-specific part", p);
			    	}
					checkChars(p, q, L_URIC, H_URIC, "opaque part");
					p = q;
				}
			} else {
				ssp = 0;
				p = parseHierarchical(0, n);
			}
			schemeSpecificPart = substring(ssp, p);
			if(at(p, n, '#')) {
				checkChars(p + 1, n, L_URIC, H_URIC, "fragment");
				fragment = substring(p + 1, n);
				p = n;
			}
			if(p < n) {
				fail("end of URI", p);
			}
		}

		// [//authority]<path>[?<query>]

		// DEVIATION from RFC2396: We allow an empty authority component as
		// long as it's followed by a non-empty path, query component, or
		// fragment component.  This is so that URIs such as "file:///foo/bar"
		// will parse.  This seems to be the intent of RFC2396, though the
		// grammar does not permit it.  If the authority is empty then the
		// userInfo, host, and port components are undefined.

		// DEVIATION from RFC2396: We allow empty relative paths.  This seems
		// to be the intent of RFC2396, but the grammar does not permit it.
		// The primary consequence of this deviation is that "#f" parses as a
		// relative URI with an empty path.
		private function parseHierarchical(start:int, n:int):int {
			var p:int = start;
			var q:int;
			if(at(p, n, '/') && at(p + 1, n, '/')) {
				p += 2;
				q = scan(p, n, "", "/?#");
				if(q > p) {
					p = parseAuthority(p, q);
				} else if(q < n) {
					// DEVIATION: Allow empty authority prior to non-empty 
					// path, query component or fragment identifier
				} else {
					failExpecting("authority", p);
				}
			}
			q = scan(p, n, "", "?#"); // DEVIATION: May be empty
			checkChars(p, q, L_PATH, H_PATH, "path");
			path = substring(p, q);
			p = q;
			if(at(p, n, '?')) {
				p++;
				q = scan(p, n, "", "#");
				checkChars(p, q, L_URIC, H_URIC, "query");
				query = substring(p, q);
				p = q;
			}
			return p;
		}
		
		// authority     = server | reg_name

		// Ambiguity: An authority that is a registry name rather than a server
		// might have a prefix that parses as a server.  We use the fact that
		// the authority component is always followed by '/' or the end of the
		// input string to resolve this: If the complete authority did not
		// parse as a server then we try to parse it as a registry name.
		private function parseAuthority(start:int, n:int):int {
			var p:int = start;
			var q:int = p;
			var ex:Error = null; //var ex:URISyntaxException = null;
			var serverChars:Boolean;
			var regChars:Boolean;
			
			if(scan(p, n, "", "]") > p) {
				// contains a literal IPv6 address, therefore % is allowed
				serverChars = (scanMasked(p, n, L_SERVER_PERCENT, H_SERVER_PERCENT) == n);
			} else {
				serverChars = (scanMasked(p, n, L_SERVER, H_SERVER) == n);
			}
			regChars = (scanMasked(p, n, L_REG_NAME, H_REG_NAME) == n);
			if(regChars && !serverChars) {
				// Must be a registry-based authority
				authority = substring(p, n);
				return n;
			}
			if(serverChars) {
				// Might be (probably is) a server-based authority, so attempt
				// to parse it as such.  If the attempt fails, try to treat it
				// as a registry-based authority.
				try {
					q = parseServer(p, n);
					if(q < n) {
						failExpecting("end of authority", q);
					}
					authority = substring(p, n);
				}
				catch(x:Error) {
					// Undo results of failed parse
					userinfo = null;
					host = null;
					port = -1;
					if(parserRequireServerAuthority) {
						// If we're insisting upon a server-based authority,
						// then just re-throw the exception
						throw x;
					} else {
						// Save the exception in case it doesn't parse as a
						// registry either
						ex = x;
						q = p;
					}
				}
			}
			if(q < n) {
				if(regChars) {
					// Registry-based authority
					authority = substring(p, n);
				} else if(ex != null) {
					// Re-throw exception; it was probably due to
					// a malformed IPv6 address
					throw ex;
				} else {
					fail("Illegal character in authority", q);
				}
			}
			return n;
		}

		// [<userinfo>@]<host>[:<port>]
		private function parseServer(start:int, n:int):int {
			var p:int = start;
			var q:int;
			// userinfo
			q = scan(p, n, "/?#", "@");
			if((q >= p) && at(q, n, '@')) {
				checkChars(p, q, L_USERINFO, H_USERINFO, "user info");
				userinfo = substring(p, q);
				p = q + 1; // Skip '@'
			}
			// hostname, IPv4 address, or IPv6 address
			if(at(p, n, '[')) {
				// DEVIATION from RFC2396: Support IPv6 addresses, per RFC2732
				p++;
				q = scan(p, n, "/?#", "]");
				if((q > p) && at(q, n, ']')) {
					// look for a "%" scope id
					var r:int = scan(p, q, "", "%");
					if(r > p) {
						parseIPv6Reference(p, r);
						if(r + 1 == q) {
							fail("scope id expected", q);
						}
						checkChars(r + 1, q, L_ALPHANUM, H_ALPHANUM, "scope id");
					} else {
						parseIPv6Reference(p, q);
					}
					host = substring(p - 1, q + 1);
					p = q + 1;
				} else {
					failExpecting("closing bracket for IPv6 address", q);
				}
			} else {
				q = parseIPv4Address(p, n);
				if(q <= p) {
		    		q = parseHostname(p, n);
		  		}
				p = q;
			}
			// port
			if(at(p, n, ':')) {
				p++;
				q = scan(p, n, "", "/");
				if(q > p) {
					checkChars(p, q, L_DIGIT, H_DIGIT, "port number");
					try {
						port = parseInt(substring(p, q));
					}
					catch(x:Error) { // NumberFormatException
						fail("Malformed port number", p);
					}
					p = q;
				}
			}
			if(p < n) {
				failExpecting("port number", p);
			}
			return p;
		}
		
		// Scan a string of decimal digits whose value fits in a byte
		private function scanByte(start:int, n:int):int {
			var p:int = start;
			var q:int = scanMasked(p, n, L_DIGIT, H_DIGIT);
			if(q <= p) {
				return q;
			}
			if(parseInt(substring(p, q)) > 255) {
				return p;
			}
			return q;
		}

		// Scan an IPv4 address.

		// If the strict argument is true then we require that the given
		// interval contain nothing besides an IPv4 address; if it is false
		// then we only require that it start with an IPv4 address.

		// If the interval does not contain or start with (depending upon the
		// strict argument) a legal IPv4 address characters then we return -1
		// immediately; otherwise we insist that these characters parse as a
		// legal IPv4 address and throw an exception on failure.

		// We assume that any string of decimal digits and dots must be an IPv4
		// address.  It won't parse as a hostname anyway, so making that
		// assumption here allows more meaningful exceptions to be thrown.
		private function scanIPv4Address(start:int, n:int, strict:Boolean):int {
			var p:int = start;
			var q:int;
			var m:int = scanMasked(p, n, L_DIGIT | L_DOT, H_DIGIT | H_DOT);
			if((m <= p) || (strict && (m != n))) {
				return -1;
			}
			var failReason:String = "Malformed IPv4 address";
			// Per RFC2732: At most three digits per byte
			// Further constraint: Each element fits in a byte
			if((q = scanByte(p, m)) <= p) { fail(failReason, p); };
			p = q;
			if((q = scanChar(p, m, '.')) <= p) { fail(failReason, p); };
			p = q;
			if((q = scanByte(p, m)) <= p) { fail(failReason, p); };
			p = q;
			if((q = scanChar(p, m, '.')) <= p) { fail(failReason, p); };
			p = q;
			if((q = scanByte(p, m)) <= p) { fail(failReason, p); };
			p = q;
			if((q = scanChar(p, m, '.')) <= p) { fail(failReason, p); };
			p = q;
			if((q = scanByte(p, m)) <= p) { fail(failReason, p); };
			p = q;
			if(q < m) { fail(failReason, p); };
			return q;
		}
		
		// Take an IPv4 address: Throw an exception if the given interval
		// contains anything except an IPv4 address
		private function takeIPv4Address(start:int, n:int, expected:String):int {
			var p:int = scanIPv4Address(start, n, true);
			if(p <= start) {
				failExpecting(expected, start);
			}
			return p;
		}

		// Attempt to parse an IPv4 address, returning -1 on failure but
		// allowing the given interval to contain [:<characters>] after
		// the IPv4 address.
		private function parseIPv4Address(start:int, n:int):int {
			var p:int;
			try {
				p = scanIPv4Address(start, n, false);
			}
			catch(x:Error) { // URISyntaxException
				return -1;
			}
			// catch(NumberFormatException nfe) {
			// 	return -1;
			// }
			if(p > start && p < n) {
				// IPv4 address is followed by something - check that
				// it's a ":" as this is the only valid character to
				// follow an address.
				if(charAt(p) != ':') {
					p = -1;
				}
			}
			if(p > start) {
				host = substring(start, p);
			}
			return p;
		}

		// hostname    = domainlabel [ "." ] | 1*( domainlabel "." ) toplabel [ "." ] 
		// domainlabel = alphanum | alphanum *( alphanum | "-" ) alphanum
		// toplabel    = alpha | alpha *( alphanum | "-" ) alphanum
		private function parseHostname(start:int, n:int):int {
		    var p:int = start;
		    var q:int;
		    var l:int = -1; // Start of last parsed label
		    do {
				// domainlabel = alphanum [ *( alphanum | "-" ) alphanum ]
				q = scanMasked(p, n, L_ALPHANUM, H_ALPHANUM);
				if (q <= p) {
					break;
				}
				l = p;
				if(q > p) {
					p = q;
					q = scanMasked(p, n, L_ALPHANUM | L_DASH, H_ALPHANUM | H_DASH);
					if(q > p) {
						if(charAt(q - 1) == '-') {
							fail("Illegal character in hostname", q - 1);
						}
						p = q;
					}
				}
				q = scanChar(p, n, '.');
				if(q <= p) {
			    	break;
			 	}
				p = q;
		    }
		    while(p < n);
		    if((p < n) && !at(p, n, ':')) {
				fail("Illegal character in hostname", p);
		    }
		    if(l < 0) {
				failExpecting("hostname", start);
		    }
		    // for a fully qualified hostname check that the rightmost
		    // label starts with an alpha character.
		    if(l > start && !match(charCodeAt(l), L_ALPHA, H_ALPHA)) {
				fail("Illegal character in hostname", l);
		    }
		    host = substring(start, p);
		    return p;
		}

		// IPv6 address parsing, from RFC2373: IPv6 Addressing Architecture

		// Bug: The grammar in RFC2373 Appendix B does not allow addresses of
		// the form ::12.34.56.78, which are clearly shown in the examples
		// earlier in the document.  Here is the original grammar:
		//
		//   IPv6address = hexpart [ ":" IPv4address ]
		//   hexpart     = hexseq | hexseq "::" [ hexseq ] | "::" [ hexseq ]
		//   hexseq      = hex4 *( ":" hex4)
		//   hex4        = 1*4HEXDIG
		//
		// We therefore use the following revised grammar:
		//
		//   IPv6address = hexseq [ ":" IPv4address ]
		//                 | hexseq [ "::" [ hexpost ] ]
		//                 | "::" [ hexpost ]
		//   hexpost     = hexseq | hexseq ":" IPv4address | IPv4address
		//   hexseq      = hex4 *( ":" hex4)
		//   hex4        = 1*4HEXDIG
		//
		// This covers all and only the following cases:
		//
		//   hexseq
		//   hexseq : IPv4address
		//   hexseq ::
		//   hexseq :: hexseq
		//   hexseq :: hexseq : IPv4address
		//   hexseq :: IPv4address
		//   :: hexseq
		//   :: hexseq : IPv4address
		//   :: IPv4address
		//   ::
		//
		// Additionally we constrain the IPv6 address as follows :
		//
		//  i.  IPv6 addresses without compressed zeros should contain
		//      exactly 16 bytes.
		//  ii. IPv6 addresses with compressed zeros should contain
		//      less than 16 bytes.
		private function parseIPv6Reference(start:int, n:int):int {
			var p:int = start;
			var q:int = scanHexSeq(p, n);
			var compressedZeros:Boolean = false;
			parserIPv6ByteCount = 0;
			if(q > p) {
				p = q;
				if(at(p, n, "::")) {
					compressedZeros = true;
					p = scanHexPost(p + 2, n);
				} else if(at(p, n, ':')) {
					p = takeIPv4Address(p + 1,  n, "IPv4 address");
					parserIPv6ByteCount += 4;
				}
			} else if(at(p, n, "::")) {
				compressedZeros = true;
				p = scanHexPost(p + 2, n);
			}
			if(p < n) {
				fail("Malformed IPv6 address", start);
			}
			if(parserIPv6ByteCount > 16) {
				fail("IPv6 address too long", start);
			}
			if(!compressedZeros && parserIPv6ByteCount < 16) {
				fail("IPv6 address too short", start);
			}
			if(compressedZeros && parserIPv6ByteCount == 16) {
				fail("Malformed IPv6 address", start);
			}
			return p;
		}
		
		private function scanHexPost(start:int, n:int):int {
			var p:int = start;
			var q:int;
			if(p == n) {
				return p;
			}
			q = scanHexSeq(p, n);
			if(q > p) {
				p = q;
				if(at(p, n, ':')) {
					p++;
					p = takeIPv4Address(p, n, "hex digits or IPv4 address");
					parserIPv6ByteCount += 4;
				}
			} else {
				p = takeIPv4Address(p, n, "hex digits or IPv4 address");
				parserIPv6ByteCount += 4;
			}
			return p;
		}
		
		// Scan a hex sequence
		// return -1 if one could not be scanned
		private function scanHexSeq(start:int, n:int):int {
			var p:int = start;
			var q:int = scanMasked(p, n, L_HEX, H_HEX);
			if(q <= p) {
				return -1;
			}
			if(at(q, n, '.')) {
				// Beginning of IPv4 address
				return -1;
			}
			if(q > p + 4) {
				fail("IPv6 hexadecimal digit sequence too long", p);
			}
			parserIPv6ByteCount += 2;
			p = q;
			while(p < n) {
				if(!at(p, n, ':')) {
			    	break;
			 	}
				if(at(p + 1, n, ':')) {
			    	break; // "::"
			 	}
				p++;
				q = scanMasked(p, n, L_HEX, H_HEX);
				if(q <= p) {
			    	failExpecting("digits for an IPv6 address", p);
			 	}
				if(at(q, n, '.')) {
					// Beginning of IPv4 address
			    	p--;
			    	break;
				}
				if(q > p + 4) {
			    	fail("IPv6 hexadecimal digit sequence too long", p);
			 	}
				parserIPv6ByteCount += 2;
				p = q;
			}
			return p;
		}
		

		// ----------
		//  Scanning
		// ----------
		
		// The various scan and parse methods that follow use a uniform
		// convention of taking the current start position and end index as
		// their first two arguments.  The start is inclusive while the end is
		// exclusive, just as in the String class, i.e., a start/end pair
		// denotes the left-open interval [start, end) of the input string.

		// These methods never proceed past the end position.  They may return
		// -1 to indicate outright failure, but more often they simply return
		// the position of the first char after the last char scanned.  Thus
		// a typical idiom is

		//     int p = start;
		//     int q = scan(p, end, ...);
		//     if (q > p)
		//         // We scanned something
		//     else if (q == p)
		//         // We scanned nothing
		//     else if (q == -1)
		//         // Something went wrong
		
		// Scan forward from the given start position.  Stop at the first char
		// in the err string (in which case -1 is returned), or the first char
		// in the stop string (in which case the index of the preceding char is
		// returned), or the end of the input string (in which case the length
		// of the input string is returned).  May return the start position if
		// nothing matches.
		private function scan(start:int, end:int, err:String, stop:String):int {
			var p:int = start;
			while(p < end) {
				var c:String = charAt(p);
				if(err.indexOf(c) >= 0) {
					return -1;
				}
				if(stop.indexOf(c) >= 0) {
					break;
				}
				p++;
			}
			return p;
		}
		
		// Scan a specific char: If the char at the given start position is
		// equal to c, return the index of the next char; otherwise, return the
		// start position.
		private function scanChar(start:int, end:int, c:String):int {
			if((start < end) && (charAt(start) == c)) {
				return start + 1;
			}
			return start;
		}

		// Scan chars that match the given mask pair
		private function scanMasked(start:int, n:int, lowMask:uint, highMask:uint):int {
			var p:int = start;
			while(p < n) {
				var c:Number = charCodeAt(p);
				if(match(c, lowMask, highMask)) {
					p++;
					continue;
				}
				if((lowMask & L_ESCAPED) != 0) {
					var q:int = scanEscape(p, n, c);
					if (q > p) {
						p = q;
						continue;
					}
				}
				break;
			}
			return p;
		}

		// Scan a potential escape sequence, starting at the given position,
		// with the given first char (i.e., charAt(start) == c).
		// This method assumes that if escapes are allowed then visible
		// non-US-ASCII chars are also allowed.
		private function scanEscape(start:int, n:int, first:Number):int {
			var p:int = start;
			var c:Number = first;
			if(c == 0x25) {
				// "%": Process escape pair
				if((p + 3 <= n) 
				  && match(charCodeAt(p + 1), L_HEX, H_HEX)
				  && match(charCodeAt(p + 2), L_HEX, H_HEX)) {
					return p + 3;
				}
				fail("Malformed escape pair", p);
			} else if(c > 159) {
				// Allow unescaped but visible non-US-ASCII chars
				return p + 1;
			}
			return p;
		}

		// Check that each of the chars in [start, end) matches the given mask
		private function checkChars(start:int, end:int, lowMask:int, highMask:int, what:String):void {
			var p:int = scanMasked(start, end, lowMask, highMask);
			if(p < end) {
				fail("Illegal character in " + what, p);
			}
		}
		
		// Check that the char at position p matches the given mask
		private function checkChar(p:int, lowMask:int, highMask:int, what:String):void {
			checkChars(p, p + 1, lowMask, highMask, what);
		}
		

		// -----------------------------------
		//  Simple access to the input string
		// -----------------------------------
		
		// Return a substring of the input string
		private function substring(start:int, end:int):String {
			return parserInput.substring(start, end);
		}
		
		// Return the char at position p,
		// assuming that p < input.length()
		private function charAt(p:int):String {
			return parserInput.charAt(p);
		}
		
		// Return the code of the char at position p,
		// assuming that p < input.length()
		private function charCodeAt(p:int):Number {
			return parserInput.charCodeAt(p);
		}
		
		// Tells whether start + s.length < end and, if so,
		// whether the chars at the start position match s exactly
		private function at(start:int, end:int, s:String):Boolean {
			var p:int = start;
			var sn:int = s.length;
			if(sn > end - p) {
				return false;
			}
			var i:int = 0;
			while(i < sn) {
				if(charAt(p++) != s.charAt(i)) {
					break;
				}
				i++;
			}
			return (i == sn);
		}

		
		// ---------------------------------------------------------
		//  Methods for throwing URISyntaxException in various ways
		// ---------------------------------------------------------
		
		private function fail(reason:String, p:int):void {
			// throw new URISyntaxException(input, reason, p);
			throw new Error(reason + " [" + p + "]");
		}
		
		private function failExpecting(expected:String, p:int):void {
			fail("Expected " + expected, p);
		}
		
		private function failExpectingPrior(expected:String, prior:String, p:int):void {
			fail("Expected " + expected + " following " + prior, p);
		}
	}
}