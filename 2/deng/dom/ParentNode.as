package deng.dom
{
	import flash.net.registerClassAlias;
	import org.w3c.dom.*;
	
	public class ParentNode extends ChildNode
	{
		internal var _ownerDocument:DocumentImpl;
		internal var _firstChild:ChildNode;
		
		// CW:: REVISIT:
		// In Xerces-J this is defined as Object, not as NodeListCache. Problem?
		internal var nodeListCache:NodeListCache;
		

		public function ParentNode(owner:DocumentImpl)
		{
			registerClassAlias("deng.dom.ParentNode", ParentNode);
			super(owner);
			_ownerDocument = owner;
		}


		override public function get ownerDocument():Document {
			return _ownerDocument;
		}


		override public function get childNodes():NodeList {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return this;
		}

		override public function get firstChild():Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return _firstChild;
		}

		override public function get lastChild():Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return lastChildInternal;
		}


		override internal function get ownerDocumentInternal():DocumentImpl {
			return _ownerDocument;
		}
		
		override internal function set ownerDocumentInternal(doc:DocumentImpl):void {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			super.ownerDocumentInternal = doc;
			_ownerDocument = doc;
			for(var child:ChildNode = _firstChild; child != null; child = child._nextSibling) {
				child.ownerDocumentInternal = doc;
			}
		}

		internal function get lastChildInternal():ChildNode {
			return (_firstChild != null) ? _firstChild._previousSibling : null;
		}

		internal function set lastChildInternal(node:ChildNode):void {
			// store lastChild as previous sibling of first child
			if(_firstChild != null) {
				_firstChild._previousSibling = node;
			}
		}

		
		override public function cloneNode(deep:Boolean):Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			var newnode:ParentNode = super.cloneNode(deep) as ParentNode;
			// set owner document
			newnode._ownerDocument = _ownerDocument;
			// Need to break the association w/ original kids
			newnode._firstChild = null;
			// invalidate cache for children NodeList
			newnode.nodeListCache = null;
			// Then, if deep, clone the kids too.
			if(deep) {
				for(var child:ChildNode = _firstChild; child != null; child = child._nextSibling) {
					newnode.appendChild(child.cloneNode(true));
				}
			}
			return newnode;
		}

		override public function hasChildNodes():Boolean {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return (firstChild != null);
		}
		
		override public function insertBefore(newChild:Node, refChild:Node):Node {
			return internalInsertBefore(newChild, refChild, false);
		}

		override public function removeChild(oldChild:Node):Node {
			return internalRemoveChild(oldChild, false);
		}

		override public function replaceChild(newChild:Node, oldChild:Node):Node {
			_ownerDocument.replacingNode(this);
			internalInsertBefore(newChild, oldChild, true);
			if(newChild != oldChild) {
				internalRemoveChild(oldChild, true);
			}
			_ownerDocument.replacedNode(this);
			return oldChild;
		}

		override public function normalize():void {
			// No need to normalize if already normalized.
			if(isNormalized) { return; }
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			var kid:ChildNode;
			for(kid = _firstChild; kid != null; kid = kid._nextSibling) {
				kid.normalize();
			}
			isNormalized = true;
		}

		override public function get textContent():String {
			var child:Node = firstChild;
			if(child != null) {
				var next:Node = child.nextSibling;
				if(next == null) {
					return hasTextContent(child) ? NodeImpl(child).textContent : "";
				}
				var buf:String = "";
				while(child != null) {
					if(hasTextContent(child)) {
						buf += NodeImpl(child).textContent;
					}
					child = child.nextSibling;
				}
				return buf;
			}
			return "";
		}

		override public function set textContent(value:String):void {
			// get rid of any existing children
			var child:Node;
			while((child = firstChild) != null) {
				removeChild(child);
			}
			// create a Text node to hold the given content
			if(value != null && value.length != 0) {
				appendChild(ownerDocumentInternal.createTextNode(value));
			}
		}
		
		internal function hasTextContent(child:Node):Boolean {
			// CW:: TODO:
			return child.nodeType != NodeImpl.COMMENT_NODE &&
					child.nodeType != NodeImpl.PROCESSING_INSTRUCTION_NODE &&
					(child.nodeType != NodeImpl.TEXT_NODE /*|| !TextImpl(child).isIgnorableWhitespace*/);
		}
		
		override public function isEqualNode(arg:Node):Boolean {
			if(!super.isEqualNode(arg)) {
				return false;
			}
			// there are many ways to do this test, and there isn't any way
			// better than another. Performance may vary greatly depending on
			// the implementations involved. This one should work fine for us.
			var child1:Node = firstChild;
			var child2:Node = arg.firstChild;
			while(child1 != null && child2 != null) {
				if(!NodeImpl(child1).isEqualNode(child2)) {
					return false;
				}
				child1 = child1.nextSibling;
				child2 = child2.nextSibling;
			}
			return (child1 == child2);
		}
		
		override public function setReadOnly(readOnly:Boolean, deep:Boolean):void {
			super.setReadOnly(readOnly, deep);
			if(deep) {
				if(needsSyncChildren) {
					synchronizeChildren();
				}
				// Recursively set kids
				for(var mykid:ChildNode = _firstChild; mykid != null; mykid = mykid._nextSibling) {
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
		
		internal function internalInsertBefore(newChild:Node, refChild:Node, replace:Boolean):Node {
			var errorChecking:Boolean = ownerDocumentInternal.errorChecking;
			if(newChild.nodeType == DOCUMENT_FRAGMENT_NODE) {
				// SLOW BUT SAFE: We could insert the whole subtree without
				// juggling so many next/previous pointers. (Wipe out the
				// parent's child-list, patch the parent pointers, set the
				// ends of the list.) But we know some subclasses have special-
				// case behavior they add to insertBefore(), so we don't risk it.
				// This approch also takes fewer bytecodes.
				//
				// NOTE: If one of the children is not a legal child of this
				// node, throw HIERARCHY_REQUEST_ERR before _any_ of the children
				// have been transferred. (Alternative behaviors would be to
				// reparent up to the first failure point or reparent all those
				// which are acceptable to the target node, neither of which is
				// as robust. PR-DOM-0818 isn't entirely clear on which it
				// recommends?????
				//
				// No need to check kids for right-document; if they weren't,
				// they wouldn't be kids of that DocFrag.
				if(errorChecking) {
					for(var child:Node = newChild.firstChild; child != null; child = child.nextSibling) {
						if(!ownerDocumentInternal.isKidOK(this, child)) {
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
				if(newChild.ownerDocument != _ownerDocument && newChild != _ownerDocument) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
				if(!_ownerDocument.isKidOK(this, newChild)) {
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
			// notify document
			_ownerDocument.insertingNode(this, replace);
			// Convert to internal type, to avoid repeated casting
			var newChildInternal:ChildNode = newChild as ChildNode;
			var refChildInternal:ChildNode = refChild as ChildNode;
			// Detach from old parent
			var oldParent:Node = newChildInternal.parentNodeInternal;
			if(oldParent != null) {
				oldParent.removeChild(newChildInternal);
			}
			// Attach up
			newChildInternal._ownerNode = this;
			newChildInternal.isOwned = true;
			// Attach before and after
			// Note: firstChild.previousSibling == lastChild!!
			if(_firstChild == null) {
				// this our first and only child
				_firstChild = newChildInternal;
				newChildInternal.isFirstChild = true;
				newChildInternal._previousSibling = newChildInternal;
			} else {
				if(refChildInternal == null) {
					// this is an append
					var last:ChildNode = _firstChild._previousSibling;
					last._nextSibling = newChildInternal;
					newChildInternal._previousSibling = last;
					_firstChild._previousSibling = newChildInternal;
				} else {
					// this is an insert
					if (refChild == _firstChild) {
						// at the head of the list
						_firstChild.isFirstChild = false;
						newChildInternal._nextSibling = _firstChild;
						newChildInternal._previousSibling = _firstChild._previousSibling;
						_firstChild._previousSibling = newChildInternal;
						_firstChild = newChildInternal;
						newChildInternal.isFirstChild = true;
					} else {
						// somewhere in the middle
						var prev:ChildNode = refChildInternal._previousSibling;
						newChildInternal._nextSibling = refChildInternal;
						prev._nextSibling = newChildInternal;
						refChildInternal._previousSibling = newChildInternal;
						newChildInternal._previousSibling = prev;
					}
				}
			}
			changed();
			// update cached length if we have any
			if(nodeListCache != null) {
				if(nodeListCache.length != -1) {
					nodeListCache.length++;
				}
				if(nodeListCache.childIndex != -1) {
					// if we happen to insert just before the cached node, update
					// the cache to the new node to match the cached index
					if(nodeListCache.child == refChildInternal) {
						nodeListCache.child = newChildInternal;
					} else {
						// otherwise just invalidate the cache
						nodeListCache.childIndex = -1;
					}
				}
			}
			// notify document
			ownerDocumentInternal.insertedNode(this, newChildInternal, replace);
			checkNormalizationAfterInsert(newChildInternal);
			return newChild;
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
			_ownerDocument.removingNode(this, oldInternal, replace);
			// update cached length if we have any
			if(nodeListCache != null) {
				if(nodeListCache.length != -1) {
					nodeListCache.length--;
				}
				if(nodeListCache.childIndex != -1) {
					// if the removed node is the cached node
					// move the cache to its (soon former) previous sibling
					if(nodeListCache.child == oldInternal) {
						nodeListCache.childIndex--;
						nodeListCache.child = oldInternal.previousSiblingInternal;
					} else {
						// otherwise just invalidate the cache
						nodeListCache.childIndex = -1;
					}
				}
			}
			// Patch linked list around oldChild
			// Note: lastChild == firstChild.previousSibling
			if (oldInternal == _firstChild) {
				// removing first child
				oldInternal.isFirstChild = false;
				_firstChild = oldInternal._nextSibling;
				if(_firstChild != null) {
					_firstChild.isFirstChild = true;
					_firstChild._previousSibling = oldInternal._previousSibling;
				}
			} else {
				var prev:ChildNode = oldInternal._previousSibling;
				var next:ChildNode = oldInternal._nextSibling;
				prev._nextSibling = next;
				if(next == null) {
					// removing last child
					_firstChild._previousSibling = prev;
				} else {
				// removing some other child in the middle
					next._previousSibling = prev;
				}
			}
			// Save previous sibling for normalization checking.
			var oldPreviousSibling:ChildNode = oldInternal.previousSiblingInternal;
			// Remove oldInternal's references to tree
			oldInternal._ownerNode = _ownerDocument;
			oldInternal.isOwned = false;
			oldInternal._nextSibling = null;
			oldInternal._previousSibling = null;
			changed();
			// notify document
			_ownerDocument.removedNode(this, replace);
			checkNormalizationAfterRemove(oldPreviousSibling);
			return oldInternal;
		}
		
		internal function checkNormalizationAfterInsert(insertedChild:ChildNode):void {
			// See if insertion caused this node to be unnormalized.
			if(insertedChild.nodeType == TEXT_NODE) {
				var prev:ChildNode = insertedChild.previousSiblingInternal;
				var next:ChildNode = insertedChild._nextSibling;
				// If an adjacent sibling of the new child is a text node,
				// flag this node as unnormalized.
				if((prev != null && prev.nodeType == TEXT_NODE) || (next != null && next.nodeType == TEXT_NODE)) {
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

		override public function get length():int {
			return nodeListGetLength();
		}
		
		private function nodeListGetLength():int {
			if(nodeListCache == null) {
				if(needsSyncChildren) {
					synchronizeChildren();
				}
				// get rid of trivial cases
				if(_firstChild == null) {
					return 0;
				}
				if(_firstChild == lastChild) {
					return 1;
				}
				// otherwise request a cache object
				nodeListCache = _ownerDocument.getNodeListCache(this);
			}
			// is the cached length invalid ?
			if(nodeListCache.length == -1) {
				var l:int;
				var n:ChildNode;
				// start from the cached node if we have one
				if(nodeListCache.childIndex != -1 && nodeListCache.child != null) {
					l = nodeListCache.childIndex;
					n = nodeListCache.child;
				} else {
					n = _firstChild;
					l = 0;
				}
				while(n != null) {
					l++;
					n = n._nextSibling;
				}
				nodeListCache.length = l;
			}
			return nodeListCache.length;
		}
		
		override public function item(index:int):Node {
			return nodeListItem(index);
		}
		
		private function nodeListItem(index:int):Node {
			if(nodeListCache == null) {
				if(needsSyncChildren) {
					synchronizeChildren();
				}
				// get rid of trivial case
				if(_firstChild == lastChild) {
					return (index == 0) ? _firstChild : null;
				}
				// otherwise request a cache object
				nodeListCache = _ownerDocument.getNodeListCache(this);
			}
			var i:int = nodeListCache.childIndex;
			var n:ChildNode = nodeListCache.child;
			var firstAccess:Boolean = true;
			// short way
			if(i != -1 && n != null) {
				firstAccess = false;
				if(i < index) {
					while(i < index && n != null) {
						i++;
						n = n._nextSibling;
					}
				} else if(i > index) {
					while(i > index && n != null) {
						i--;
						n = n.previousSiblingInternal;
					}
				}
			} else {
				// long way
				if(index < 0) {
					return null;
				}
				n = _firstChild;
				for(i = 0; i < index && n != null; i++) {
					n = n._nextSibling;
				}
			}
			// release cache if reaching last child or first child
			if(!firstAccess && (n == _firstChild || n == lastChild)) {
				nodeListCache.childIndex = -1;
				nodeListCache.child = null;
				_ownerDocument.freeNodeListCache(nodeListCache);
				// we can keep using the cache until it is actually reused
				// nodeListCache will be nulled by the pool (document) if that happens.
				// nodeListCache = null;
			} else {
				// otherwise update it
				nodeListCache.childIndex = i;
				nodeListCache.child = n;
			}
			return n;
		}
		
		internal function getChildNodesUnoptimized():NodeList {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			// CW:: TODO:
			return null;
		}
	}
}