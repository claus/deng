package deng.dom
{
	import org.w3c.dom.*;

	public class TextImpl extends CharacterDataImpl implements CharacterData, Text
	{
		public function TextImpl(owner:DocumentImpl, data:String)
		{
			super(owner, data);
		}
		
		public function setValues(owner:DocumentImpl, data:String):void {
			flags = 0;
			_nextSibling = null;
			_previousSibling = null;
			ownerDocumentInternal = owner;
			super.data = data;
		}
		
		override public function get nodeType():int {
			return NodeImpl.TEXT_NODE;
		}
		
		override public function get nodeName():String {
			return "#text";
		}

		public function set ignorableWhitespace(ignore:Boolean):void {
			if(needsSyncData) {
				synchronizeData();
			}
			isIgnorableWhitespace = ignore;
		}

		public function get isElementContentWhitespace():Boolean {
			// REVISIT: is this implemenation correct?
			if(needsSyncData) {
				synchronizeData();
			}
			return internalIsIgnorableWhitespace;
		}

		public function get wholeText():String {
			if(needsSyncData) {
				synchronizeData();
			}
			var buffer:String = "";
			if(_data != null && _data.length != 0) {
				buffer += data;
			}
			// concatenate text of logically adjacent text nodes to the left of this node in the tree
			var temp:String = getWholeTextBackward(previousSibling, buffer, parentNode);
			// concatenate text of logically adjacent text nodes to the right of this node in the tree
			return temp + getWholeTextForward(nextSibling, "", parentNode);
		}

		internal function insertTextContent(buf:String):String {
			var content:String = nodeValue;
			if(content != null) {
				return content + buf;
			} else {
				return buf;
			}
		}
		
		// CW:: REVISIT:
		private function getWholeTextForward(node:Node, buffer:String, parent:Node):String {
			// boolean to indicate whether node is a child of an entity reference
			var inEntRef:Boolean = false;
			if(parent != null) {
				inEntRef = (parent.nodeType == NodeImpl.ENTITY_REFERENCE_NODE);
			}
			while(node != null) {
				var type:int = node.nodeType;
				if(type == NodeImpl.ENTITY_REFERENCE_NODE) {
					return getWholeTextForward(node.firstChild, buffer, node);
				} else if(type == NodeImpl.TEXT_NODE || type == NodeImpl.CDATA_SECTION_NODE) {
					buffer += NodeImpl(node).textContent;
				} else {
					return "";
				}
				node = node.nextSibling;
			}
			// if the parent node is an entity reference node, must 
			// check nodes to the right of the parent entity reference 
			// node for logically adjacent text nodes
			if(inEntRef) {
				return getWholeTextForward(parent.nextSibling, buffer, parent.parentNode);
			}
			return "";
		}

		// CW:: REVISIT:
		private function getWholeTextBackward(node:Node, buffer:String, parent:Node):String {
			// boolean to indicate whether node is a child of an entity reference
			var inEntRef:Boolean = false;
			if(parent != null) {
				inEntRef = (parent.nodeType == NodeImpl.ENTITY_REFERENCE_NODE);
			}
			while(node != null) {
				var type:int = node.nodeType;
				if(type == NodeImpl.ENTITY_REFERENCE_NODE) {
					return getWholeTextBackward(node.lastChild, buffer, node);
				} else if(type == NodeImpl.TEXT_NODE || type == NodeImpl.CDATA_SECTION_NODE) {
					TextImpl(node).insertTextContent(buffer);
				} else {
					return "";
				}
				node = node.previousSibling;
			}
			// if the parent node is an entity reference node, must 
			// check nodes to the left of the parent entity reference 
			// node for logically adjacent text nodes
			if(inEntRef) {
				return getWholeTextBackward(parent.previousSibling, buffer, parent.parentNode);
			}
			return "";
		}

		public function replaceWholeText(content:String):Text {
			// CW:: TODO:
			return null;
		}
		
		public function splitText(offset:int):Text {
			// CW:: TODO:
			return null;
		}
		
		public function isWhitespaceInElementContent():Boolean {
			// CW:: TODO:
			return false;
		}
	}
}