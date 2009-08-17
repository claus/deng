package org.w3c.css.sac
{
	// http://www.w3.org/TR/SAC/#documenthandler
	/**
	 * This is the main interface that most CSS applications implement.
	 * If the application needs to be informed of basic parsing events, it implements this interface and registers an instance with the CSS parser using the setCSSHandler method.
	 */
	public interface IDocumentHandler
	{	
		/**
		 * Receive notification of the beginning of a style sheet.
		 * The CSS parser will invoke this method only once, before any other methods in this interface.
		 * 
		 * @param uri The URI of the style sheet. @@TODO can be NULL ! (inline style sheet)
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function startDocument( source:String ):void; // ??? InputSource

		/**
		 * Receive notification of a comment.
		 * If the comment appears in a declaration (e.g. color: /* comment * / blue;), the parser notifies the comment before the declaration.
		 * 
		 * @param text The comment
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function comment( text:String ):void;

		/**
		 * Receive notification of an unknown rule t-rule not supported by this parser.
		 * 
		 * @param at-rule The complete ignored at-rule.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function ignorableAtRule( atRule:String ):void;

		/**
		 * Receive notification of a import statement in the style sheet.
		 * 
		 * @param uri The URI of the imported style sheet.
		 * @param media The intended destination media for style information.
		 * @param defaultNamepaceURI The default namespace URI for the imported style sheet.
		 * @param ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function importStyle( uri:String, media:ISACMediaList, defaultNamespaceURI:String ):void;

		/**
		 * Receive notification of the beginning of a media statement.
		 * The Parser will invoke this method at the beginning of every media statement in the style sheet. there will be a corresponding endMedia() event for every startElement() event.
		 *
		 * @param media The intended destination media for style information.
		 * @throws CSSException Any CSS exception, possibly wrapping another exception.
		 */
		function startMedia( media:ISACMediaList ):void;

		/**
		 * Receive notification of the beginning of a page statement.
		 * The Parser will invoke this method at the beginning of every page statement in the style sheet. there will be a corresponding endPage() event for every startPage() event.
		 * 
		 * @param name the name of the page (if any, null otherwise)
		 * @param pseudo_page the pseudo page (if any, null otherwise)
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function startPage( name:String, pseudo_page:String ):void;

		/**
		 * Receive notification of an unknown rule t-rule not supported by this parser.
		 * 
		 * @param prefix null if this is the default namespace
		 * @param uri The URI for this namespace.
		 * @throws CSSException Any CSS exception, possibly wrapping another exception.
		 */
		function namespaceDeclaration( prefix:String, uri:String ):void;

		/**
		 * Receive notification of the beginning of a rule statement.
		 * 
		 * @param selectors All intended selectors for all declarations.
		 * @param ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function startSelector( selectors:ISelectorList ):void;

		/**
		 * Receive notification of a declaration.
		 * 
		 * @param name the name of the property.
		 * @param value the value of the property. All whitespace are stripped.
		 * @param important is this property important?
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function property( name:String, value:ILexicalUnit, important:Boolean ):void;

		/**
		 * Receive notification of the end of a rule statement.
		 * 
		 * @param selectors All intended selectors for all declarations.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function endSelector( selectors:ISelectorList ):void;

		/**
		 * Receive notification of the end of a media statement.
		 * 
		 * @param media The intended destination medium for style information.
		 * @param pseudo_page the pseudo page (if any, null otherwise)
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function endPage( name:String, pseudo_page:String ):void;

		/**
		 * Receive notification of the end of a media statement.
		 * 
		 * @param media The intended destination media for style information.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function endMedia( media:ISACMediaList ):void;

		/**
		 * Receive notification of the end of a document.
		 * The CSS parser will invoke this method only once, and it will be the last method invoked during the parse. The parser shall not invoke this method until it has either abandoned parsing (because of an unrecoverable error) or reached the end of input.
		 * 
		 * @param uri The URI of the style sheet.
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function endDocument( source:String ):void; // ??? InputSource
		
		
		/**
		 * Receive notification of the beginning of a font face statement.
		 * The Parser will invoke this method at the beginning of every font face statement in the style sheet. there will be a corresponding endFontFace() event for every startFontFace() event.
		 * 
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function startFontFace():void;

		/**
		 * Receive notification of the end of a font face statement.
		 * 
		 * @throws ICSSException Any CSS exception, possibly wrapping another exception.
		 */
		function endFontFace():void;
		
		
	}
}