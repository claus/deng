package deng.dom
{
	import org.w3c.dom.*;
	import flash.utils.Dictionary;

	public class NamedNodeMapImpl implements NamedNodeMap
	{
		internal static const READONLY:uint = 0x0001;
		internal static const CHANGED:uint = 0x0002;
		internal static const HASDEFAULTS:uint = 0x0004;

		internal var _ownerNode:NodeImpl;

		internal var flags:uint = 0;

		internal var nodes:Array;
		internal var nodeMap:Dictionary;
		internal var nodeMapNS:Dictionary;

		
		public function NamedNodeMapImpl(owner:NodeImpl)
		{
			_ownerNode = owner;
		}

		
		public function get length():int {
			return (nodes != null) ? nodes.length : 0;
		}
		
		public function item(index:int):Node {
			return (nodes != null && index < nodes.length) ? nodes[index] as Node : null;
		}
		
		public function getNamedItem(name:String):Node {
			var i:int = findNamePoint(name, 0);
			return (i < 0) ? null : nodes[i] as Node;
		}
		
		public function getNamedItemNS(nsURI:String, locName:String):Node {
			var i:int = findNamePointNS(nsURI, locName);
			return (i < 0) ? null : nodes[i] as Node;
		}
		
		public function setNamedItem(arg:Node):Node {
			var ownerDoc:DocumentImpl = _ownerNode.ownerDocumentInternal;
			if(ownerDoc.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(arg.ownerDocument != ownerDoc) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
			}
			var i:int = findNamePoint(arg.nodeName, 0);
			var previous:NodeImpl = null;
			if(i >= 0) {
				previous = nodes[i] as NodeImpl;
				nodes[i] = arg;
			} else {
				i = -1 - i; // Insert point (may be end of list)
				if(nodes == null) {
					nodes = [];
				}
				nodes.splice(i, 0, arg);
			}
			return previous;
		}
		
		public function setNamedItemNS(arg:Node):Node {
			var ownerDoc:DocumentImpl = _ownerNode.ownerDocumentInternal;
			if(ownerDoc.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(arg.ownerDocument != ownerDoc) {
					throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
				}
			}
			var i:int = findNamePointNS(arg.namespaceURI, arg.localName);
			var previous:NodeImpl = null;
			if(i >= 0) {
				previous = nodes[i] as NodeImpl;
				nodes[i] = arg;
			} else {
				// If we can't find by namespaceURI, localName, then we find by
				// nodeName so we know where to insert.
				i = findNamePoint(arg.nodeName, 0);
				if(i >= 0) {
					previous = nodes[i] as NodeImpl;
					nodes.splice(i, 0, arg);
				} else {
					i = -1 - i; // Insert point (may be end of list)
					if(nodes == null) {
						nodes = [];
					}
					nodes.splice(i, 0, arg);
				}
			}
			return previous;
		}
		
		public function removeNamedItem(name:String):Node {
			if(isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			var i:int = findNamePoint(name, 0);
			if(i < 0) {
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			var n:NodeImpl = nodes[i] as NodeImpl;
			nodes.splice(i, 1);
			return n;
		}
		
		public function removeNamedItemNS(nsURI:String, locName:String):Node {
			if(isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			var i:int = findNamePointNS(nsURI, locName);
			if(i < 0) {
				throw new DOMException(DOMException.NOT_FOUND_ERR);
			}
			var n:NodeImpl = nodes[i] as NodeImpl;
			nodes.splice(i, 1);
			return n;
		}


		internal function get isReadOnly():Boolean {
			return (flags & READONLY) != 0;
		}
		
		internal function set isReadOnly(value:Boolean):void {
			flags = value ? (flags | READONLY) : (flags & ~READONLY);
		}
		
		internal function getReadOnly():Boolean {
			return isReadOnly;
		}

		internal function setReadOnly(value:Boolean, deep:Boolean):void {
			isReadOnly = value;
			if(deep && nodes != null) {
				for(var i:int = nodes.length - 1; i >= 0; i--) {
					NodeImpl(nodes[i]).setReadOnly(value, deep);
				}
			}
		}

		internal function get changed():Boolean {
			return (flags & CHANGED) != 0;
		}
		
		internal function set changed(value:Boolean):void {
			flags = value ? (flags | CHANGED) : (flags & ~CHANGED);
		}
		
		internal function get hasDefaults():Boolean {
			return (flags & HASDEFAULTS) != 0;
		}
		
		internal function set hasDefaults(value:Boolean):void {
			flags = value ? (flags | HASDEFAULTS) : (flags & ~HASDEFAULTS);
		}
		
		internal function set ownerDocumentInternal(doc:DocumentImpl):void {
			if(nodes != null) {
				for(var i:int = 0; i < nodes.length; i++) {
					NodeImpl(item(i)).ownerDocumentInternal = doc;
				}
			}
		}

		
		public function cloneMap(owner:NodeImpl):NamedNodeMapImpl {
			var newmap:NamedNodeMapImpl = new NamedNodeMapImpl(owner);
			newmap.cloneContent(this);
			return newmap;
		}
		
		internal function cloneContent(srcMap:NamedNodeMapImpl):void {
			var srcNodes:Array = srcMap.nodes;
			if(srcNodes != null) {
				var size:int = srcNodes.length;
				if(size != 0) {
					if(nodes == null) {
						nodes = [];
					}
					for(var i:int = 0; i < size; ++i) {
						var n:NodeImpl = srcMap.nodes[i] as NodeImpl;
						var clone:NodeImpl = n.cloneNode(true) as NodeImpl;
						clone.isSpecified = n.isSpecified;
						nodes[i] = clone;
					}
				}
			}
		}
		
		internal function getNamedItemIndex(nsURI:String, locName:String):int {
			return findNamePointNS(nsURI, locName);
		}

		
		internal function findNamePoint(name:String, start:int):int {
			// Binary search
			var i:int = 0;
			if(nodes != null) {
				var first:int = start;
				var last:int = nodes.length - 1;
				while(first <= last) {
					i = (first + last) / 2;
					var nname:String = Node(nodes[i]).nodeName;
					if(name == nname) {
						return i; // Name found
					} else if(name < nname) {
						last = i - 1;
					} else {
						first = i + 1;
					}
				}
				if(first > i) {
					i = first;
				}
			}
			return -1 - i; // not-found has to be encoded.
		}
		
		internal function findNamePointNS(nsURI:String, name:String):int {
			if(nodes == null) { return -1; }
			if(name == null) { return -1; }
			// This is a linear search through the same nodes Vector.
			// The Vector is sorted on the DOM Level 1 nodename.
			// The DOM Level 2 NS keys are namespaceURI and Localname, 
			// so we must linear search thru it.
			// In addition, to get this to work with nodes without any namespace
			// (namespaceURI and localNames are both null) we then use the nodeName
			// as a seconday key.
			for(var i:int = 0; i < nodes.length; i++) {
				var a:NodeImpl = nodes[i] as NodeImpl;
				var aNamespaceURI:String = a.namespaceURI;
				var aLocalName:String = a.localName;
				if(nsURI == null) {
					if(aNamespaceURI == null && (name == aLocalName || (aLocalName == null && name == a.nodeName))) {
						return i;
					}
				} else {
					if(nsURI == aNamespaceURI && name == aLocalName) {
						return i;
					}
				}
			}
			return -1;
		}
	}
}
