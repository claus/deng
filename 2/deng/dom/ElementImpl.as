package deng.dom
{
	import org.w3c.dom.*;
	import flash.net.registerClassAlias;

	public class ElementImpl extends ParentNode implements Element, TypeInfo
	{
		internal var _name:String;
		internal var _attributes:AttributeMap;
		
		public function ElementImpl(owner:DocumentImpl, name:String)
		{
			registerClassAlias("deng.dom.ElementImpl", ElementImpl);
			super(owner);
			_name = name;
			needsSyncData = true;
		}


		internal function rename(name:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			_name = name;
			reconcileDefaultAttributes();
		}

		override public function get nodeType():int {
			return NodeImpl.ELEMENT_NODE;
		}

		override public function get nodeName():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _name;
		}
		
		override public function get attributes():NamedNodeMap {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				_attributes = new AttributeMap(this, null);
			}
			return _attributes;
		}

		override public function cloneNode(deep:Boolean):Node {
			var newnode:ElementImpl = super.cloneNode(deep) as ElementImpl;
			// Replicate NamedNodeMap rather than sharing it.
			if(_attributes != null) {
				newnode._attributes = _attributes.cloneMap(newnode) as AttributeMap;
			}
			return newnode;
		}

		override public function get baseURI():String {
			if(needsSyncData) {
				synchronizeData();
			}
			// Absolute base URI is computed according to 
			// XML Base (http://www.w3.org/TR/xmlbase/#granularity)
			// 1. The base URI specified by an xml:base attribute on the element, 
			// if one exists
			if(_attributes != null) {
				var attrNode:Attr = _attributes.getNamedItem("xml:base") as Attr;
				if(attrNode != null) {
					var uri:String =  attrNode.nodeValue;
					if(uri.length != 0 ) {
						// CW:: TODO:
						/*
						// attribute value is always empty string
						try {
							uri = new URI(uri).toString();
						}
						catch (org.apache.xerces.util.URI.MalformedURIException e) {
							// This may be a relative URI.
							// Make any parentURI into a URI object to use with the URI(URI, String) constructor
							var parentBaseURI:String = (_ownerNode != null) ? _ownerNode.baseURI : null;
							if(parentBaseURI != null) {
								try {
									uri = new URI(new URI(parentBaseURI), uri).toString();
								}
								catch (org.apache.xerces.util.URI.MalformedURIException ex) {
									// This should never happen:
									// parent should have checked the URI 
									// and returned null if invalid.
									return null;
								}
								return uri;
							}
							return null;
						}
						*/
						return uri;
					}
				}
			}
			// 2.the base URI of the element's parent element within the 
			// document or external entity, if one exists 
			// 3. the base URI of the document entity or external entity 
			// containing the element
			// _ownerNode serves as a parent or as document
			var baseuri:String = (_ownerNode != null) ? _ownerNode.baseURI : null;
			//base URI of parent element is not null
			if(baseuri != null) {
				// CW:: TODO:
				/*
				try {
					//return valid absolute base URI
					return new URI(baseuri).toString();
				}
				catch (org.apache.xerces.util.URI.MalformedURIException e) {
					return null;
				}
				*/
			}
			return null;
		}

		override internal function set ownerDocumentInternal(doc:DocumentImpl):void {
			super.ownerDocumentInternal = doc;
			if(_attributes != null) {
				_attributes.ownerDocumentInternal = doc;
			}
		}


		public function getAttribute(name:String):String {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return "";
			}
			var attr:Attr = _attributes.getNamedItem(name) as Attr;
			return (attr == null) ? "" : attr.value;
		}
		
		public function getAttributeNode(name:String):Attr {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return null;
			}
			return _attributes.getNamedItem(name) as Attr;
		}
		
		public function getElementsByTagName(name:String):NodeList {
			// CW:: TODO:
			//return new DeepNodeListImpl(this, name);
			return null;
		}
		
		public function get tagName():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _name;
		}
		
		override public function normalize():void {
			// No need to normalize if already normalized.
			if(isNormalized) {
				return;
			}
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			var kid:ChildNode
			var next:ChildNode;
			for(kid = _firstChild; kid != null; kid = next) {
				next = kid._nextSibling;
				// If kid is a text node, we need to check for one of two
				// conditions:
				//   1) There is an adjacent text node
				//   2) There is no adjacent text node, but kid is
				//      an empty text node.
				if(kid.nodeType == NodeImpl.TEXT_NODE) {
					// If an adjacent text node, merge it with kid
					if(next != null && next.nodeType == NodeImpl.TEXT_NODE) {
						Text(kid).appendData(next.nodeValue);
						removeChild(next);
						next = kid; // Don't advance; there might be another.
					} else {
						// If kid is empty, remove it
						if(kid.nodeValue == null || kid.nodeValue.length == 0) {
							removeChild(kid);
						}
					}
				} else if(kid.nodeType == NodeImpl.ELEMENT_NODE) {
					// Otherwise it might be an Element, which is handled recursively
					kid.normalize();
				}
			}
			// We must also normalize all of the attributes
			if(_attributes != null) {
				for(var i:int = 0; i < _attributes.length; ++i) {
					var attr:Node = _attributes.item(i);
					attr.normalize();
				}
			}
			// changed() will have occurred when the removeChild() was done,
			// so does not have to be reissued.
			isNormalized = true;
		}

		public function removeAttribute(name:String):void {
			if(_ownerDocument.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return;
			}
			_attributes.safeRemoveNamedItem(name);
		}

		public function removeAttributeNode(oldAttr:Attr):Attr {
			if(_ownerDocument.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			return _attributes.removeItem(oldAttr, true) as Attr;
		}
		
		public function setAttribute(name:String, value:String):void {
			if(_ownerDocument.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			var newAttr:Attr = getAttributeNode(name);
			if(newAttr == null) {
				newAttr = ownerDocument.createAttribute(name);
				if(_attributes == null) {
					_attributes = new AttributeMap(this, null);
				}
				newAttr.nodeValue = value;
				attributes.setNamedItem(newAttr);
			} else {
				newAttr.nodeValue = value;
			}
		}
		
		public function setAttributeNode(newAttr:Attr):Attr {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_ownerDocument.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(newAttr.ownerDocument != _ownerDocument) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
			}
			if(_attributes == null) {
				_attributes = new AttributeMap(this, null);
			}
			// This will throw INUSE if necessary
			return attributes.setNamedItem(newAttr) as Attr;
		}
		
		public function getAttributeNS(nsURI:String, locName:String):String {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return "";
			}
			var attr:Attr = _attributes.getNamedItemNS(nsURI, locName) as Attr;
			return (attr == null) ? "" : attr.value;
		}
		
		public function setAttributeNS(nsURI:String, qName:String, value:String):void {
			if(_ownerDocument.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			var index:int = qName.indexOf(':');
			var pre:String;
			var local:String;
			if(index < 0) {
				pre = null;
				local = qName;
			} else {
				pre = qName.substring(0, index);
				local = qName.substring(index + 1);
			}
			var newAttr:Attr = getAttributeNodeNS(nsURI, local);
			if(newAttr == null) {
				// REVISIT: this is not efficient, we are creating twice the same
				//          strings for prefix and localName.
				newAttr = ownerDocument.createAttributeNS(nsURI, qName);
				if(_attributes == null) {
					_attributes = new AttributeMap(this, null);
				}
				newAttr.nodeValue = value;
				_attributes.setNamedItemNS(newAttr);
			} else {
				if(newAttr is AttrNSImpl) {
					// change prefix and value
					AttrNSImpl(newAttr)._name = (pre != null) ? (pre + ":" + local) : local;
				} else {
					// This case may happen if user calls:
					//      elem.setAttribute("name", "value");
					//      elem.setAttributeNS(null, "name", "value");
					// This case is not defined by the DOM spec, we choose
					// to create a new attribute in this case and remove an old one from the tree
					// note this might cause events to be propagated or user data to be lost 
					newAttr = new AttrNSImpl(DocumentImpl(ownerDocument), nsURI, qName, local);
					_attributes.setNamedItemNS(newAttr);
				}
				newAttr.nodeValue = value;
			}
		}
		
		public function removeAttributeNS(nsURI:String, locName:String):void {
			if(_ownerDocument.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return;
			}
			_attributes.safeRemoveNamedItemNS(nsURI, locName);
		}
		
		public function getAttributeNodeNS(nsURI:String, locName:String):Attr {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return null;
			}
			return _attributes.getNamedItemNS(nsURI, locName) as Attr;
		}
		
		public function setAttributeNodeNS(newAttr:Attr):Attr {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_ownerDocument.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(newAttr.ownerDocument != _ownerDocument) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
			}
			if(_attributes == null) {
				_attributes = new AttributeMap(this, null);
			}
			// This will throw INUSE if necessary
			return _attributes.setNamedItemNS(newAttr) as Attr;
		}

		internal function setXercesAttributeNode(attr:Attr):int {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				_attributes = new AttributeMap(this, null);
			}
			return _attributes.addItem(attr);
		
		}

		internal function getXercesAttribute(nsURI:String, locName:String):int {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_attributes == null) {
				return -1;
			}
			return _attributes.getNamedItemIndex(nsURI, locName);
		}

		override public function hasAttributes():Boolean {
	        if(needsSyncData) {
	            synchronizeData();
    	    }
        	return (_attributes != null && _attributes.length != 0);
		}
		
		public function hasAttribute(name:String):Boolean {
			return (getAttributeNode(name) != null);
		}
		
		public function hasAttributeNS(nsURI:String, locName:String):Boolean {
			return (getAttributeNodeNS(nsURI, locName) != null);
		}

		public function getElementsByTagNameNS(nsURI:String, locName:String):NodeList {
			// CW:: TODO:
			//return new DeepNodeListImpl(this, nsURI, locName);
			return null;
		}
		
		override public function isEqualNode(arg:Node):Boolean {
			if(!super.isEqualNode(arg)) {
				return false;
			}
			var hasAttrs:Boolean = hasAttributes();
			if(hasAttrs != Element(arg).hasAttributes()) {
				return false;
			}
			if(hasAttrs) {
				var map1:NamedNodeMap = attributes;
				var map2:NamedNodeMap = Element(arg).attributes;
				var len:int = map1.length;
				if(len != map2.length) {
					return false;
				}
				for(var i:int = 0; i < len; i++) {
					var n1:Node = map1.item(i);
					var n2:Node;
					if(n1.localName == null) {
						// DOM Level 1 Node
						n2 = map2.getNamedItem(n1.nodeName);
						if(n2 == null || !NodeImpl(n1).isEqualNode(n2)) {
							return false;
						}
					} else {
						n2 = map2.getNamedItemNS(n1.namespaceURI, n1.localName);
						if(n2 == null || !NodeImpl(n1).isEqualNode(n2)) {
							return false;
						}
					}
				}
			}
			return true;
		}


		public function setIdAttributeNode(idAttr:Attr, isId:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_ownerDocument.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(idAttr.ownerElement != this) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				}
			}
			AttrImpl(idAttr).isIdAttribute = isId;
			if(!isId) {
				_ownerDocument.removeIdentifier(idAttr.value);
			} else {
				_ownerDocument.putIdentifier(idAttr.value, this);
			}
		}
		
		public function setIdAttribute(name:String, isId:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			var at:Attr = getAttributeNode(name);
			if(at == null) {
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			if(_ownerDocument.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(at.ownerElement != this) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				}
			}
			AttrImpl(at).isIdAttribute = isId;
			if(!isId) {
				_ownerDocument.removeIdentifier(at.value);
			} else {
				_ownerDocument.putIdentifier(at.value, this);
			}
		}

		public function setIdAttributeNS(nsURI:String, locName:String, isId:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			var at:Attr = getAttributeNodeNS(nsURI, locName);
			if(at == null) {
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			if(_ownerDocument.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(at.ownerElement != this) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				}
			}
			AttrImpl(at).isIdAttribute = isId;
			if(!isId) {
				_ownerDocument.removeIdentifier(at.value);
			} else {
				_ownerDocument.putIdentifier(at.value, this);
			}
		}
		
		public function get typeName():String {
			return null;
		}
		
		public function get typeNamespace():String {
			return null;
		}

		public function isDerivedFrom(typeNamespaceArg:String, typeNameArg:String, derivationMethod:int):Boolean {
			return false;
		}

		public function get schemaTypeInfo():TypeInfo {
			if(needsSyncData) {
				synchronizeData();
			}
			return this;
		}
		
		override public function setReadOnly(readOnly:Boolean, deep:Boolean):void {
			super.setReadOnly(readOnly, deep);
			if(_attributes != null) {
				_attributes.setReadOnly(readOnly, true);
			}
		}

		override internal function synchronizeData():void {
			// no need to sync in the future
			needsSyncData = false;
			// we don't want to generate any event for this so turn them off
			var orig:Boolean = _ownerDocument.mutationEvents;
			_ownerDocument.mutationEvents = false;
			// attributes
			setupDefaultAttributes();
			// set mutation events flag back to its original value
			_ownerDocument.mutationEvents = orig;
		}

		internal function moveSpecifiedAttributes(el:ElementImpl):void {
			if(needsSyncData) {
				synchronizeData();
			}
			if(el.hasAttributes()) {
				if(_attributes == null) {
					_attributes = new AttributeMap(this, null);
				}
				_attributes.moveSpecifiedAttributes(el._attributes);
			}
		}
		
		internal function setupDefaultAttributes():void {
			var defaults:NamedNodeMapImpl = getDefaultAttributes();
			if(defaults != null) {
				_attributes = new AttributeMap(this, defaults);
			}
		}
		
		internal function reconcileDefaultAttributes():void {
			if(_attributes != null) {
				var defaults:NamedNodeMapImpl = getDefaultAttributes();
				_attributes.reconcileDefaults(defaults);
			}
		}
		
		internal function getDefaultAttributes():NamedNodeMapImpl {
			var doctype:DocumentTypeImpl = _ownerDocument.doctype as DocumentTypeImpl;
			if(doctype == null) {
				return null;
			}
			// CW:: TODO:
			/*
			var eldef:ElementDefinitionImpl = doctype.elements.getNamedItem(nodeName) as ElementDefinitionImpl;
			if(eldef == null) {
				return null;
			}
			return eldef.attributes as NamedNodeMapImpl;
			*/
			return null;
		}
	}
}