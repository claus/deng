package deng.dom
{
	import org.w3c.dom.*;
	
	public class CharacterDataImpl extends ChildNode
	{
		internal var _data:String;
		
		private static var singletonNodeList:NodeList = new EmptyNodeList();
		
		public function CharacterDataImpl(owner:DocumentImpl, data:String)
		{
			super(owner);
			_data = data;
		}
		
		override public function get childNodes():NodeList {
			return singletonNodeList;
		}

		override public function get nodeValue():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _data;
		}
		
		internal function setNodeValueInternal(value:String, replace:Boolean = false):void {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			if(ownerDoc.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			// revisit: may want to set the value in ownerDocument.
			// Default behavior, overridden in some subclasses
			if(needsSyncData) {
				synchronizeData();
			}
			// keep old value for document notification
			var oldvalue:String = _data;
			// notify document
			ownerDoc.modifyingCharacterData(this, replace);
			_data = value;
			// notify document
			ownerDoc.modifiedCharacterData(this, oldvalue, value, replace);
		}
		
		override public function set nodeValue(value:String):void {
			setNodeValueInternal(value);
			// notify document
			ownerDocumentInternal.replacedText(this);
		}
		
		public function get data():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _data;
		}
		
		public function set data(value:String):void {
			nodeValue = value;
		}

		override public function get length():int {   
			if(needsSyncData) {
				synchronizeData();
			}
			return _data.length;
		}
		
		public function appendData(data:String):void {
			if(isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(data == null) {
				return;
			}
			if(needsSyncData) {
				synchronizeData();
			}
			nodeValue = _data + data;
		}
		
		public function deleteData(offset:int, count:int):void {
			internalDeleteData(offset, count, false);
		}
		
		internal function internalDeleteData(offset:int, count:int, replace:Boolean):void {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			if(ownerDoc.errorChecking) {
				if(isReadOnly) {
					throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
				}
				if(count < 0) {
					throw new DOMException(DOMException.INDEX_SIZE_ERR);
				}
			}
			if(needsSyncData) {
				synchronizeData();
			}
			var tailLength:int = Math.max(_data.length - count - offset, 0);
			try {
				var value:String = _data.substring(0, offset);
				if(tailLength > 0) {
					value += _data.substring(offset + count, offset + count + tailLength)
				}
				setNodeValueInternal(value, replace);
				// notify document
				ownerDoc.deletedText(this, offset, count);
			}
			catch(e:Error) {
				throw new DOMException(DOMException.INDEX_SIZE_ERR);
			}
		}
		
		public function insertData(offset:int, data:String):void {
			internalInsertData(offset, data, false);
		}
		
		internal function internalInsertData(offset:int, data:String, replace:Boolean):void {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			if(ownerDoc.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			try {
				var value:String = _data.substring(0, offset);
				value += data;
				value += _data.substring(offset);
				setNodeValueInternal(value, replace);
				// notify document
				ownerDoc.insertedText(this, offset, _data.length);
			}
			catch(e:Error) {
				throw new DOMException(DOMException.INDEX_SIZE_ERR);
			}
		}
		
		public function replaceData(offset:int, count:int, data:String):void {
			var ownerDoc:DocumentImpl = ownerDocumentInternal;
			// The read-only check is done by deleteData()
			// ***** This could be more efficient w/r/t Mutation Events,
			// specifically by aggregating DOMAttrModified and
			// DOMSubtreeModified. But mutation events are 
			// underspecified; I don't feel compelled
			// to deal with it right now.
			if(ownerDoc.errorChecking && isReadOnly) {
				throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR);
			}
			if(needsSyncData) {
				synchronizeData();
			}
			//notify document
			ownerDoc.replacingData(this);
			// keep old value for document notification
			var oldvalue:String = _data;
			internalDeleteData(offset, count, true);
			internalInsertData(offset, data, true);
			ownerDoc.replacedCharacterData(this, oldvalue, _data);
		}
		
		public function substringData(offset:int, count:int):String {
			if(needsSyncData) {
				synchronizeData();
			}
			var len:int = _data.length;
			if (count < 0 || offset < 0 || offset > len - 1) {
				throw new DOMException(DOMException.INDEX_SIZE_ERR);
			}
			var tailIndex:int = Math.min(offset + count, len);
			return data.substring(offset, tailIndex);
		}
	}
}

import org.w3c.dom.*;
class EmptyNodeList implements NodeList {
	public function item(index:int):Node { return null; }
	public function get length():int { return 0; }
}
