package deng.dom
{
	import flash.utils.Proxy;
	import org.w3c.dom.*;

	public class DOMImplementationList extends Proxy implements IDOMImplementationList
	{
		private var arr:Array; // of type IDOMImplementation
		
		public function DOMImplementationList(initArr:Array = null) {
			if(initArr == null) {
				arr = [];
			} else {
				arr = initArr.slice();
			}
		}
	
		public function item(index:int):IDOMImplementation {
			return IDOMImplementation(arr[index]);
		}
		
		public function get length():int {
			return arr.length;
		}
		
	}
}
