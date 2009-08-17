package deng.dom
{
	import org.w3c.dom.IUserDataHandler;
	import org.w3c.dom.IDocument;
	import org.w3c.dom.INode;
	import org.w3c.dom.INodeList;
	import org.w3c.dom.INamedNodeMap;
	import deng.dom.*;

	public class Node implements INode
	{
		public static const ELEMENT_NODE:int = 1;
		public static const ATTRIBUTE_NODE:int = 2;
		public static const TEXT_NODE:int = 3;
		public static const CDATA_SECTION_NODE:int = 4;
		public static const ENTITY_REFERENCE_NODE:int = 5;
		public static const ENTITY_NODE:int = 6;
		public static const PROCESSING_INSTRUCTION_NODE:int = 7;
		public static const COMMENT_NODE:int = 8;
		public static const DOCUMENT_NODE:int = 9;
		public static const DOCUMENT_TYPE_NODE:int = 10;
		public static const DOCUMENT_FRAGMENT_NODE:int = 11;
		public static const NOTATION_NODE:int = 12;

	    public static const DOCUMENT_POSITION_DISCONNECTED:uint = 0x01;
	    public static const DOCUMENT_POSITION_PRECEDING:uint = 0x02;
	    public static const DOCUMENT_POSITION_FOLLOWING:uint = 0x04;
	    public static const DOCUMENT_POSITION_CONTAINS:uint = 0x08;
	    public static const DOCUMENT_POSITION_CONTAINED_BY:uint = 0x10;
	    public static const DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC:uint = 0x20;

		private	var	_nodeName:String;
		private var _nodeValue:String;
		private	var	_nodeType:int;
		private var _attributes:NamedNodeMap;
		private var _ownerDocument:Document;

		private var _namespaceURI:String;
		private var	_prefix:String;
		private var _localName:String;
		private var _baseURI:String;

		//  Internal Properties
		private var _readOnly:Boolean;
		private var _next:Node;
		private var _prev:Node;
		private var _parentNode:Node;
		private var _children:Node;

		public function Node() {
		}
		
		public function get nodeName():String {
			return _nodeName;
		}
		
		public function get nodeValue():String {
			return _nodeValue;
		}
		
		public function set nodeValue(value:String):void {
			_nodeValue = value;
		}
		
		public function get nodeType():int {
			return _nodeType;
		}

		public function get parentNode():Node {
			return _parentNode;
		}
		
		public function get childNodes():NodeList {
			var children:Array = [];
			var n:Node = this._children;
			while(n) {
				children.push(n);
				n = n.nextSibling;
			}
			return new NodeList(children);
		}
		

		
		public function get firstChild():INode
		{
			return null;
		}
		
		public function insertBefore(newChild:INode, refChild:INode):INode
		{
			return null;
		}
		
		public function compareDocumentPosition(other:INode):int
		{
			return 0;
		}
		
		public function get localName():String
		{
			return null;
		}
		
		public function hasChildNodes():Boolean
		{
			return false;
		}
		
		public function lookupNamespaceURI(prefix:String):String
		{
			return null;
		}
		
		public function get namespaceURI():String
		{
			return null;
		}
		
		public function removeChild(oldChild:INode):INode
		{
			return null;
		}
		
		public function get attributes():INamedNodeMap
		{
			return null;
		}
		
		public function getUserData(key:String):Object
		{
			return null;
		}
		
		public function get nextSibling():INode
		{
			return null;
		}
		
		public function get hasAttributes():Boolean
		{
			return false;
		}
		
		public function appendChild(newChild:INode):INode
		{
			return null;
		}
		
		public function isSameNode(other:INode):Boolean
		{
			return false;
		}
		
		public function setUserData(key:String, data:Object, handler:IUserDataHandler):Object
		{
			return null;
		}
		
		public function get previousSibling():INode
		{
			return null;
		}
		
		public function lookupPrefix(namespaceURI:String):String
		{
			return null;
		}
		
		public function isDefaultNamespace(namespaceURI:String):Boolean
		{
			return false;
		}
		
		public function cloneNode(deep:Boolean):INode
		{
			return null;
		}
		
		public function replaceChild(newChild:INode, oldChild:INode):INode
		{
			return null;
		}
		
		public function isEqualNode(other:INode):Boolean
		{
			return false;
		}
		
		public function normalize():void
		{
		}
		
		public function get prefix():String
		{
			return null;
		}
		
		public function set prefix(value:String):void
		{
		}
		
		public function get lastChild():INode
		{
			return null;
		}
		
		public function get baseURI():String
		{
			return null;
		}
		
		public function get textContent():String
		{
			return null;
		}
		
		public function set textContent(value:String):void
		{
		}
		
		public function getFeature(feature:String, version:String):*
		{
			return null;
		}
		
		public function get ownerDocument():IDocument
		{
			return null;
		}
		
		public function isSupported(feature:String, version:String):Boolean
		{
			return false;
		}
		
	}
}