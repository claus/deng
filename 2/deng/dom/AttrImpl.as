package deng.dom
{
	import org.w3c.dom.*;

	public class AttrImpl extends NodeImpl implements Attr, TypeInfo
	{
		internal var _name:String;
		internal var _value:Object;
		internal var _type:Object;
		
		internal static var _textNode:TextImpl = null;
		
		internal static var DTD_URI:String = "http://www.w3.org/TR/REC-xml";
		
		public function AttrImpl(owner:DocumentImpl, name:String)
		{
			super(owner);
			_name = name;
			isSpecified = true;
			hasStringValue = true;
		}
		
		internal function rename(name:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			_name = name;
		}

		internal function makeChildNode():void {
			if(hasStringValue) {
				if(_value != null) {
					var text:TextImpl = ownerDocumentInternal.createTextNode(_value.toString()) as TextImpl;
					_value = text;
					text.isFirstChild = true;
					text._previousSibling = text;
					text._ownerNode = this;
					text.isOwned = true;
				}
				hasStringValue = false;
			}
		}

		override internal function set ownerDocumentInternal(doc:DocumentImpl):void {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			super.ownerDocumentInternal = doc;
			if(!hasStringValue) {
				for(var child:ChildNode = value as ChildNode; child != null; child = child._nextSibling) {
					child.ownerDocumentInternal = doc;
				}
			}
		}

		public function setIdAttribute(id:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			isIdAttribute = id;
		}

		public function isId():Boolean {
			// REVISIT: should an attribute that is not in the tree return isID true?
			return isIdAttribute;
		}

		override public function cloneNode(deep:Boolean):Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			var clone:AttrImpl = super.cloneNode(deep) as AttrImpl;
			// take care of case where there are kids
			if(!clone.hasStringValue) {
				// Need to break the association w/ original kids
				clone._value = null;
				// Cloning an Attribute always clones its children, 
				// since they represent its value, no matter whether this 
				// is a deep clone or not
				for(var child:Node = value as Node; child != null; child = child.nextSibling) {
					clone.appendChild(child.cloneNode(true));
				}
			}
			clone.isSpecified = true;
			return clone;
		}

		override public function get nodeType():int {
			return NodeImpl.ATTRIBUTE_NODE;
		}

		override public function get nodeName():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _name;
		}

		override public function get nodeValue():String {
			return value;
		}

		override public function set nodeValue(newValue:String):void {
			value = newValue;
		}

		public function get typeName():String {
			return String(_type);
		}

		public function get typeNamespace():String {
			if(_type != null) {
				return DTD_URI;
			}
			return null;
		}

		public function get schemaTypeInfo():TypeInfo {
			return this;
		}

		public function get name():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _name;
		}

		public function set value(newValue:String):void {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			if(ownerDoc.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			var ownerEl:Element = ownerElement;
			var oldValue:String = "";
			if(needsSyncData) {
				synchronizeData();
			}
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			if(_value != null) {
				if(ownerDoc.mutationEvents) {
					// Can no longer just discard the kids; they may have
					// event listeners waiting for them to disconnect.
					if(hasStringValue) {
						oldValue = String(_value);
						// create an actual text node as our child so
						// that we can use it in the event
						if(_textNode == null) {
							_textNode = ownerDoc.createTextNode(String(value)) as TextImpl;
						} else {
							_textNode._data = String(value);
						}
						_value = _textNode;
						_textNode.isFirstChild = true;
						_textNode._previousSibling = _textNode;
						_textNode._ownerNode = this;
						_textNode.isOwned = true;
						hasStringValue = false;
						internalRemoveChild(_textNode, true);
					} else {
						oldValue = value;
						while(_value != null) {
							internalRemoveChild(_value as Node, true);
						}
					}
				} else {
					if(hasStringValue) {
						oldValue = String(value);
					} else {
						// simply discard children if any
						oldValue = value;
						// remove ref from first child to last child
						var fc:ChildNode = _value as ChildNode;
						fc._previousSibling = null;
						fc.isFirstChild = false;
						fc._ownerNode = ownerDoc;
					}
					// then remove ref to current value
					_value = null;
					needsSyncChildren = false;
				}
				if(isIdAttribute && ownerEl != null) {
					ownerDoc.removeIdentifier(oldValue);
				}
			}
			// Create and add the new one, generating only non-aggregate events
			// (There are no listeners on the new Text, but there may be
			// capture/bubble listeners on the Attr.
			// Note that aggregate events are NOT dispatched here,
			// since we need to combine the remove and insert.
			isSpecified = true;
			if(ownerDoc.mutationEvents) {
				// if there are any event handlers create a real node
				internalInsertBefore(ownerDoc.createTextNode(newValue), null, true);
				hasStringValue = false;
				// notify document
				ownerDoc.modifiedAttrValue(this, oldValue);
			} else {
				// directly store the string
				_value = newValue;
				hasStringValue = true;
				changed();
			}
			if(isIdAttribute && ownerEl != null) {
				ownerDoc.putIdentifier(newValue, ownerEl);
			}
		}

		public function get value():String {
			if(needsSyncData) {
				synchronizeData();
			}
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			if(_value == null) {
				return "";
			}
			if(hasStringValue) {
				return String(_value);
			}
			var fc:ChildNode = _value as ChildNode;
			var data:String = null;
			if(fc.nodeType == NodeImpl.ENTITY_REFERENCE_NODE) {
				// CW:: TODO:
				//data = EntityReferenceImpl(fc).entityRefValue;
			} else {
				data = fc.nodeValue;
			}
			var node:ChildNode = fc._nextSibling;
			if(node == null || data == null) {
				return (data == null) ? "" : data;
			}
			var val:String = data;
			while(node != null) {
				if(node.nodeType == NodeImpl.ENTITY_REFERENCE_NODE) {
					// CW:: TODO:
					//data = EntityReferenceImpl(node).entityRefValue;
					if(data == null) {
						return "";
					}
					val += data;
				} else {
					val += node.nodeValue;
				}
				node = node._nextSibling;
			}
			return val;
		}
		
		public function getSpecified():Boolean {
			if(needsSyncData) {
				synchronizeData();
			}
			return isSpecified;
		}

		public function get ownerElement():Element {
			// if we have an owner, ownerNode is our ownerElement, otherwise it's
			// our ownerDocument and we don't have an ownerElement
			return isOwned ? _ownerNode as Element : null;
		}
		
		override public function normalize():void {
			// No need to normalize if already normalized or
			// if value is kept as a String.
			if(isNormalized || hasStringValue) {
				return;
			}
			var kid:Node
			var next:Node;
			var fc:ChildNode = value as ChildNode;
			for(kid = fc; kid != null; kid = next) {
				next = kid.nextSibling;
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
				}
			}
			isNormalized = true;
		}

		/** NON-DOM, for use by parser */
		public function set specified(arg:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			isSpecified = arg;
		}

		/** NON-DOM: used by the parser */
		public function set type(arg:Object):void {
			_type = arg;
		}

		public function get specified():Boolean
		{
			return false;
		}

		override public function hasChildNodes():Boolean {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return (_value != null);
		}

		override public function get childNodes():NodeList {
			// JKESS: KNOWN ISSUE HERE 
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return this;
		}

		override public function get firstChild():Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			makeChildNode();
			return (_value as Node);
		}

		override public function get lastChild():Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return lastChildInternal;
		}

		internal function get lastChildInternal():ChildNode {
			// last child is stored as the previous sibling of first child
			makeChildNode();
			return (_value != null) ? ChildNode(value)._previousSibling : null;
		}

		internal function set lastChildInternal(node:ChildNode):void {
			// store lastChild as previous sibling of first child
			if(_value != null) {
				ChildNode(_value)._previousSibling = node;
			}
		}

		override public function insertBefore(newChild:Node, refChild:Node):Node {
			// Tail-call; optimizer should be able to do good things with.
			return internalInsertBefore(newChild, refChild, false);
		}

		internal function internalInsertBefore(newChild:Node, refChild:Node, replace:Boolean):Node {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			var errorChecking:Boolean = ownerDoc.errorChecking;
			if(newChild.nodeType == NodeImpl.DOCUMENT_FRAGMENT_NODE) {
				// SLOW BUT SAFE: We could insert the whole subtree without
				// juggling so many next/previous pointers. (Wipe out the
				// parent's child-list, patch the parent pointers, set the
				// ends of the list.) But we know some subclasses have special-
				// case behavior they add to insertBefore(), so we don't risk it.
				// This approch also takes fewer bytecodes.
				
				// NOTE: If one of the children is not a legal child of this
				// node, throw HIERARCHY_REQUEST_ERR before _any_ of the children
				// have been transferred. (Alternative behaviors would be to
				// reparent up to the first failure point or reparent all those
				// which are acceptable to the target node, neither of which is
				// as robust. PR-DOM-0818 isn't entirely clear on which it
				// recommends?????
				
				// No need to check kids for right-document; if they weren't,
				// they wouldn't be kids of that DocFrag.
				if(errorChecking) {
					for(var kid:Node = newChild.firstChild; kid != null; kid = kid.nextSibling) {
						if(!ownerDoc.isKidOK(this, kid)) {
							throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
						}
					}
				}
				while(newChild.hasChildNodes()) {
					insertBefore(newChild.firstChild, refChild);
				}
				return newChild;
			}
			if(newChild == refChild) {
				// stupid case that must be handled as a no-op triggering events...
				refChild = refChild.nextSibling;
				removeChild(newChild);
				insertBefore(newChild, refChild);
				return newChild;
			}
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			
			if(errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(newChild.ownerDocument != ownerDoc) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
				if(!ownerDoc.isKidOK(this, newChild)) {
					throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
				}
				// refChild must be a child of this node (or null)
				if(refChild != null && refChild.parentNode != this) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				}
				// Prevent cycles in the tree
				// newChild cannot be ancestor of this Node,
				// and actually cannot be this
				var treeSafe:Boolean = true;
				for(var a:NodeImpl = this; treeSafe && a != null; a = a.parentNodeInternal) {
					treeSafe = (newChild != a);
				}
				if(!treeSafe) {
					throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR);
				}
			}
			makeChildNode(); // make sure we have a node and not a string
			// notify document
			ownerDoc.insertingNode(this, replace);
			// Convert to internal type, to avoid repeated casting
			var newInternal:ChildNode = newChild as ChildNode;
			var refInternal:ChildNode = refChild as ChildNode;
			var oldParent:Node = newInternal.parentNodeInternal;
			if(oldParent != null) {
				oldParent.removeChild(newInternal);
			}
			// Attach up
			newInternal._ownerNode = this;
			newInternal.isOwned = true;
			// Attach before and after
			// Note: firstChild.previousSibling == lastChild!!
			var fc:ChildNode = _value as ChildNode;
			if(fc == null) {
				// this our first and only child
				_value = newInternal; // firstchild = newInternal;
				newInternal.isFirstChild = true;
				newInternal._previousSibling = newInternal;
			} else {
				if(refInternal == null) {
					// this is an append
					var lc:ChildNode = fc._previousSibling;
					lc._nextSibling = newInternal;
					newInternal._previousSibling = lc;
					fc._previousSibling = newInternal;
				} else {
					// this is an insert
					if(refChild == fc) {
						// at the head of the list
						fc.isFirstChild = false;
						newInternal._nextSibling = fc;
						newInternal._previousSibling = fc._previousSibling;
						fc._previousSibling = newInternal;
						_value = newInternal; // firstChild = newInternal;
						newInternal.isFirstChild = true;
					} else {
						// somewhere in the middle
						var prev:ChildNode = refInternal._previousSibling;
						newInternal._nextSibling = refInternal;
						prev._nextSibling = newInternal;
						refInternal._previousSibling = newInternal;
						newInternal._previousSibling = prev;
					}
				}
			}
			changed();
			// notify document
			ownerDoc.insertedNode(this, newInternal, replace);
			checkNormalizationAfterInsert(newInternal);
			return newChild;
		}

		override public function removeChild(oldChild:Node):Node {
			// Tail-call, should be optimizable
			if(hasStringValue) {
				// we don't have any child per say so it can't be one of them!
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			return internalRemoveChild(oldChild, false);
		}

		internal function internalRemoveChild(oldChild:Node, replace:Boolean):Node {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			if(ownerDoc.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(oldChild != null && oldChild.parentNode != this) {
					throw new DOMException(DOMException.NOT_FOUND_ERR);
				}
			}
			var oldInternal:ChildNode = oldChild as ChildNode;
			// notify document
			ownerDoc.removingNode(this, oldInternal, replace);
			// Patch linked list around oldChild
			// Note: lastChild == firstChild.previousSibling
			var fc:ChildNode;
			if(oldInternal == _value) { // oldInternal == firstChild
				// removing first child
				oldInternal.isFirstChild = false;
				// next line is: firstChild = oldInternal.nextSibling
				_value = oldInternal._nextSibling;
				fc = _value as ChildNode;
				if(fc != null) {
					fc.isFirstChild = true;
					fc._previousSibling = oldInternal._previousSibling;
				}
			} else {
				var prev:ChildNode = oldInternal._previousSibling;
				var next:ChildNode = oldInternal._nextSibling;
				prev._nextSibling = next;
				if(next == null) {
					// removing last child
					fc = _value as ChildNode;
					fc._previousSibling = prev;
				} else {
					// removing some other child in the middle
					next._previousSibling = prev;
				}
			}
			// Save previous sibling for normalization checking.
			var oldPreviousSibling:ChildNode = oldInternal.previousSiblingInternal;
			// Remove oldInternal's references to tree
			oldInternal._ownerNode = ownerDoc;
			oldInternal.isOwned = false;
			oldInternal._nextSibling = null;
			oldInternal._previousSibling = null;
			changed();
			// notify document
			ownerDoc.removedNode(this, replace);
			checkNormalizationAfterRemove(oldPreviousSibling);
			return oldInternal;
		}

		override public function replaceChild(newChild:Node, oldChild:Node):Node {
			makeChildNode();
			// If Mutation Events are being generated, this operation might
			// throw aggregate events twice when modifying an Attr -- once 
			// on insertion and once on removal. DOM Level 2 does not specify 
			// this as either desirable or undesirable, but hints that
			// aggregations should be issued only once per user request.
			// Notify document:
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			ownerDoc.replacingNode(this);
			internalInsertBefore(newChild, oldChild, true);
			if(newChild != oldChild) {
				internalRemoveChild(oldChild, true);
			}
			// notify document
			ownerDoc.replacedNode(this);
			return oldChild;
		}

		override public function get length():int {
			if(hasStringValue) {
				return 1;
			}
			var node:ChildNode = _value as ChildNode;
			var len:int = 0;
			for(; node != null; node = node._nextSibling) {
				len++;
			}
			return len;
		}

		override public function item(index:int):Node {
			if(hasStringValue) {
				if(index != 0 || _value == null) {
					return null;
				} else {
					makeChildNode();
					return (_value as Node);
				}
			}
			if(index < 0) {
				return null;
			}
			var node:ChildNode = value as ChildNode;
			for(var i:int = 0; i < index && node != null; i++) {
				node = node._nextSibling;
			} 
			return node;
		}

		override public function isEqualNode(arg:Node):Boolean {
			return super.isEqualNode(arg);
		}

		public function isDerivedFrom(typeNamespaceArg:String, typeNameArg:String, derivationMethod:int):Boolean {
			return false;
		}

		override public function setReadOnly(readOnly:Boolean, deep:Boolean):void {
			super.setReadOnly(readOnly, deep);
			if(deep) {
				if(needsSyncChildren) {
					synchronizeChildren();
				}
				if(hasStringValue) {
					return;
				}
				// Recursively set kids
				for(var mykid:ChildNode = _value as ChildNode; mykid != null; mykid = mykid._nextSibling) {
					if(mykid.nodeType != NodeImpl.ENTITY_REFERENCE_NODE) {
						mykid.setReadOnly(readOnly, true);
					}
				}
			}
		}

		internal function synchronizeChildren():void {
			// By default just change the flag to avoid calling this method again
			needsSyncChildren = false;
		}
		
		internal function checkNormalizationAfterInsert(insertedChild:ChildNode):void {
			// See if insertion caused this node to be unnormalized.
			if(insertedChild.nodeType == NodeImpl.TEXT_NODE) {
				var prev:ChildNode = insertedChild.previousSiblingInternal;
				var next:ChildNode = insertedChild._nextSibling;
				// If an adjacent sibling of the new child is a text node,
				// flag this node as unnormalized.
				if((prev != null && prev.nodeType == NodeImpl.TEXT_NODE) ||
				   (next != null && next.nodeType == NodeImpl.TEXT_NODE)) {
					isNormalized = false;
				}
			} else {
				// If the new child is not normalized,
				// then this node is inherently not normalized.
				if(!insertedChild.isNormalized) {
					isNormalized = false;
				}
			}
		}

		internal function checkNormalizationAfterRemove(prevSibling:ChildNode):void {
			// See if removal caused this node to be unnormalized.
			// If the adjacent siblings of the removed child were both text nodes,
			// flag this node as unnormalized.
			if(prevSibling != null && prevSibling.nodeType == NodeImpl.TEXT_NODE) {
				var next:ChildNode = prevSibling._nextSibling;
				if(next != null && next.nodeType == NodeImpl.TEXT_NODE) {
					isNormalized = false;
				}
			}
		}

		/** NON-DOM method for debugging convenience */
		public function toString():String {
			return name + "=" + "\"" + value + "\"";
		}
	}
}