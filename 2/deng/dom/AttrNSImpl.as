package deng.dom
{
	public class AttrNSImpl extends AttrImpl
	{
		internal var _namespaceURI:String;
		internal var _localName:String;

		internal static const XML_URI:String = "http://www.w3.org/XML/1998/namespace";
		internal static const XMLNS_URI:String = "http://www.w3.org/2000/xmlns/";
		
		public function AttrNSImpl(owner:DocumentImpl, nsURI:String, qName:String, locName:String = null)
		{
			super(owner, qName);
			if(locName == null) {
				setName(nsURI, qName);
			} else {
				_localName = locName;
				_namespaceURI = nsURI;
			}
		}
		
		internal function renameNS(nsURI:String, qName:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			_name = qName;
			setName(nsURI, qName);
		}

		private function setName(nsURI:String, qName:String):void {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			// DOM Level 3: namespace URI is never empty string.
			_namespaceURI = nsURI;
			if(nsURI != null) {
				_namespaceURI = (nsURI.length == 0) ? null : nsURI;
			}
			var pre:String;
			var colon1:int = qName.indexOf(':');
			var colon2:int = qName.lastIndexOf(':');
			ownerDoc.checkNamespaceWF(qName, colon1, colon2);
			if(colon1 < 0) {
				// there is no prefix
				_localName = qName;
				if(ownerDoc.errorChecking) {
					ownerDoc.checkQName(null, _localName);
					if(qName == "xmlns" && (nsURI == null || nsURI != XMLNS_URI)
					|| (qName != "xmlns" && nsURI == XMLNS_URI)) {
						throw new DOMException(DOMException.NAMESPACE_ERR);
					}
				}
			} else {
				pre = qName.substring(0, colon1);
				_localName = qName.substring(colon2 + 1);
				ownerDoc.checkQName(pre, _localName);
				ownerDoc.checkDOMNSErr(pre, nsURI);
			}
		}

		public function setValues(owner:DocumentImpl, nsURI:String, qName:String, locName:String):void {
			AttrImpl._textNode = null;
			super.flags = 0;
			isSpecified = true;
			hasStringValue = true;
			super.ownerDocumentInternal = owner;
			_localName = locName;
			_namespaceURI = nsURI;
			super._name = qName;
			super._value = null;
		}

		override public function get namespaceURI():String {
			if(needsSyncData) {
				synchronizeData();
			}
			// REVIST: This code could/should be done at a lower-level, such that
			// the namespaceURI is set properly upon creation. However, there still
			// seems to be some DOM spec interpretation grey-area.
			return _namespaceURI;
		}
		
		override public function get prefix():String {
			if(needsSyncData) {
				synchronizeData();
			}
			var index:int = _name.indexOf(':');
			return (index < 0) ? null : _name.substring(0, index); 
		}

		override public function set prefix(pre:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			if(ownerDocumentInternal.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(pre != null && pre.length != 0) {
					if(!DocumentImpl.isXMLName(pre, ownerDocumentInternal.isXML11Version())) {
						throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
					}
					if(_namespaceURI == null || pre.indexOf(':') >= 0) {
						throw new DOMException(DOMException.NAMESPACE_ERR);
					}
					if(pre == "xmlns") {
						if(_namespaceURI != XMLNS_URI) {
							throw new DOMException(DOMException.NAMESPACE_ERR);
						}
					} else if(pre == "xml") {
						if(_namespaceURI != XML_URI) {
							throw new DOMException(DOMException.NAMESPACE_ERR);
						}
					} else if(_name == "xmlns") {
						throw new DOMException(DOMException.NAMESPACE_ERR);
					}
				} 
			}
			// update node name with new qualifiedName
			if(pre != null && pre.length != 0) {
				_name = pre + ":" + _localName;
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

		override public function get typeName():String {
			if(_type != null) {
				// CW:: TODO:
				//if(_type is XSSimpleTypeDecl) {
				//	return XSSimpleTypeDecl(_type).name;
				//}
				return String(_type);
			}
			return null;
		}

		override public function isDerivedFrom(typeNamespaceArg:String, typeNameArg:String, derivationMethod:int):Boolean {
			if(_type != null) {
				// CW:: TODO:
				//if(_type is XSSimpleTypeDefinition) {
				//	return XSSimpleTypeDecl(_type).isDOMDerivedFrom(typeNamespaceArg, typeNameArg, derivationMethod);
				//}    
			} 
			return false;
		}

		override public function get typeNamespace():String {
			if(_type != null) {
				// CW:: TODO:
				//if(_type is XSSimpleTypeDecl) {
				//	return XSSimpleTypeDecl(_type).namespace;
				//}
				return DTD_URI;
			}
			return null;
		}
	}
}