package deng.dom
{
	import org.w3c.dom.*;
	import deng.util.XMLChar;
	import deng.util.XML11Char;
	import flash.utils.Dictionary;

	public class DocumentImpl extends ParentNode implements Document
	{
		internal var _docType:DocumentTypeImpl;
		internal var _docElement:ElementImpl;
		internal var _encoding:String;
		internal var _actualEncoding:String;
		internal var _version:String;
		internal var _standalone:Boolean;
		internal var _documentURI:String;
		internal var _errorChecking:Boolean = true;
		
		internal var userData:Dictionary;
		internal var identifiers:Dictionary;

		internal var freeNodeListCache:Object; // CW:: TODO:
		internal var domNormalizer:Object; // CW:: TODO:
		internal var domConfiguration:Object; // CW:: TODO:
		internal var xPathEvaluator:Object; // CW:: TODO:

		internal var _changes:int = 0;
		internal var allowGrammarAccess:Boolean;
		internal var xmlVersionChanged:Boolean = false;
		internal var xml11Version:Boolean = false;
		
		private var documentNumber:int = 0;
		private var nodeCounter:int = 0;
		private var nodeTable:Dictionary;
		
		internal var freeNLCache:NodeListCache;
		
		internal static const XML_URI:String = "http://www.w3.org/XML/1998/namespace";
		internal static const XMLNS_URI:String = "http://www.w3.org/2000/xmlns/";
		
		private static var kidOK:Array = initKidOK();
		private static function initKidOK():Array {
			var arr:Array = [];
			arr[DOCUMENT_NODE] = 
				1 << ELEMENT_NODE | 
				1 << PROCESSING_INSTRUCTION_NODE | 
				1 << COMMENT_NODE | 
				1 << DOCUMENT_TYPE_NODE;
			arr[DOCUMENT_FRAGMENT_NODE] =
			arr[ENTITY_NODE] =
			arr[ENTITY_REFERENCE_NODE] =
			arr[ELEMENT_NODE] =
				1 << ELEMENT_NODE |
				1 << PROCESSING_INSTRUCTION_NODE |
				1 << COMMENT_NODE |
				1 << TEXT_NODE |
				1 << CDATA_SECTION_NODE |
				1 << ENTITY_REFERENCE_NODE;
			arr[ATTRIBUTE_NODE] =
				1 << TEXT_NODE |
				1 << ENTITY_REFERENCE_NODE;
			arr[DOCUMENT_TYPE_NODE] =
			arr[PROCESSING_INSTRUCTION_NODE] =
			arr[COMMENT_NODE] =
			arr[TEXT_NODE] =
			arr[CDATA_SECTION_NODE] =
			arr[NOTATION_NODE] =
				0;
			return arr;
		}
		
		public function DocumentImpl(doctype:DocumentType = null, grammarAccess:Boolean = false)
		{
			super(null);
			_ownerDocument = this;
			allowGrammarAccess = grammarAccess;
			if(doctype != null) {
				var doctypeImpl:DocumentTypeImpl = doctype as DocumentTypeImpl;
				if(doctypeImpl == null) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
				doctypeImpl._ownerDocument = this;
				appendChild(doctype);
			}
		}
		
		override public function get ownerDocument():Document {
			return null;
		}

		override public function get nodeType():int {
			return DOCUMENT_NODE;
		}

		override public function get nodeName():String {
			return "#document";
		}

		override public function cloneNode(deep:Boolean):Node {
			var newDoc:DocumentImpl = new DocumentImpl();
			callUserDataHandlers(this, newDoc, 1 /*UserDataHandler.NODE_CLONED*/); // CW:: REVISIT:
			cloneNodeInternal(newDoc, deep);
			return newDoc;
		}

		protected function cloneNodeInternal(newDoc:DocumentImpl, deep:Boolean):void {
			// clone the children by importing them
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			if(deep) {
				var reversedIdentifiers:Dictionary;
				if(identifiers != null) {
					// Build a reverse mapping from element to identifier.
					reversedIdentifiers = new Dictionary();
					for(var elementId:String in identifiers) {
						reversedIdentifiers[elementId] = identifiers[elementId];
					}
				}
				// CW:: TODO:
				// Copy children into new document.
				//for(var child:ChildNode = firstChild; child != null; child = child.nextSibling) {
				//	newDoc.appendChild(newDoc.importNode(child, true, true, reversedIdentifiers));
				//}
			}
			// experimental
			newDoc.allowGrammarAccess = allowGrammarAccess;
			newDoc.errorChecking = errorChecking;
		}

		override public function insertBefore(newChild:Node, refChild:Node):Node {
			// Only one such child permitted
			var type:int = newChild.nodeType;
			if(errorChecking) {
				if(needsSyncChildren) {
					synchronizeChildren();
				}
				if((type == ELEMENT_NODE && _docElement != null) || (type == DOCUMENT_TYPE_NODE && _docType != null)) {
					throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
				}
			}
			// Adopt orphan doctypes
			if(newChild.ownerDocument == null && newChild is DocumentTypeImpl) {
				DocumentTypeImpl(newChild).ownerDocumentInternal = this;
			}
			super.insertBefore(newChild, refChild);
			// If insert succeeded, cache the child appropriately
			if(type == ELEMENT_NODE) {
				_docElement = newChild as ElementImpl;
			} else if(type == DOCUMENT_TYPE_NODE) {
				_docType = newChild as DocumentTypeImpl;
			}
			return newChild;
		}

		override public function removeChild(oldChild:Node):Node {
			super.removeChild(oldChild);
			// If remove succeeded, un-cache the kid appropriately
			var type:int = oldChild.nodeType;
			if(type == ELEMENT_NODE) {
				_docElement = null;
			} else if(type == DOCUMENT_TYPE_NODE) {
				_docType = null;
			}
			return oldChild;
		}

		override public function replaceChild(newChild:Node, oldChild:Node):Node {
			// Adopt orphan doctypes
			if(newChild.ownerDocument == null && newChild is DocumentTypeImpl) {
				DocumentTypeImpl(newChild).ownerDocumentInternal = this;
			}
			if(errorChecking &&
				((_docType != null && 
					oldChild.nodeType != DOCUMENT_TYPE_NODE && 
					newChild.nodeType == DOCUMENT_TYPE_NODE) ||
				(_docElement != null && 
					oldChild.nodeType != ELEMENT_NODE && 
					newChild.nodeType == ELEMENT_NODE)))
			{
				throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
			}
			super.replaceChild(newChild, oldChild);
			var type:int = oldChild.nodeType;
			if(type == ELEMENT_NODE) {
				_docElement = newChild as ElementImpl;
			} else if(type == DOCUMENT_TYPE_NODE) {
				_docType = newChild as DocumentTypeImpl;
			}
			return oldChild;
		}
		
		override public function get textContent():String {
			return null;
		}
		
		override public function set textContent(value:String):void {
			// Do nothing.
		}

		override public function getFeature(feature:String, version:String):* {
			// CW:: TODO:
			return super.getFeature(feature, version);
		}


		internal function set mutationEvents(value:Boolean):void {
			// does nothing by default - overidden in subclass
		}
		
		internal function get mutationEvents():Boolean {
			// does nothing by default - overriden in subclass
			return false;
		}


		public function createAttribute(name:String):Attr {
			if(errorChecking && !isXMLName(name, xml11Version)) {
				throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
			}
			return new AttrImpl(this, name);
		}
		
		public function createElement(tagName:String):Element {
			if(errorChecking && !isXMLName(tagName, xml11Version)) {
				throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
			}
			return new ElementImpl(this, tagName);
		}
		
		public function createElementNS(namespaceURI:String, qualifiedName:String):Element {
			return new ElementNSImpl(this, namespaceURI, qualifiedName);
		}
		
		public function createDocumentFragment():DocumentFragment {
			return new DocumentFragmentImpl(this);
		}

		public function createTextNode(data:String):Text {
			return new TextImpl(this, data);
		}

		public function createComment(data:String):Comment {
			return new CommentImpl(this, data);
		}
		
		public function createCDATASection(data:String):CDATASection {
			return new CDATASectionImpl(this, data);
		}
		
		public function createProcessingInstruction(target:String, data:String):ProcessingInstruction {
			if(errorChecking && !isXMLName(target, xml11Version)) {
				throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
			}
			return new ProcessingInstructionImpl(this, target, data);
		}
		
		public function createAttributeNS(namespaceURI:String, qualifiedName:String):Attr {
			return new AttrNSImpl(this, namespaceURI, qualifiedName);
		}
		
		public function createEntityReference(name:String):EntityReference {
			if(errorChecking && !isXMLName(name, xml11Version)) {
				throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
			}
			return new EntityReferenceImpl(this, name);
		}


		public function get doctype():DocumentType {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return _docType;
		}
		
		public function get documentElement():Element {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return _docElement;
		}

		public function getElementsByTagName(tagname:String):NodeList {
			// CW:: TODO:
			return null;
		}

		public function get implementation():DOMImplementation {
			return DOMImplementationImpl.getInstance();
		}
		
		public function set errorChecking(check:Boolean):void {
			_errorChecking = check;
		}
		
		public function set strictErrorChecking(value:Boolean):void {
			_errorChecking = value;
		}
		
		public function get errorChecking():Boolean {
			return _errorChecking;
		}

		public function get strictErrorChecking():Boolean {
			return _errorChecking;
		}
		
		public function get inputEncoding():String {
			return _actualEncoding;
		}
		
		internal function set inputEncoding(value:String):void {
			_actualEncoding = value;
		}
		
		internal function set xmlEncoding(value:String):void {
			_encoding = value;
		}
		
		public function get xmlEncoding():String {
			return _encoding;
		}
		
		public function set xmlVersion(value:String):void {
			if(value == "1.0" || value == "1.1") {
				// We need to change the flag value only --
				// when the version set is different than already set.
				if(xmlVersion != value) {
					xmlVersionChanged = true;
					// Change the normalization value back to false
					isNormalized = false;
					_version = value;
				}
			} else {
				// We dont support any other XML version
				throw new DOMException(DOMException.NOT_SUPPORTED_ERR);
			}
			xml11Version = (xmlVersion == "1.1");
		}
		
		public function get xmlVersion():String {
			return (_version == null) ? "1.0" : _version;
		}

		public function set xmlStandalone(value:Boolean):void {
			_standalone = value;
		}
		
		public function get xmlStandalone():Boolean {
			return _standalone;
		}

		public function get documentURI():String {
			return _documentURI;
		}
		
		public function set documentURI(value:String):void {
			_documentURI = value;
		}

		public function renameNode(node:Node, nsURI:String, name:String):Node {
			if(errorChecking && node.ownerDocument != this && node != this) {
				throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
			}
			switch(node.nodeType) {
				// CW:: TODO:
				// implement 
				// - copyEventListeners
				// - ElementImpl 
				// - ElementNSImpl
				// - AttrImpl
				// - AttrNSImpl
				// etc
				
				/*
				case NodeImpl.ELEMENT_NODE:
					var eli:ElementImpl = node as ElementImpl;
					if(eli is ElementNSImpl) {
						ElementNSImpl(eli).rename(nsURI, name);
						// fire user data NODE_RENAMED event
						callUserDataHandlers(eli, null, UserDataHandler.NODE_RENAMED);
					} else {
						if(nsURI == null) {
							if(errorChecking) {
								var colon1:int = name.indexOf(':');
								if(colon1 != -1) {
									throw new DOMException(DOMException.NAMESPACE_ERR);
								}
								if(!isXMLName(name, xml11Version)) {
									throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
								}
							}
							eli.rename(name);
							// fire user data NODE_RENAMED event
							callUserDataHandlers(eli, null, UserDataHandler.NODE_RENAMED);
						} else {
							// we need to create a new object
							var neli:ElementNSImpl = new ElementNSImpl(this, nsURI, name);
							// register event listeners on new node
							copyEventListeners(eli, neli);
							// remove user data from old node
							var data:Dictionary = removeUserDataTable(eli);
							// remove old node from parent if any
							var parent:Node = eli.parentNode;
							var nextSib:Node = eli.nextSibling;
							if(parent != null) {
								parent.removeChild(eli);
							}
							// move children to new node
							var child:Node = eli.firstChild;
							while(child != null) {
								eli.removeChild(child);
								neli.appendChild(child);
								child = eli.firstChild;
							}
							// move specified attributes to new node
							neli.moveSpecifiedAttributes(eli);
							// attach user data to new node
							setUserDataTable(neli, data);
							// and fire user data NODE_RENAMED event
							callUserDataHandlers(eli, neli, UserDataHandler.NODE_RENAMED);
							// insert new node where old one was
							if(parent != null) {
								parent.insertBefore(neli, nextSib);
							}
							eli = neli;
						}
					}
					// fire ElementNameChanged event
					renamedElement(Element(node), eli);
					return eli;

				case NodeImpl.ATTRIBUTE_NODE:
					var at:AttrImpl = node as AttrImpl;
					// detach attr from element
					var el:Element = at.ownerElement;
					if(el != null) {
						el.removeAttributeNode(at);
					}
					if(node is AttrNSImpl) {
						AttrNSImpl(at).rename(nsURI, name);
						// reattach attr to element
						if(el != null) {
							el.setAttributeNodeNS(at);
						}
						// fire user data NODE_RENAMED event
						callUserDataHandlers(at, null, UserDataHandler.NODE_RENAMED);
					} else {
						if(nsURI == null) {
							at.rename(name);
							// reattach attr to element
							if(el != null) {
								el.setAttributeNode(at);
							}
							// fire user data NODE_RENAMED event
							callUserDataHandlers(at, null, UserDataHandler.NODE_RENAMED);
						} else {
							// we need to create a new object
							var nat:AttrNSImpl = new AttrNSImpl(this, nsURI, name);
							// register event listeners on new node
							copyEventListeners(at, nat);
							// remove user data from old node
							var data:Dictionary = removeUserDataTable(at);
							// move children to new node
							var child:Node = at.firstChild;
							while(child != null) {
								at.removeChild(child);
								nat.appendChild(child);
								child = at.firstChild;
							}
							// attach user data to new node
							setUserDataTable(nat, data);
							// and fire user data NODE_RENAMED event
							callUserDataHandlers(at, nat, UserDataHandler.NODE_RENAMED);
							// reattach attr to element
							if(el != null) {
								el.setAttributeNode(nat);
							}
							at = nat;
						}
					}
					// fire AttributeNameChanged event
					renamedAttrNode(Attr(node), at);
					return at;
				*/
				default:
					throw new DOMException(DOMException.NOT_SUPPORTED_ERR);
			}
		}
		
		public function normalizeDocument():void {
			// CW:: TODO:
		}
		
		public function get config():DOMConfiguration {
			// CW:: TODO:
			return null;
		}
		
		override public function get baseURI():String {
			// Note: attribute value is always empty string
			if(_documentURI != null && _documentURI.length != 0) {
				// CW:: TODO:
				//try {
				//	return new URI(_documentURI).toString();
				//}
				//catch (org.apache.xerces.util.URI.MalformedURIException e){
				//	// REVISIT: what should happen in this case?
				//	return null;
				//}
			}            
			return _documentURI;
		}
		


		public function getElementsByTagNameNS(namespaceURI:String, localName:String):NodeList {
			// CW:: TODO:
			return null;
		}
		
		public function getElementById(elementId:String):Element {
			// CW:: TODO:
			return null;
		}
		
		public function importNode(importedNode:Node, deep:Boolean):Node {
			// CW:: TODO:
			return null;
		}
		
		public function adoptNode(source:Node):Node {
			// CW:: TODO:
			return null;
		}
		
		
		internal function clearIdentifiers():void {
			if(identifiers != null) {
				identifiers = new Dictionary();
			}
		}

		public function putIdentifier(idName:String, element:Element):void {
			if(element == null) {
				removeIdentifier(idName);
				return;
			}
			if(needsSyncData) {
				synchronizeData();
			}
			if(identifiers == null) {
				identifiers = new Dictionary();
			}
			identifiers[idName] = element;
		}

		public function getIdentifier(idName:String):Element {
			if(needsSyncData) {
				synchronizeData();
			}
			if(identifiers == null) {
				return null;
			}
			var elem:Element = identifiers[idName] as Element;
			if(elem != null) {
				// check that the element is in the tree
				var parent:Node = elem.parentNode;
				while(parent != null) {
					if(parent == this) {
						return elem;
					}
					parent = parent.parentNode;
				}
			}
			return null;
		}
		
		public function removeIdentifier(idName:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			if(identifiers == null) {
				return;
			}
			delete identifiers[idName];
		}

		public function getIdentifiers():Array {
			if(needsSyncData) {
				synchronizeData();
			}
			if(identifiers == null) {
				identifiers = new Dictionary();
			}
			var keys:Array = [];
			for(var key:String in identifiers) {
				keys.push(key);
			}
			return keys;
		}
		
		
		internal function replacedText(node:NodeImpl):void {
		}

		internal function deletedText(node:NodeImpl, offset:int, count:int):void {
		}

		internal function insertedText(node:NodeImpl, offset:int, count:int):void {
		}

		internal function modifyingCharacterData(node:NodeImpl, replace:Boolean):void {
		}

		internal function modifiedCharacterData(node:NodeImpl, oldvalue:String, value:String, replace:Boolean):void {
		}

		internal function insertingNode(node:NodeImpl, replace:Boolean):void {
		}

		internal function insertedNode(node:NodeImpl, newInternal:NodeImpl, replace:Boolean):void {
		}

		internal function removingNode(node:NodeImpl, oldChild:NodeImpl, replace:Boolean):void {
		}

		internal function removedNode(node:NodeImpl, replace:Boolean):void {
		}

		internal function replacingNode(node:NodeImpl):void {
		}

		internal function replacedNode(node:NodeImpl):void {
		}

		internal function replacingData(node:NodeImpl):void {
		}
		
		internal function replacedCharacterData(node:NodeImpl, oldvalue:String, value:String):void {
		}
		
		internal function modifiedAttrValue(attr:AttrImpl, oldvalue:String):void {
		}
		
		internal function setAttrNode(attr:AttrImpl, previous:AttrImpl):void {
		}
		
		internal function removedAttrNode(attr:AttrImpl, oldOwner:NodeImpl, name:String):void {
		}
		
		internal function renamedAttrNode(oldAt:Attr, newAt:Attr):void {
		}
		
		internal function renamedElement(oldEl:Element, newEl:Element):void {
		}


		public static function isXMLName(s:String, xml11Version:Boolean):Boolean {
			if(s == null) {
				return false;
			}
			if(!xml11Version) {
				return XMLChar.isValidName(s);
			} else {
				return XML11Char.isXML11ValidName(s);
			}
		}

		internal function isKidOK(parent:Node, child:Node):Boolean {
			if(allowGrammarAccess && parent.nodeType == DOCUMENT_TYPE_NODE) {
				return (child.nodeType == ELEMENT_NODE);
			}
			return ((kidOK[parent.nodeType] & (1 << child.nodeType)) != 0);
		}

		override internal function changed():void {
			_changes++;
		}

		internal function changes():int {
			return _changes;
		}

		public function setUserDataForNode(n:Node, key:String, data:Object, handler:UserDataHandler):Object {
			var t:Dictionary;
			var o:UserDataRecord;
			if(data == null) {
				if(userData != null) {
					t = userData[n] as Dictionary;
					if(t != null) {
						o = t[key] as UserDataRecord;
						delete t[key];
						return (o != null) ? o.data : null;
					}
				}
				return null;
			} else {
				if(userData == null) {
					userData = new Dictionary(true);
					t = new Dictionary(true);
					userData[n] = t;
				} else {
					t = userData[n] as Dictionary;
					if(t == null) {
						t = new Dictionary(true);
						userData[n] = t;
					}
				}
				o = t[key] as UserDataRecord;
				t[key] = new UserDataRecord(data, handler);
				return (o != null) ? o.data : null;
			}
		}
		
		public function getUserDataForNode(n:Node, key:String):Object {
			if(userData == null) {
				return null;
			}
			var t:Dictionary = userData[n] as Dictionary;
			if(t == null) {
				return null;
			}
			var o:UserDataRecord = t[key] as UserDataRecord;
			return (o != null) ? o.data : null;
		}
		
		internal function getUserDataRecordForNode(n:Node):Dictionary {
			if(userData == null) {
				return null;
			}
			var t:Dictionary = userData[n] as Dictionary;
			if(t == null) {
				return null;
			}
			return t;
		}

		internal function removeUserDataTable(n:Node):Dictionary {
			if(userData == null) {
				return null;
			}
			var userDataTable:Dictionary = userData[n] as Dictionary;
			delete userData[n];
			return userDataTable;
		}

		internal function setUserDataTable(n:Node, data:Dictionary):void {
			if(userData == null) {
				userData = new Dictionary(true);
			}
			if(data != null) {
				userData[n] = data;
			}
		}

		internal function callUserDataHandlers(n:Node, c:Node, operation:uint, data:Dictionary = null):void {
			// CW:: REVISIT:
			// I was stoned when i ported this. Revisit!!
			// Check CoreDocumentImpl.java:
			// - protected void callUserDataHandlers(Node n, Node c, short operation) {
			// - void callUserDataHandlers(Node n, Node c, short operation, Hashtable userData) {
			if(data == null) {
				return;
			}
			if(n is NodeImpl) {
				var t:Dictionary = NodeImpl(n).getUserDataRecord();
				if(t == null) {
					return;
				}
				for(var key:String in t) {
					var r:UserDataRecord = data[key] as UserDataRecord;
					if(r.handler != null) {
						r.handler.handle(operation, key, r.data, n, c);
					}
				}
			}
		}

		internal function getNodeNumber(node:Node):int {
			// Check if the node is already in the hash
			// If so, retrieve the node number
			// If not, assign a number to the node
			// Node numbers are negative, from -1 to -n
			var num:int;
			if (nodeTable == null) {
				nodeTable = new Dictionary(true);
				num = --nodeCounter;
				nodeTable[node] = num;
			} else {
				if (nodeTable[node] == undefined) {
					num = --nodeCounter;
					nodeTable[node] = num;
				} else {
					num = nodeTable[node];
				}
			}
			return num;
		}
		
		internal function getNodeListCache(owner:ParentNode):NodeListCache {
			if(freeNLCache == null) {
				return new NodeListCache(owner);
			}
			var c:NodeListCache = freeNLCache;
			freeNLCache = freeNLCache.next;
			c.child = null;
			c.childIndex = -1;
			c.length = -1;
			// revoke previous ownership
			if(c.owner != null) {
				c.owner.nodeListCache = null;
			}
			c.owner = owner;
			// c.next = null; not necessary, except for confused people...
			return c;
		}
		
		
		internal function checkNamespaceWF(qName:String, colon1:int, colon2:int):void {
			if(!errorChecking) {
				return;
			}
			// it is an error for NCName to have more than one ':'
			// check if it is valid QName [Namespace in XML production 6]
			// :camera , nikon:camera:minolta, camera:
			if(colon1 == 0 || colon1 == qName.length - 1 || colon2 != colon1) {
				throw new DOMException(DOMException.NAMESPACE_ERR);
			}
		}

		internal function checkDOMNSErr(pre:String, ns:String):void {
			if(errorChecking) {
				if(ns == null) {
					throw new DOMException(DOMException.NAMESPACE_ERR);
				} else if(pre == "xml" && ns != XML_URI) {
					throw new DOMException(DOMException.NAMESPACE_ERR);
				} else if(pre == "xmlns" && ns != XMLNS_URI || 
						 (pre != "xmlns" && ns == XMLNS_URI)) {
					throw new DOMException(DOMException.NAMESPACE_ERR);
				}
			}
		}
		
		internal function checkQName(pre:String, local:String):void {
			if(!errorChecking) {
				return;
			}
			// check that both prefix and local part match NCName
			var validNCName:Boolean = false;
			if(!xml11Version) {
				validNCName = (pre == null || XMLChar.isValidNCName(pre)) && XMLChar.isValidNCName(local);
			} else {
				validNCName = (pre == null || XML11Char.isXML11ValidNCName(pre)) && XML11Char.isXML11ValidNCName(local);
			}
			if (!validNCName) {
				// REVISIT: add qname parameter to the message
				throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
			}
		}
		
		internal function isXML11Version():Boolean {
			return xml11Version;
		}
	}
}
