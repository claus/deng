package deng.dom
{
	import flash.utils.Proxy;
	import org.w3c.dom.*;

	public class NodeListImpl extends Proxy implements NodeList
	{
		private var arr:Array; // of type INode
		
		public function NodeListImpl(initArr:Array = null) {
			if(initArr == null) {
				arr = [];
			} else {
				arr = initArr.slice();
			}
		}
	
		public function item(index:int):Node {
			return arr[index] as Node;
		}
		
		public function get length():int {
			return arr.length;
		}
	}
}
