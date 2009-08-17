package deng.dom
{
	import deng.dom.*;
	import org.w3c.dom.Attr;
	
	public class ElementNSImpl extends ElementImpl
	{
		public static var XMLURI:String = "http://www.w3.org/XML/1998/namespace";
		
		internal var _namespaceURI:String;
		internal var _localName:String;
		internal var _type:Object; // CW:: TODO: make that an XSTypeDefinition
		
		public function ElementNSImpl(owner:DocumentImpl, nsURI:String, qName:String, locName:String = null)
		{
			super(owner, qName);
			if(locName == null) {
				setName(nsURI, qName);
			} else {
				_namespaceURI = nsURI;
				_localName = locName;
			}
		}

		internal function setName(nsURI:String, qName:String):void {
			var pre:String;
			// DOM Level 3: namespace URI is never empty string.
			_namespaceURI = nsURI;
			if(nsURI != null) {
				//convert the empty string to 'null'
				_namespaceURI =	(nsURI.length == 0) ? null : nsURI;
			}
			var colon1:int;
			var colon2:int;
			//NAMESPACE_ERR:
			//1. if the qualified name is 'null' it is malformed.
			//2. or if the qualifiedName is null and the namespaceURI is different from null,
			// We dont need to check for namespaceURI != null, if qualified name is null throw DOMException.
			if(qName == null) {
				throw new DOMException(DOMException.NAMESPACE_ERR);
			} else {
				colon1 = qName.indexOf(':');
				colon2 = qName.lastIndexOf(':');
			}
			_ownerDocument.checkNamespaceWF(qName, colon1, colon2);
			if(colon1 < 0) {
				// there is no prefix
				_localName = qName;
				if(_ownerDocument.errorChecking) {
					_ownerDocument.checkQName(null, _localName);
					if(qName == "xmlns" && (nsURI == null || nsURI != DocumentImpl.XMLNS_URI) ||
					  (qName != "xmlns" && nsURI != null && nsURI == DocumentImpl.XMLNS_URI)) {
						throw new DOMException(DOMException.NAMESPACE_ERR);
					}
				}
			} else {
				// there is a prefix
				pre = qName.substring(0, colon1);
				_localName = qName.substring(colon2 + 1);
				// NAMESPACE_ERR:
				// 1. if the qualifiedName has a prefix and the namespaceURI is null,
				// 2. or if the qualifiedName has a prefix that is "xml" and the namespaceURI
				//    is different from " http://www.w3.org/XML/1998/namespace"
				if(_ownerDocument.errorChecking) {
					if(nsURI == null || (pre == "xml" && nsURI != DocumentImpl.XML_URI)) {
						throw new DOMException(DOMException.NAMESPACE_ERR);
					}
					_ownerDocument.checkQName(pre, _localName);
					_ownerDocument.checkDOMNSErr(pre, nsURI);
				}
			}
		}


		override public function get namespaceURI():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _namespaceURI;
		}

		override public function get prefix():String {
			if(needsSyncData) {
				synchronizeData();
			}
			var index:int = _name.indexOf(':');
			return (index < 0) ? null : _name.substring(0, index);
		}

		override public function set prefix(value:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_ownerDocument.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(value != null && value.length != 0) {
					if(!DocumentImpl.isXMLName(value, _ownerDocument.isXML11Version())) {
						throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
					}
					if(_namespaceURI == null || value.indexOf(':') >= 0) {
						throw new DOMException(DOMException.NAMESPACE_ERR);
					} else if(value == "xml") {
						if(_namespaceURI != XMLURI) {
							throw new DOMException(DOMException.NAMESPACE_ERR);
						}
					}
				}
			}
			// update node name with new qualifiedName
			if(value != null && value.length != 0) {
				_name = value + ":" + _localName;
			} else {
				_name = _localName;
			}
		}
		
		override public function get localName():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _localName;
		}

		override public function get baseURI():String {
			if(needsSyncData) {
				synchronizeData();
			}
			// CW:: TODO: implement URI
			/*
			// Absolute base URI is computed according to XML Base (http://www.w3.org/TR/xmlbase/#granularity)
			// 1. the base URI specified by an xml:base attribute on the 
			//    element, if one exists
			if(_attributes != null) {
				var attrNode:Attr = _attributes.getNamedItemNS("http://www.w3.org/XML/1998/namespace", "base") as Attr;
				if(attrNode != null) {
					var uri:String = attrNode.nodeValue;
					if(uri.length != 0) {
						// attribute value is always empty string
						try {
							uri = new URI(uri).toString();
						}
						catch(e:Error) {
							// This may be a relative URI.
							// Start from the base URI of the parent, or if this node has no parent, the owner node.
							var parentOrOwner:NodeImpl = (parentNodeInternal != null) ? parentNodeInternal : _ownerNode;
							// Make any parentURI into a URI object to use with the URI(URI, String) constructor.
							var parentBaseURI:String = (parentOrOwner != null) ? parentOrOwner.baseURI : null;
							if(parentBaseURI != null) {
								try {
									uri = new URI(new URI(parentBaseURI), uri).toString();
								}
								catch(e:Error){
									// This should never happen: parent should have checked the URI and returned null if invalid.
									return null;
								}
								return uri;
							}
							// REVISIT: what should happen in this case?
							return null;
						}
						return uri;
					}
				}
			}
			// 2. the base URI of the element's parent element 
			//    within the document or external entity, if one exists
			var parentElementBaseURI:String = (parentNodeInternal != null) ? parentNodeInternal.baseURI : null;
			//base URI of parent element is not null
			if(parentElementBaseURI != null) {
				try {
					//return valid absolute base URI
					return new URI(parentElementBaseURI).toString();
				}
				catch(e:Error){
					// REVISIT: what should happen in this case?
					return null;
				}
			}
			//3. the base URI of the document entity or external entity containing the element
			var bu:String = (_ownerNode != null) ? _ownerNode.baseURI : null;
			if(bu != null) {
				try {
					//return valid absolute base URI
					return new URI(bu).toString();
				}
				catch(e:Error){
					// REVISIT: what should happen in this case?
					return null;
				}
			}
			*/
			return null;
		}

		override public function get typeName():String {
			if(_type != null) {
				// CW:: TODO: implement XSSimpleTypeDefinition, XSSimpleTypeDecl, XSComplexTypeDecl
				/*
				if(_type is XSSimpleTypeDefinition) {
					return XSSimpleTypeDecl(_type).typeName;
				} else {
					return XSComplexTypeDecl(_type).typeName;
				}
				*/
			}
			return null;
		}
		
		override public function get typeNamespace():String {
			if(_type != null){
				// CW:: TODO: implement XSTypeDefinition
				/*
				return _type.namespace;
				*/
			}
			return null;
		}

		override public function isDerivedFrom(typeNamespaceArg:String, typeNameArg:String, derivationMethod:int):Boolean {
			if(needsSyncData) {
				synchronizeData();
			}
			if(_type != null) {
				// CW:: TODO: implement XSSimpleTypeDefinition, XSSimpleTypeDecl, XSComplexTypeDecl
				/*
				if(_type is XSSimpleTypeDefinition) {
					return XSSimpleTypeDecl(_type).isDOMDerivedFrom(typeNamespaceArg, typeNameArg, derivationMethod);
				} else {
					return XSComplexTypeDecl(_type).isDOMDerivedFrom(typeNamespaceArg, typeNameArg, derivationMethod);
				}
				*/
			}
			return false;
		}    

		// CW:: TODO: make value an XSTypeDefinition
		public function set type(value:Object):void {
			_type = value;
		}
		
		internal function renameNS(nsURI:String, qName:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			_name = qName;
			setName(nsURI, qName);
			reconcileDefaultAttributes();
		}
		
		internal function setValues(owner:DocumentImpl, nsURI:String, qName:String, locName:String):void {
			// remove children first
			_firstChild = null;
			_previousSibling = null;
			_nextSibling = null;
			nodeListCache = null;
			// set owner document
			_attributes = null;
			super.flags = 0;
			ownerDocumentInternal = owner;
			// synchronizeData will initialize attributes
			needsSyncData = true;
			super._name = qName;
			_localName = locName;
			_namespaceURI = nsURI;
		}
	}
}