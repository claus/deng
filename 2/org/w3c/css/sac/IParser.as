package org.w3c.css.sac
{
	import flash.net.URLRequest;
	
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/Parser.html
	/**
	 * Basic interface for CSS (Simple API for CSS) parsers.
	 * <p>All CSS parsers must implement this basic interface: it allows applications to register handlers for different types of events and to initiate a parse from a URI, or a character stream.</p>
	 * <p>All CSS parsers must also implement a zero-argument constructor (though other constructors are also allowed).</p>
	 * <p>CSS parsers are reusable but not re-entrant: the application may reuse a parser object (possibly with a different input source) once the first parse has completed successfully, but it may not invoke the parse() methods recursively within a parse.</p>
	 * @see IDocumentHandler
	 * @see IErrorHandler
	 */
	public interface IParser
	{
		/**
		 * Returns a string about which CSS language is supported by this parser.
		 * For CSS Level 1, it returns "http://www.w3.org/TR/REC-CSS1", for CSS Level 2, it returns "http://www.w3.org/TR/REC-CSS2". Note that a "CSSx" parser can return lexical unit other than those allowed by CSS Level x but this usage is not recommended.
		 */
		function getParserVersion():String;

		/**
		 * Parse a CSS priority value (e.g. "!important").
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function parsePriority( priority:String ):Boolean;

		/**
		 * Parse a CSS property value.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function parsePropertyValue( value:String ):ILexicalUnit;

		/**
		 * Parse a CSS rule.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function parseRule( rule:String ):void;

		/**
		 * Parse a comma separated list of selectors.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function parseSelectors( selectors:String ):ISelectorList;

		/**
		 * Parse a CSS style declaration (without '{' and '}').
		 * @param styleValue The declaration.
		 * @returns ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function parseStyleDeclaration( declaration:String ):void;

		/**
		 * Parse a CSS document.
		 * <p>The application can use this method to instruct the CSS parser to begin parsing an CSS document from any valid input source (a character stream, a byte stream, or a URI).</p>
		 * <p>Applications may not invoke this method while a parse is in progress (they should create a new Parser instead for each additional CSS document). Once a parse is complete, an application may reuse the same Parser object, possibly with a different input source.</p>
		 * @param source The input source for the top-level of the CSS document.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 * @see #parseStyleSheet(String)
		 * @see #setDocumentHandler(IDocumentHandler)
		 * @see #setErrorHandler(IErrorHandler) 
		 */
		function parseStyleSheet( css:String ):void;

		/**
		 * Parse a CSS document from a URLRequest.
		 * <p>This method is a shortcut for the common case of reading a document from a URL.</p>
		 * @param request The URLRequest.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 * @see #parseStyleSheet(String)
		 */
		function loadStyleSheet( request:URLRequest ):void;

		/**
		 * 
		 */
		function setConditionFactory( factory:IConditionFactory ):void;

		/**
		 * Allow an application to register a document event handler.
		 * <p>If the application does not register a document handler, all document events reported by the CSS parser will be silently ignored (this is the default behaviour implemented by HandlerBase).</p>
		 * <p>Applications may register a new or different handler in the middle of a parse, and the CSS parser must begin using the new handler immediately.</p>
		 * @param handler The document handler.
		 * @see IDocumentHandler
		 */
		function setDocumentHandler( handler:IDocumentHandler ):void;

		/**
		 * Allow an application to register an error event handler.
		 * <p>If the application does not register an error event handler, all error events reported by the CSS parser will be silently ignored, except for fatalError, which will throw a CSSException (this is the default behaviour implemented by HandlerBase).</p>
		 * <p>Applications may register a new or different handler in the middle of a parse, and the CSS parser must begin using the new handler immediately.</p>
		 * @param handler The error handler.
		 * @see IErrorHandler
		 * @see ICSSException
		 */
		function setErrorHandler( handler:IErrorHandler ):void

		/**
		 * Allow an application to request a locale for errors and warnings.
		 * <p>CSS parsers are not required to provide localisation for errors and warnings; if they cannot support the requested locale, however, they must throw a CSS exception. Applications may not request a locale change in the middle of a parse.</p>
		 * @param locale A Java Locale object.
		 * @throws ICSSException Throws an exception (using the previous or default locale) if the requested locale is not supported.
		 * @see ICSSException
		 * @see ICSSParseException
		 */
		function setLocale( locale:* ):void; // ???

		/**
		 * 
		 */
		function setSelectorFactory( factory:ISelectorFactory ):void;
	}
}