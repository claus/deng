package deng.dom
{
	import flash.net.registerClassAlias;
	import org.w3c.dom.*;
	
	public class ChildNode extends NodeImpl
	{
		internal var _previousSibling:ChildNode;
		internal var _nextSibling:ChildNode;


		public function ChildNode(owner:DocumentImpl)
		{
			registerClassAlias("deng.dom.ChildNode", ChildNode);
			super(owner);
		}


		override public function get parentNode():Node {
			// if we have an owner, ownerNode is our parent, otherwise it's
			// our ownerDocument and we don't have a parent
			return isOwned ? ownerNode : null;
		}

		override public function get previousSibling():Node {
			// if we are the firstChild, previousSibling actually refers to our
			// parent's lastChild, but we hide that
			return isFirstChild ? null : _previousSibling;
		}
		
		override public function get nextSibling():Node {
			return _nextSibling;
		}

		override public function cloneNode(deep:Boolean):Node {
			var newnode:ChildNode = super.cloneNode(deep) as ChildNode;
			// Need to break the association w/ original kids
			newnode._previousSibling = null;
			newnode._nextSibling = null;
			newnode.isFirstChild = false;
			return newnode;
		}


		override internal function get parentNodeInternal():NodeImpl {
			// if we have an owner, ownerNode is our parent, otherwise it's
			// our ownerDocument and we don't have a parent
			return isOwned ? ownerNode : null;
		}

		internal function get previousSiblingInternal():ChildNode {
			// if we are the firstChild, previousSibling actually refers to our
			// parent's lastChild, but we hide that
			return isFirstChild ? null : _previousSibling;
		}
	}
}
