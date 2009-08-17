package deng.dom
{
	import org.w3c.dom.*;
	import deng.dom.*;
	import flash.utils.Dictionary;

	public class DocumentTypeImpl extends ParentNode implements DocumentType
	{
		private var _name:String;
		private var _publicId:String;
		private var _systemId:String;
		private var _internalSubset:String;
		private var _entities:NamedNodeMapImpl;
		private var _notations:NamedNodeMapImpl;
		private var _elements:NamedNodeMapImpl;
		
		private var doctypeNumber:int = 0;
		private var userData:Dictionary;
		
		public function DocumentTypeImpl(owner:DocumentImpl, name:String, publicId:String, systemId:String) {
			super(owner);
			_name = name;
			_publicId = publicId;
			_systemId = systemId;
			_entities = new NamedNodeMapImpl(this);
			_notations = new NamedNodeMapImpl(this);
			_elements = new NamedNodeMapImpl(this);
		}
		
		public function get name():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _name;
		}
		
		public function get publicId():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _publicId;
		}

		public function get systemId():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _systemId;
		}
		
		public function get internalSubset():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _internalSubset;
		}
		
		public function set internalSubset(value:String):void {
			if(needsSyncData) {
				synchronizeData();
			}
			_internalSubset = value;
		}
		
		public function get entities():NamedNodeMap {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return _entities;
		}
		
		public function get notations():NamedNodeMap {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return _notations;
		}
		
		public function get elements():NamedNodeMap {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			return _elements;
		}
		

		override public function get nodeName():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _name;
		}
		
		override public function get nodeType():int {
			return DOCUMENT_TYPE_NODE;
		}
		
		override public function get textContent():String {
			return null;
		}
		
		override public function set textContent(value:String):void {
			// Do nothing.
		}


		override public function isEqualNode(other:Node):Boolean {
			if(!super.isEqualNode(other)) {
				return false;
			}
			if(needsSyncData) {
				synchronizeData();
			}
			var otherImpl:DocumentTypeImpl = other as DocumentTypeImpl;
			// Test if the following string attributes are equal: 
			// publicId, systemId, internalSubset.
			if(publicId != otherImpl.publicId || systemId != otherImpl.systemId || internalSubset != otherImpl.internalSubset) {
				return false;
			}
			//test if NamedNodeMaps entities and notations are equal
			var i:uint;
			var otherEntities:NamedNodeMapImpl = otherImpl._entities;
			var thisEntities:NamedNodeMapImpl = _entities;
			if(thisEntities.length != otherEntities.length) {
				return false;
			} else {
				var thisEntitiesLen:uint = thisEntities.length;
				for(i = 0; i < thisEntitiesLen; i++) {
					var entNode:NodeImpl = thisEntities.item(i) as NodeImpl;
					if(!entNode.isEqualNode(otherEntities.getNamedItem(entNode.nodeName))) {
						return false;
					}
				}
			}
			var otherNotations:NamedNodeMapImpl = otherImpl._notations;
			var thisNotations:NamedNodeMapImpl = _notations;
			if(thisNotations.length != otherNotations.length) {
				return false;
			} else {
				var thisNotationsLen:uint = thisNotations.length;
				for(i = 0; i < thisNotationsLen; i++) {
					var notNode:NodeImpl = thisNotations.item(i) as NodeImpl;
					if(!notNode.isEqualNode(otherNotations.getNamedItem(notNode.nodeName))) {
						return false;
					}
				}
			}
			return true;
		}

		override public function cloneNode(deep:Boolean):Node {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			var newnode:DocumentTypeImpl = super.cloneNode(deep) as DocumentTypeImpl;
			// NamedNodeMaps must be cloned explicitly, to avoid sharing them.
			newnode._entities = _entities.cloneMap(newnode);
			newnode._notations = _notations.cloneMap(newnode);
			newnode._elements = _elements.cloneMap(newnode);
			return newnode;
		}

		override public function setUserData(key:String, data:Object, handler:UserDataHandler):Object {
			if(userData == null) {
				userData = new Dictionary(true);
			}
			var o:UserDataRecord = userData[key] as UserDataRecord;
			if(data == null) {
				delete userData[key];
			} else {
				userData[key] = new UserDataRecord(data, handler);
			}
			return (o != null) ? o.data : null;
		}

		override public function getUserData(key:String):Object {
			if(userData != null) {
				var o:UserDataRecord = userData[key] as UserDataRecord;
				return (o != null) ? o.data : null;
			}
			return null;
		}


		override internal function set ownerDocumentInternal(doc:DocumentImpl):void {
			super.ownerDocumentInternal = doc;
			_entities.ownerDocumentInternal = doc;
			_notations.ownerDocumentInternal = doc;
			_elements.ownerDocumentInternal = doc;
		}
		
		override public function setReadOnly(value:Boolean, deep:Boolean):void {
			if(needsSyncChildren) {
				synchronizeChildren();
			}
			super.setReadOnly(value, deep);
			_elements.setReadOnly(value, true);
			_entities.setReadOnly(value, true);
			_notations.setReadOnly(value, true);
		}
		
		override internal function get nodeNumber():int {
			// If the doctype has a document owner, 
			// get the node number relative to the owner doc
			if(ownerDocument != null) {
				return super.nodeNumber;
			}
			// The doctype is disconnected and not associated with any document.
			// Assign the doctype a number relative to the implementation.
			if(doctypeNumber == 0) {
				var cd:DOMImplementationImpl = DOMImplementationImpl.getInstance();
				doctypeNumber = cd.assignDocTypeNumber();
			}
			return doctypeNumber;
		}
	}
}