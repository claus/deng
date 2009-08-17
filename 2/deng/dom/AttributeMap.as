package deng.dom
{
	import org.w3c.dom.*;
	
	public class AttributeMap extends NamedNodeMapImpl
	{
		public function AttributeMap(ownerNode:NodeImpl, defaults:NamedNodeMapImpl = null)
		{
			super(ownerNode);
			if(defaults != null) {
				// initialize map with the defaults
				cloneContent(defaults);
				if(nodes != null) {
					hasDefaults= true;
				}
			}
		}
		
		override public function setNamedItem(arg:Node):Node {
			var errCheck:Boolean = _ownerNode.ownerDocumentInternal.errorChecking;
			if(errCheck) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(arg.ownerDocument != _ownerNode.ownerDocumentInternal) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
				if(arg.nodeType != NodeImpl.ATTRIBUTE_NODE) {
					throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
				}
			}
			var argn:AttrImpl = arg as AttrImpl;
			if(argn.isOwned) {
				if(errCheck && argn.ownerElement != _ownerNode) {
					throw new DOMException(DOMException.INUSE_ATTRIBUTE_ERR);
				} 
				// replacing an Attribute with itself does nothing
				return arg;
			}
			// set owner
			argn._ownerNode = _ownerNode;
			argn.isOwned = true;
			var i:int = findNamePoint(argn.nodeName, 0);
			var previous:AttrImpl = null;
			if(i >= 0) {
				previous = nodes[i] as AttrImpl;
				nodes[i] = arg;
				previous._ownerNode = _ownerNode.ownerDocumentInternal;
				previous.isOwned = false;
				// make sure it won't be mistaken with defaults in case it's reused
				previous.isSpecified = true;
			} else {
				i = -1 - i; // Insert point (may be end of list)
				if(nodes == null) {
					nodes = [];
				}
				nodes.splice(i, 0, arg);
			}
			// notify document
			_ownerNode.ownerDocumentInternal.setAttrNode(argn, previous);
			// If the new attribute is not normalized,
			// the owning element is inherently not normalized.
			if(!argn.isNormalized) {
				_ownerNode.isNormalized = false;
			}
			return previous;
		}
		
		override public function setNamedItemNS(arg:Node):Node {
			var errCheck:Boolean = _ownerNode.ownerDocumentInternal.errorChecking;
			if(errCheck) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(arg.ownerDocument != _ownerNode.ownerDocumentInternal) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
				if(arg.nodeType != NodeImpl.ATTRIBUTE_NODE) {
					throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
				}
			}
			var argn:AttrImpl = arg as AttrImpl;
			if(argn.isOwned) {
				if(errCheck && argn.ownerElement != _ownerNode) {
					throw new DOMException(DOMException.INUSE_ATTRIBUTE_ERR);
				} 
				// replacing an Attribute with itself does nothing
				return arg;
			}
			// set owner
			argn._ownerNode = _ownerNode;
			argn.isOwned = true;
			var i:int = findNamePointNS(argn.namespaceURI, argn.localName);
			var previous:AttrImpl = null;
			if(i >= 0) {
				previous = nodes[i] as AttrImpl;
				nodes[i] = arg;
				previous._ownerNode = _ownerNode.ownerDocumentInternal;
				previous.isOwned = false;
				// make sure it won't be mistaken with defaults in case it's reused
				previous.isSpecified = true;
			} else {
				i = findNamePoint(arg.nodeName, 0);
				if(i >= 0) {
					previous = nodes[i] as AttrImpl;
					nodes.insertElementAt(arg, i);
				} else {
					i = -1 - i; // Insert point (may be end of list)
					if(nodes == null) {
						nodes = [];
					}
					nodes.splice(i, 0, arg);
				}
			}
			// notify document
			_ownerNode.ownerDocumentInternal.setAttrNode(argn, previous);
			// If the new attribute is not normalized,
			// the owning element is inherently not normalized.
			if(!argn.isNormalized) {
				_ownerNode.isNormalized = false;
			}
			return previous;
		}
		
		override public function removeNamedItem(name:String):Node {
			return internalRemoveNamedItem(name, true);
		}
		
		internal function safeRemoveNamedItem(name:String):Node {
			return internalRemoveNamedItem(name, false);
		}
		
		internal function removeItem(item:Node, addDefault:Boolean):Node {
			var index:int = -1;
			if(nodes != null) {
				for(var i:int = 0; i < nodes.length; i++) {
					if(nodes[i] == item) {
						index = i;
						break;
					}
				}
			}
			if(index < 0) {
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			return remove(AttrImpl(item), index, addDefault);
		}
		
		internal function internalRemoveNamedItem(name:String, raiseEx:Boolean):Node {
			if(isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			var i:int = findNamePoint(name, 0);
			if(i < 0) {
				if(raiseEx) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				} else {
					return null;
				}
			}
			return remove(AttrImpl(nodes[i]), i, true);
		}
		
		private function remove(attr:AttrImpl, index:int, addDefault:Boolean):Node {
			var ownerDoc:DocumentImpl = _ownerNode.ownerDocumentInternal;
			var name:String = attr.nodeName;
			if(attr.isIdAttribute) {
				ownerDoc.removeIdentifier(attr.value);
			}
			if(hasDefaults && addDefault) {
				// If there's a default, add it instead
				var defaults:NamedNodeMapImpl = ElementImpl(_ownerNode).getDefaultAttributes();
				var d:Node;
				if(defaults != null && (d = defaults.getNamedItem(name)) != null && findNamePoint(name, index + 1) < 0) {
					var clone:NodeImpl = d.cloneNode(true) as NodeImpl;
					if(d.localName != null){
						// we must rely on the name to find a default attribute
						// ("test:attr"), but while copying it from the DOCTYPE
						// we should not loose namespace URI that was assigned
						// to the attribute in the instance document.
						AttrNSImpl(clone)._namespaceURI = attr.namespaceURI;
					}
					clone._ownerNode = _ownerNode;
					clone.isOwned = true;
					clone.isSpecified = false;
					nodes[index] = clone;
					if(attr.isIdAttribute) {
						ownerDoc.putIdentifier(clone.nodeValue, ElementImpl(_ownerNode));
					}
				} else {
					nodes.splice(index, 1);
				}
			} else {
				nodes.splice(index, 1);
			}
			// remove reference to owner
			attr._ownerNode = ownerDoc;
			attr.isOwned = false;
			// make sure it won't be mistaken with defaults in case it's reused
			attr.isSpecified = true;
			attr.isIdAttribute = false;
			// notify document
			ownerDoc.removedAttrNode(attr, _ownerNode, name);
			return attr;
		}
		
		override public function removeNamedItemNS(nsURI:String, name:String):Node {
			return internalRemoveNamedItemNS(nsURI, name, true);
		}
		
		internal function safeRemoveNamedItemNS(nsURI:String, name:String):Node {
			return internalRemoveNamedItemNS(nsURI, name, false);
		}

		internal function internalRemoveNamedItemNS(nsURI:String, name:String, raiseEx:Boolean):Node {
			var ownerDoc:DocumentImpl = _ownerNode.ownerDocumentInternal;
			if(ownerDoc.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			var i:int = findNamePointNS(nsURI, name);
			if(i < 0) {
				if(raiseEx) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				} else {
					return null;
				}
			}
			var n:AttrImpl = nodes[i] as AttrImpl;
			if(n.isIdAttribute) {
				ownerDoc.removeIdentifier(n.value);
			}
			// If there's a default, add it instead
			var nname:String = n.nodeName;
			if(hasDefaults) {
				var defaults:NamedNodeMapImpl = ElementImpl(_ownerNode).getDefaultAttributes();
				var d:Node;
				if(defaults != null && (d = defaults.getNamedItem(nname)) != null) {
					var j:int = findNamePoint(nname, 0);
					if(j >= 0 && findNamePoint(nname, j + 1) < 0) {
						var clone:NodeImpl = d.cloneNode(true) as NodeImpl;
						clone._ownerNode = _ownerNode;
						if(d.localName != null) {
							// we must rely on the name to find a default attribute
							// ("test:attr"), but while copying it from the DOCTYPE
							// we should not loose namespace URI that was assigned
							// to the attribute in the instance document.
							AttrNSImpl(clone)._namespaceURI = nsURI;
						}
						clone.isOwned = true;
						clone.isSpecified = false;
						nodes[i] = clone;
						if(clone.isIdAttribute) {
							ownerDoc.putIdentifier(clone.nodeValue, ElementImpl(_ownerNode));
						}
					} else {
						nodes.splice(i, 1);
					}
				} else {
					nodes.splice(i, 1);
				}
			} else {
				nodes.splice(i, 1);
			}
			// remove reference to owner
			n._ownerNode = ownerDoc;
			n.isOwned = false;
			// make sure it won't be mistaken with defaults in case it's reused
			n.isSpecified = true;
			// update id table if needed
			n.isIdAttribute = false;
			// notify document
			ownerDoc.removedAttrNode(n, _ownerNode, name);
			return n;
		}

		override public function cloneMap(owner:NodeImpl):NamedNodeMapImpl {
			var newmap:AttributeMap = new AttributeMap(ElementImpl(owner), null);
			newmap.hasDefaults = hasDefaults;
			newmap.cloneContent(this);
			return newmap;
		}

		override internal function cloneContent(srcmap:NamedNodeMapImpl):void {
			var srcnodes:Array = srcmap.nodes;
			if(srcnodes != null) {
				var size:uint = srcnodes.length;
				if(size != 0) {
					if(nodes == null) {
						nodes = [];
					}
					for(var i:int = 0; i < size; ++i) {
						var n:NodeImpl = srcnodes[i] as NodeImpl;
						var clone:NodeImpl = n.cloneNode(true) as NodeImpl;
						clone.isSpecified = n.isSpecified;
						nodes[i] = clone;
						clone._ownerNode = _ownerNode;
						clone.isOwned = true;
					}
				}
			}
		}
		
		internal function moveSpecifiedAttributes(srcmap:AttributeMap):void {
			var nsize:int = (srcmap.nodes != null) ? srcmap.nodes.length : 0;
			for(var i:int = nsize - 1; i >= 0; i--) {
				var attr:AttrImpl = srcmap.nodes[i] as AttrImpl;
				if(attr.isSpecified) {
					srcmap.remove(attr, i, false);
					if(attr.localName != null) {
						setNamedItem(attr);
					} else {
						setNamedItemNS(attr);
					}
				}
			}
		}
		
		internal function reconcileDefaults(defaults:NamedNodeMapImpl):void {
			var i:int;
			// remove any existing default
			var nsize:int = (nodes != null) ? nodes.length : 0;
			for(i = nsize - 1; i >= 0; i--) {
				var attr:AttrImpl = nodes[i] as AttrImpl;
				if(!attr.isSpecified) {
					remove(attr, i, false);
				}
			}
			// add the new defaults
			if(defaults == null) {
				return;
			}
			if(nodes == null || nodes.length == 0) {
				cloneContent(defaults);
			} else {
				var dsize:int = defaults.nodes.length;
				for(var n:int = 0; n < dsize; n++) {
					var d:AttrImpl = defaults.nodes[n] as AttrImpl;
					i = findNamePoint(d.nodeName, 0); 
					if(i < 0) {
						i = -1 - i; 
						var clone:NodeImpl = d.cloneNode(true) as NodeImpl;
						clone._ownerNode = _ownerNode;
						clone.isOwned = true;
						clone.isSpecified = false;
						nodes.splice(i, 0, clone);
					}
				}
			}
		}
		
		internal function addItem(arg:Node):int {
			var argn:AttrImpl = arg as AttrImpl;
			// set owner
			argn._ownerNode = _ownerNode;
			argn.isOwned = true; 
			var i:int = findNamePointNS(argn.namespaceURI, argn.localName);
			if(i >= 0) {
				nodes[i] = arg;
			} else {
				// If we can't find by namespaceURI, localName, then we find by
				// nodeName so we know where to insert.
				i = findNamePoint(argn.nodeName, 0);
				if(i >= 0) {
					nodes.splice(i, 0, arg);
				} else {
					i = -1 - i; // Insert point (may be end of list)
					if(nodes == null) {
						nodes = [];
					}
					nodes.splice(i, 0, arg);
				}
			}
			// notify document
			_ownerNode.ownerDocumentInternal.setAttrNode(argn, null);
			return i;
		}
	}
}
