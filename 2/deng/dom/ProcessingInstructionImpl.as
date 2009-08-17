package deng.dom
{
	import org.w3c.dom.*;

	public class ProcessingInstructionImpl extends CharacterDataImpl implements ProcessingInstruction
	{
		internal var _target:String;
		
		public function ProcessingInstructionImpl(owner:DocumentImpl, target:String, data:String)
		{
			super(owner, data);
			_target = target;
		}
		
		public function get target():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _target;
		}
		
		override public function get data():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _data;
		}
		
		override public function set data(value:String):void {
			// Hand off to setNodeValue for code-reuse reasons (mutation
			// events, readonly protection, synchronizing, etc.)
			nodeValue = value;
		}
		
		override public function get nodeType():int {
			return NodeImpl.PROCESSING_INSTRUCTION_NODE;
		}
		
		override public function get nodeName():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _target;
		}
		
		override public function get baseURI():String {
			if(needsSyncData) {
				synchronizeData();
			}
			return _ownerNode.baseURI;
		}
	}
}