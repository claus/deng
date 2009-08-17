package deng.dom
{
	import flash.utils.Proxy;
	import org.w3c.dom.*;

	public class NodeList extends Proxy implements INodeList
	{
		private var arr:Array; // of type INode
		
		public function NodeList(initArr:Array = null) {
			if(initArr == null) {
				arr = [];
			} else {
				arr = initArr.slice();
			}
		}
	
		public function item(index:int):INode {
			return INode(arr[index]);
		}
		
		public function get length():int {
			return arr.length;
		}
	}
}
