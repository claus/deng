package deng.dom
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	import org.w3c.dom.*;
	import flash.utils.Dictionary;

	public class NodeImpl implements Node, NodeList
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
		
		public static const ELEMENT_DEFINITION_NODE:uint = 21;

	    public static const DOCUMENT_POSITION_DISCONNECTED:uint = 0x01;
	    public static const DOCUMENT_POSITION_PRECEDING:uint = 0x02;
	    public static const DOCUMENT_POSITION_FOLLOWING:uint = 0x04;
	    public static const DOCUMENT_POSITION_CONTAINS:uint = 0x08;
	    public static const DOCUMENT_POSITION_CONTAINED_BY:uint = 0x10;
	    public static const DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC:uint = 0x20;

		public static const TREE_POSITION_DISCONNECTED:uint = 0x00;
		public static const TREE_POSITION_PRECEDING:uint = 0x01;
		public static const TREE_POSITION_FOLLOWING:uint = 0x02;
		public static const TREE_POSITION_ANCESTOR:uint = 0x04;
		public static const TREE_POSITION_DESCENDANT:uint = 0x08;
		public static const TREE_POSITION_EQUIVALENT:uint = 0x10;
		public static const TREE_POSITION_SAME_NODE:uint = 0x20;

		protected static const READONLY:uint = 0x0001;
		protected static const SYNCDATA:uint = 0x0002;
		protected static const SYNCCHILDREN:uint = 0x0004;
		protected static const OWNED:uint = 0x0008;
		protected static const FIRSTCHILD:uint = 0x0010;
		protected static const SPECIFIED:uint = 0x0020;
		protected static const IGNORABLEWS:uint = 0x0040;
		protected static const HASSTRING:uint = 0x0080;
		protected static const NORMALIZED:uint = 0x0100;
		protected static const ID:uint = 0x0200;

		internal var flags:uint;
		internal var _ownerNode:NodeImpl;
		

		public function NodeImpl(owner:DocumentImpl) {
			registerClassAlias("deng.dom.NodeImpl", NodeImpl);
			_ownerNode = owner;
		}
		
		
		public function get nodeName():String { return null; }
		
		public function get nodeValue():String { return null; }
		
		public function set nodeValue(value:String):void { }
		
		public function get nodeType():int { return 0; }

		public function get parentNode():Node { return null; }
		
		public function get childNodes():NodeList { return this; }
		
		public function get firstChild():Node { return null; }
		
		public function get lastChild():Node { return null; }
		
		public function get previousSibling():Node { return null; }

		public function get nextSibling():Node { return null; }
		
		public function get attributes():NamedNodeMap { return null; }
		
		public function get ownerDocument():Document {
			if(isOwned) {
				return _ownerNode.ownerDocument;
			} else {
				return _ownerNode as Document;
			}
		}
		
		public function get namespaceURI():String { return null; }
		
		public function get prefix():String { return null; }
		
		public function set prefix(value:String):void {
			throw new DOMException(DOMException.NAMESPACE_ERR);
		}
		
		public function get localName():String { return null; }
		
		public function get baseURI():String { return null; }
		
		public function get textContent():String { return nodeValue; }
		
		public function set textContent(value:String):void { nodeValue = value; }
		
		public function get length():int { return 0; }
		

		internal function get parentNodeInternal():NodeImpl {
			return null;
		}

		// CW:: REVISIT: 
		// Do we need this here?
		// Shouldn't this be defined in ChildNode?
		//internal function get previousSiblingInternal():ChildNode {
		//	return null;
		//}
		
		internal function get ownerNode():NodeImpl {
			return _ownerNode;
		}

		internal function set ownerNode(node:NodeImpl):void {
			_ownerNode = node;
		}

		internal function get ownerDocumentInternal():DocumentImpl {
			if(isOwned) {
				return _ownerNode.ownerDocumentInternal;
			} else {
				return _ownerNode as DocumentImpl;
			}
		}

		internal function set ownerDocumentInternal(doc:DocumentImpl):void {
			if(needsSyncData) {
				synchronizeData();
			}
			// if we have an owner we rely on it to have it right
			// otherwise ownerNode is our ownerDocument
			if(!isOwned) {
				_ownerNode = doc;
			}
		}


		internal function get isReadOnly():Boolean {
			return (flags & READONLY) != 0;
		}
		
		internal function set isReadOnly(value:Boolean):void {
			flags = value ? (flags | READONLY) : (flags & ~READONLY);
		}
		
		public function getReadOnly():Boolean {
			if (needsSyncData) {
				synchronizeData();
			}
			return isReadOnly;
		}
		
		public function setReadOnly(value:Boolean, deep:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			isReadOnly = value;
		}

		internal function get needsSyncData():Boolean {
			return (flags & SYNCDATA) != 0;
		}
		
		internal function set needsSyncData(value:Boolean):void {
			flags = value ? (flags | SYNCDATA) : (flags & ~SYNCDATA);
		}
		
		internal function get needsSyncChildren():Boolean {
			return (flags & SYNCCHILDREN) != 0;
		}
		
		// CW:: REVISIT: do we have to make this public?
		internal function set needsSyncChildren(value:Boolean):void {
			flags = value ? (flags | SYNCCHILDREN) : (flags & ~SYNCCHILDREN);
		}
		
		internal function get isOwned():Boolean {
			return (flags & OWNED) != 0;
		}
		
		internal function set isOwned(value:Boolean):void {
			flags = value ? (flags | OWNED) : (flags & ~OWNED);
		}
		
		internal function get isFirstChild():Boolean {
			return (flags & FIRSTCHILD) != 0;
		}
		
		internal function set isFirstChild(value:Boolean):void {
			flags = value ? (flags | FIRSTCHILD) : (flags & ~FIRSTCHILD);
		}
		
		internal function get isSpecified():Boolean {
			return (flags & SPECIFIED) != 0;
		}
		
		internal function set isSpecified(value:Boolean):void {
			flags = value ? (flags | SPECIFIED) : (flags & ~SPECIFIED);
		}
		
		internal function get internalIsIgnorableWhitespace():Boolean {
			return (flags & IGNORABLEWS) != 0;
		}
		
		internal function set isIgnorableWhitespace(value:Boolean):void {
			flags = value ? (flags | IGNORABLEWS) : (flags & ~IGNORABLEWS);
		}
		
		internal function get hasStringValue():Boolean {
			return (flags & HASSTRING) != 0;
		}
		
		internal function set hasStringValue(value:Boolean):void {
			flags = value ? (flags | HASSTRING) : (flags & ~HASSTRING);
		}
		
		internal function get isNormalized():Boolean {
			return (flags & NORMALIZED) != 0;
		}
		
		internal function set isNormalized(value:Boolean):void {
			// See if flag should propagate to parent.
			if(!value && isNormalized && _ownerNode != null) {
				_ownerNode.isNormalized = false;
			}
			flags = value ? (flags | NORMALIZED) : (flags & ~NORMALIZED);
		}
		
		internal function get isIdAttribute():Boolean {
			return (flags & ID) != 0;
		}
		
		internal function set isIdAttribute(value:Boolean):void {
			flags = value ? (flags | ID) : (flags & ~ID);
		}
		

		public function insertBefore(newChild:Node, refChild:Node):Node {
			throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
		}
		
		public function replaceChild(newChild:Node, oldChild:Node):Node {
			throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
		}
		
		public function removeChild(oldChild:Node):Node {
			throw new DOMException(DOMException.NOT_FOUND_ERR);
		}
		
		public function appendChild(newChild:Node):Node {
			return insertBefore(newChild, null);
		}
		
		public function hasChildNodes():Boolean {
			return false;
		}
		
		public function hasAttributes():Boolean {
			return false;
		}
		
		public function cloneNode(deep:Boolean):Node {
			if(needsSyncData) {
				synchronizeData();
			}
			var newnode:NodeImpl = clone() as NodeImpl;
			// Need to break the association w/ original kids
			newnode.ownerNode = ownerDocumentInternal;
			newnode.isOwned = false;
			// By default we make all clones readwrite,
			// this is overriden in readonly subclasses
			newnode.isReadOnly = false;
			// CW:: REVISIT:
			// We should somehow use the const, but AS3 doesn't support
			// consts in interfaces so we have to wait until we implement 
			// that interface and take the const from there then.
			ownerDocumentInternal.callUserDataHandlers(this, newnode, 1 /*UserDataHandler.NODE_CLONED*/);
			return newnode;
		}
		
		public function normalize():void {
		}
		
		public function isSupported(feature:String, version:String):Boolean {
			return ownerDocumentInternal.implementation.hasFeature(feature, version);
		}

		public function isSameNode(other:Node):Boolean {
			return (this == other);
		}
		
		public function isEqualNode(other:Node):Boolean {
			if(this == other) {
				return true;
			}
			if(nodeType != other.nodeType) {
				return false;
			}
			// in theory nodeName can't be null but better be careful
			// who knows what other implementations may be doing?...
			if(nodeName == null) {
				if(other.nodeName != null) {
					return false;
				}
			} else if(nodeName != other.nodeName) {
				return false;
			}
			if(localName == null) {
				if(other.localName != null) {
					return false;
				}
			} else if(localName != other.localName) {
				return false;
			}
			if(namespaceURI == null) {
				if(other.namespaceURI != null) {
					return false;
				}
			} else if(namespaceURI != other.namespaceURI) {
				return false;
			}
			if(prefix == null) {
				if(other.prefix != null) {
					return false;
				}
			} else if(prefix != other.prefix) {
				return false;
			}
			if(nodeValue == null) {
				if(other.nodeValue != null) {
					return false;
				}
			} else if(nodeValue != other.nodeValue) {
				return false;
			}
			return true;
		}
		
		public function isDefaultNamespace(nsURI:String):Boolean {
			// REVISIT: remove casts when DOM L3 becomes REC.
			var ancestor:NodeImpl;
			switch(nodeType)
			{
				case ELEMENT_NODE:
					// REVISIT: is it possible that prefix is empty string?
					if(prefix == null || prefix.length == 0) {
						return (namespaceURI == nsURI);
					}
					if(hasAttributes()) {
						var elem:ElementImpl = this as ElementImpl;
						var attr:NodeImpl = elem.getAttributeNodeNS("http://www.w3.org/2000/xmlns/", "xmlns") as NodeImpl;
						if(attr != null) {
							return (nsURI == attr.namespaceURI);
						}
					}
					ancestor = getElementAncestor(this) as NodeImpl;
					return ancestor ? ancestor.isDefaultNamespace(nsURI) : false;
					
				case DOCUMENT_NODE:
					var doc:Document = this as Document;
					var node:NodeImpl = doc.documentElement as NodeImpl;
					return node ? node.isDefaultNamespace(nsURI) : false;
					
				case ATTRIBUTE_NODE:
					return (_ownerNode.nodeType == ELEMENT_NODE) ? _ownerNode.isDefaultNamespace(nsURI) : false;
					
				case ENTITY_NODE:
				case NOTATION_NODE:
				case DOCUMENT_FRAGMENT_NODE:
				case DOCUMENT_TYPE_NODE:
					// type is unknown
					return false;
					
				default:
					ancestor = getElementAncestor(this) as NodeImpl;
					return ancestor ? ancestor.isDefaultNamespace(nsURI) : false;
			}
		}
		
		public function compareTreePosition(other:Node):int {
			// If the nodes are the same...
			if (this == other) {
				return (TREE_POSITION_SAME_NODE | TREE_POSITION_EQUIVALENT);
			}
			var thisType:int = nodeType;
			var otherType:int = other.nodeType;
			// If either node is of type ENTITY or NOTATION, compare as disconnected
			if (thisType == ENTITY_NODE || thisType == NOTATION_NODE || otherType == ENTITY_NODE || otherType == NOTATION_NODE) {
				return TREE_POSITION_DISCONNECTED; 
			}
			// Find the ancestor of each node, and the distance each node is from 
			// its ancestor.
			// During this traversal, look for ancestor/descendent relationships 
			// between the 2 nodes in question. 
			// We do this now, so that we get this info correct for attribute nodes 
			// and their children. 
			var node:Node;
			var thisAncestor:Node = this;
			var otherAncestor:Node = other;
			var thisDepth:int = 0;
			var otherDepth:int = 0;
			for (node = this; node != null; node = node.parentNode) {
				thisDepth++;
				if (node == other) {
					// The other node is an ancestor of this one.
					return (TREE_POSITION_ANCESTOR | TREE_POSITION_PRECEDING);
				}
				thisAncestor = node;
			}
			for (node = other; node != null; node = node.parentNode) {
				otherDepth++;
				if (node == this) {
					// The other node is a descendent of the reference node.
					return (TREE_POSITION_DESCENDANT | TREE_POSITION_FOLLOWING);
				}
				otherAncestor = node;
			}
			var thisNode:Node = this;
			var otherNode:Node = other;
			var thisAncestorType:int = thisAncestor.nodeType;
			var otherAncestorType:int = otherAncestor.nodeType;
			// if the ancestor is an attribute, get owning element. 
			// we are now interested in the owner to determine position.
			if (thisAncestorType == ATTRIBUTE_NODE) {
				thisNode = (AttrImpl(thisAncestor)).ownerElement;
			}
			if (otherAncestorType == ATTRIBUTE_NODE) {
				otherNode = (AttrImpl(otherAncestor)).ownerElement;
			}
			// Before proceeding, we should check if both ancestor nodes turned
			// out to be attributes for the same element
			if (thisAncestorType == ATTRIBUTE_NODE && otherAncestorType == ATTRIBUTE_NODE && thisNode == otherNode) {
				return TREE_POSITION_EQUIVALENT;
			}
			// Now, find the ancestor of the owning element, if the original
			// ancestor was an attribute
			// Note: the following 2 loops are quite close to the ones above.
			// May want to common them up.  LM.
			if (thisAncestorType == ATTRIBUTE_NODE) {
				thisDepth = 0;
				for (node = thisNode; node != null; node = node.parentNode) {
					thisDepth++;
					if (node == otherNode) {
						// The other node is an ancestor of the owning element
						return TREE_POSITION_PRECEDING;
					}
					thisAncestor = node;
				}
			}
			// Now, find the ancestor of the owning element, if the original
			// ancestor was an attribute
			if (otherAncestorType == ATTRIBUTE_NODE) {
				otherDepth = 0;
				for (node = otherNode; node != null; node = node.parentNode) {
					otherDepth++;
					if (node == thisNode) {
						// The other node is a descendent of the reference node's element
						return TREE_POSITION_FOLLOWING;
					}
					otherAncestor = node;
				}
			}
			// thisAncestor and otherAncestor must be the same at this point,  
			// otherwise, we are not in the same tree or document fragment
			if (thisAncestor != otherAncestor) {
				return TREE_POSITION_DISCONNECTED;
			}
			// Go up the parent chain of the deeper node, until we find a node 
			// with the same depth as the shallower node
			var i:int;
			if (thisDepth > otherDepth) {
				for (i = 0; i < thisDepth - otherDepth; i++) {
					thisNode = thisNode.parentNode;
				}
				// Check if the node we have reached is in fact "otherNode". This can
				// happen in the case of attributes.  In this case, otherNode 
				// "precedes" this.
				if (thisNode == otherNode) {
					return TREE_POSITION_PRECEDING;
				}
			} else {
				for (i = 0; i < otherDepth - thisDepth; i++) {
					otherNode = otherNode.parentNode;
				}
				// Check if the node we have reached is in fact "thisNode".  This can
				// happen in the case of attributes.  In this case, otherNode 
				// "follows" this.
				if (otherNode == thisNode) {
					return TREE_POSITION_FOLLOWING;
				}
			}
			// We now have nodes at the same depth in the tree.
			// Find a common ancestor.
			var thisNodeP:Node
			var otherNodeP:Node;
			for (thisNodeP = thisNode.parentNode, otherNodeP = otherNode.parentNode; thisNodeP != otherNodeP; ) {
				thisNode = thisNodeP;
				otherNode = otherNodeP;
				thisNodeP = thisNodeP.parentNode;
				otherNodeP = otherNodeP.parentNode;
			}
			// At this point, thisNode and otherNode are direct children of 
			// the common ancestor.  
			// See whether thisNode or otherNode is the leftmost
			for (var current:Node = thisNodeP.firstChild; current != null; current = current.nextSibling) {
				if (current == otherNode) {
					return TREE_POSITION_PRECEDING;
				} else if (current == thisNode) {
					return TREE_POSITION_FOLLOWING;
				}
			}
			// REVISIT:  shouldn't get here.   Should probably throw an 
			// exception
			return 0;
		}
		
		public function compareDocumentPosition(other:Node):int {
			// If the nodes are the same, no flags should be set
			if(this == other) {
				return 0;
			}
			// check if other is from a different implementation
			if(other != null && !(other is NodeImpl)) {
				// other comes from a different implementation
				throw new DOMException(DOMException.NOT_SUPPORTED_ERR);
			}
			// get the respective Document owners.  
			var thisOwnerDoc:Document = (nodeType == DOCUMENT_NODE) ? this as Document : ownerDocument;
			var otherOwnerDoc:Document = (other.nodeType == DOCUMENT_NODE) ? other as Document : other.ownerDocument;
			// If from different documents, we know they are disconnected. 
			// and have an implementation dependent order 
			if(thisOwnerDoc != otherOwnerDoc && thisOwnerDoc != null && otherOwnerDoc != null) {
				var thisDocNum:int = DocumentImpl(thisOwnerDoc).nodeNumber;
				var otherDocNum:int = DocumentImpl(otherOwnerDoc).nodeNumber;
				if(otherDocNum > thisDocNum) {
					return DOCUMENT_POSITION_DISCONNECTED | DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC;
				} else {
					return DOCUMENT_POSITION_DISCONNECTED | DOCUMENT_POSITION_PRECEDING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC;
				}
			}
			// Find the ancestor of each node, and the distance each node is from 
			// its ancestor.
			// During this traversal, look for ancestor/descendent relationships 
			// between the 2 nodes in question. 
			// We do this now, so that we get this info correct for attribute nodes 
			// and their children.
			var i:int;
			var node:Node;
			var thisAncestor:Node = this;
			var otherAncestor:Node = other;
			var thisDepth:int = 0;
			var otherDepth:int = 0;
			for(node = this; node != null; node = node.parentNode) {
				thisDepth++;
				if(node == other) {
					// The other node is an ancestor of this one.
					return (DOCUMENT_POSITION_CONTAINS | DOCUMENT_POSITION_PRECEDING);
				}
				thisAncestor = node;
			}
			for(node = other; node != null; node = node.parentNode) {
				otherDepth++;
				if(node == this) {
					// The other node is a descendent of the reference node.
					return (DOCUMENT_POSITION_CONTAINED_BY | DOCUMENT_POSITION_FOLLOWING);
				}
				otherAncestor = node;
			}
			var thisAncestorType:int = thisAncestor.nodeType;
			var otherAncestorType:int = otherAncestor.nodeType;
			var thisNode:Node = this;
			var otherNode:Node = other;
			var container:DocumentType;
			// Special casing for ENTITY, NOTATION, DOCTYPE and ATTRIBUTES
			// LM:  should rewrite this.                                          
			switch(thisAncestorType) {
				case NOTATION_NODE:
				case ENTITY_NODE:
					container = thisOwnerDoc.doctype;
					if(container == otherAncestor) {
						return (DOCUMENT_POSITION_CONTAINS | DOCUMENT_POSITION_PRECEDING);
					}
					if(otherAncestorType == NOTATION_NODE || otherAncestorType == ENTITY_NODE) {
						if(thisAncestorType != otherAncestorType) {
							// the nodes are of different types
							return ((thisAncestorType > otherAncestorType) ? DOCUMENT_POSITION_PRECEDING : DOCUMENT_POSITION_FOLLOWING);
						} else {
							// the nodes are of the same type. Find order.
							// CW:: TODO:
							/*
							if(thisAncestorType == NOTATION_NODE) {
								if(NamedNodeMapImpl(container.notations).precedes(otherAncestor, thisAncestor)) {
									return (DOCUMENT_POSITION_PRECEDING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
								} else {
									return (DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
								}
							} else {
								if(NamedNodeMapImpl(container.entities).precedes(otherAncestor, thisAncestor)) {
									return (DOCUMENT_POSITION_PRECEDING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
								} else {
									return (DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
								}
							}
							*/
						}
					}
					thisNode = thisAncestor = thisOwnerDoc;
					break;

				case DOCUMENT_TYPE_NODE:
					if(otherNode == thisOwnerDoc) {
						return (DOCUMENT_POSITION_PRECEDING | DOCUMENT_POSITION_CONTAINS);
					} else if(thisOwnerDoc != null && thisOwnerDoc == otherOwnerDoc) {
						return DOCUMENT_POSITION_FOLLOWING;
					}
					break;

				case ATTRIBUTE_NODE:
					// CW:: TODO:
					/*
					thisNode = AttrImpl(thisAncestor).ownerElement;
					if(otherAncestorType == ATTRIBUTE_NODE) {
						otherNode = AttrImpl(otherAncestor).ownerElement;
						if(otherNode == thisNode) {
							if(NamedNodeMapImpl(thisNode.attributes).precedes(other, this)) {
								return (DOCUMENT_POSITION_PRECEDING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
							} else {
								return (DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
							}
						}
					}
					// Now, find the ancestor of the element
					thisDepth = 0;
					for(node = thisNode; node != null; node = node.parentNode) {
						thisDepth++;
						if(node == otherNode) {
							// The other node is an ancestor of the owning element
							return (DOCUMENT_POSITION_CONTAINS | DOCUMENT_POSITION_PRECEDING);
						}
						thisAncestor = node;
					}
					*/
					break;
			}
			switch (otherAncestorType) {
				case NOTATION_NODE:
				case ENTITY_NODE:
					container = thisOwnerDoc.doctype;
					if(container == this) {
						return (DOCUMENT_POSITION_CONTAINED_BY | DOCUMENT_POSITION_FOLLOWING);
					}
					otherNode = otherAncestor = thisOwnerDoc;
					break;

				case DOCUMENT_TYPE_NODE:
					if(thisNode == otherOwnerDoc) {
						return (DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_CONTAINED_BY);
					} else if(otherOwnerDoc != null && thisOwnerDoc == otherOwnerDoc) {
						return (DOCUMENT_POSITION_PRECEDING);
					}
					break;

				case ATTRIBUTE_NODE:
					// CW:: TODO:
					/*
					otherDepth = 0;
					otherNode = AttrImpl(otherAncestor).ownerElement;
					for(node = otherNode; node != null; node = node.parentNode) {
						otherDepth++;
						if(node == thisNode) {
							// The other node is a descendent 
							// of the reference node's element
							return (DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_CONTAINED_BY);
						}
						otherAncestor = node;
					}
					*/
			}
			// thisAncestor and otherAncestor must be the same at this point,  
			// otherwise, the original nodes are disconnected 
			if(thisAncestor != otherAncestor) {
				var thisAncestorNum:int = NodeImpl(thisAncestor).nodeNumber;
				var otherAncestorNum:int = NodeImpl(otherAncestor).nodeNumber;
				if(thisAncestorNum > otherAncestorNum) {
					return (DOCUMENT_POSITION_DISCONNECTED | DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
				} else {
					return (DOCUMENT_POSITION_DISCONNECTED | DOCUMENT_POSITION_PRECEDING | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC);
				}
			}
			// Go up the parent chain of the deeper node, until we find a node 
			// with the same depth as the shallower node
			if(thisDepth > otherDepth) {
				for(i = 0; i < thisDepth - otherDepth; i++) {
					thisNode = thisNode.parentNode;
				}
				// Check if the node we have reached is in fact "otherNode". This can
				// happen in the case of attributes.  In this case, otherNode 
				// "precedes" this.
				if(thisNode == otherNode) {
					return DOCUMENT_POSITION_PRECEDING;
				}
			} else {
				for(i = 0; i < otherDepth - thisDepth; i++) {
					otherNode = otherNode.parentNode;
				}
				// Check if the node we have reached is in fact "thisNode".  This can
				// happen in the case of attributes.  In this case, otherNode 
				// "follows" this.
				if(otherNode == thisNode) {
					return DOCUMENT_POSITION_FOLLOWING;
				}
			}
			// We now have nodes at the same depth in the tree.
			// Find a common ancestor.
			var thisNodeP:Node = thisNode.parentNode;
			var otherNodeP:Node = otherNode.parentNode;
			while(thisNodeP != otherNodeP) {
				thisNode = thisNodeP;
				otherNode = otherNodeP;
				thisNodeP = thisNodeP.parentNode;
				otherNodeP = otherNodeP.parentNode;
			}
			// At this point, thisNode and otherNode are direct children of 
			// the common ancestor. See whether thisNode or otherNode is the leftmost
			for(var current:Node = thisNodeP.firstChild; current != null; current = current.nextSibling) {
				if(current == otherNode) {
					return DOCUMENT_POSITION_PRECEDING;
				} else if(current == thisNode) {
					return DOCUMENT_POSITION_FOLLOWING;
				}
			}
			// REVISIT: shouldn't get here.
			// Should probably throw an exception
			return 0;
		}
		
		public function lookupPrefix(nsURI:String):String {
			// REVISIT: When Namespaces 1.1 comes out this may not be true
			// Prefix can't be bound to null namespace
			if(nsURI == null) {
				return null;
			}
			switch(nodeType)
			{
				case ELEMENT_NODE:
					// CW:: TODO:
					var dumy:String = namespaceURI; // to flip out children 
					return lookupNamespacePrefix(nsURI, this as ElementImpl);

				case DOCUMENT_NODE:
					var doc:Document = this as Document;
					var node:NodeImpl = doc.documentElement as NodeImpl;
					return node ? node.lookupPrefix(nsURI) : null;

				case ATTRIBUTE_NODE:
					return (_ownerNode.nodeType == ELEMENT_NODE) ? _ownerNode.lookupPrefix(nsURI) : null;

				case ENTITY_NODE:
				case NOTATION_NODE:
				case DOCUMENT_FRAGMENT_NODE:
				case DOCUMENT_TYPE_NODE:
					// type is unknown
					return null;

				default:
					var ancestor:NodeImpl = getElementAncestor(this) as NodeImpl;
					return ancestor ? ancestor.lookupPrefix(nsURI) : null;
			}
		}
		
		public function lookupNamespaceURI(specifiedPrefix:String):String {
			var ancestor:NodeImpl;
			switch(nodeType) {
				case ELEMENT_NODE:
					var ns:String = namespaceURI;
					var pre:String = prefix;
					if(ns != null) {
						// REVISIT: is it possible that prefix is empty string?
						if(specifiedPrefix == null && pre == null) {
							// looking for default namespace
							return ns;
						} else if(pre != null && pre == specifiedPrefix) {
							// non default namespace
							return ns;
						}
					} 
					if(hasAttributes()) {
						var map:NamedNodeMap = attributes;
						var len:int = map.length;
						for(var i:int = 0; i < length; i++) {
							var attr:Node = map.item(i);
							if(attr.namespaceURI == "http://www.w3.org/2000/xmlns/") {
								// at this point we are dealing with DOM Level 2 nodes only
								if(specifiedPrefix == null && attr.nodeName == "xmlns") {
									// default namespace
									return attr.nodeValue;
								} else if(attr.prefix == "xmlns" && attr.localName == specifiedPrefix) {
									// non default namespace
									return attr.nodeValue;
								}
							}
						}
					}
					ancestor = getElementAncestor(this) as NodeImpl;
					if(ancestor != null) {
						return ancestor.lookupNamespaceURI(specifiedPrefix);
					}
					return null;
					
				case DOCUMENT_NODE:
					return NodeImpl(Document(this).documentElement).lookupNamespaceURI(specifiedPrefix);

				case ENTITY_NODE:
				case NOTATION_NODE:
				case DOCUMENT_FRAGMENT_NODE:
				case DOCUMENT_TYPE_NODE:
					// type is unknown
					return null;

				case ATTRIBUTE_NODE:
					if(_ownerNode.nodeType == ELEMENT_NODE) {
						return _ownerNode.lookupNamespaceURI(specifiedPrefix);
					}
					return null;

				default:
					ancestor = getElementAncestor(this) as NodeImpl;
					if(ancestor != null) {
						return ancestor.lookupNamespaceURI(specifiedPrefix);
					}
					return null;
			}
		}
		
		internal function lookupNamespacePrefix(nsURI:String, el:ElementImpl):String {
			var ns:String = namespaceURI;
			var foundNamespace:String;
			// REVISIT: if no prefix is available is it null or empty string, or could be both?
			var pre:String = prefix;
			if (ns != null && ns == nsURI) {
				if (pre != null) {
					foundNamespace = el.lookupNamespaceURI(pre);
					if (foundNamespace != null && foundNamespace == nsURI) {
						return pre;
					}
				}
			}
			if (hasAttributes()) {
				var map:NamedNodeMap = attributes;
				var len:int = map.length;
				for (var i:int = 0; i < length; i++) {
					var attr:Node = map.item(i);
					var attrPrefix:String = attr.prefix;
					var value:String = attr.nodeValue;
					ns = attr.namespaceURI;
					if (ns == "http://www.w3.org/2000/xmlns/") {
						// DOM Level 2 nodes
						if ((attr.nodeName == "xmlns" || attrPrefix == "xmlns") && value == nsURI) {
							var localname:String = attr.localName;
							foundNamespace = el.lookupNamespaceURI(localname);
							if (foundNamespace != null && foundNamespace == nsURI) {
								return localname;
							}
						}
					}
				}
			}
			var ancestor:NodeImpl = getElementAncestor(this) as NodeImpl;
			if (ancestor != null) {
				return ancestor.lookupNamespacePrefix(namespaceURI, el);
			}
			return null;
		}
		
		public function getUserData(key:String):Object {
			return ownerDocumentInternal.getUserDataForNode(this, key);
		}
		
		public function setUserData(key:String, data:Object, handler:UserDataHandler):Object {
			return ownerDocumentInternal.setUserDataForNode(this, key, data, handler);
		}
		
		public function getFeature(feature:String, version:String):* {
			// we don't have any alternate node, either this node does the job
			// or we don't have anything that does
			return isSupported(feature, version) ? this : null;
		}
		
		public function item(index:int):Node {
			return null;
		}


		internal function changed():void {
			// we do not actually store this information on every node, we only
			// have a global indicator on the Document. Doing otherwise cost us too
			// much for little gain.
			ownerDocumentInternal.changed();
		}
		
		internal function getUserDataRecord():Dictionary {
			return ownerDocumentInternal.getUserDataRecordForNode(this);
		}

		protected function clone():* {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(this);
			ba.position = 0;
			return ba.readObject();
		}
		
		internal function getElementAncestor(currentNode:Node):Node {
			var parent:Node = currentNode.parentNode;
			if(parent != null) {
				return (parent.nodeType == ELEMENT_NODE) ? parent : getElementAncestor(parent);
			}
			return null;
		}
		
		internal function get nodeNumber():int {
			var cd:DocumentImpl = ownerDocument as DocumentImpl;
			return cd.getNodeNumber(this);
		}
		
		internal function synchronizeData():void {
			// By default just change the flag to avoid calling this method again
			needsSyncData = false;
		}
		
		internal function get container():Node {
			return null;
		}
	}
}