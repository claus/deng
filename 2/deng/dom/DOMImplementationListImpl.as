package deng.dom
{
	import flash.utils.Proxy;
	import org.w3c.dom.*;

	public class DOMImplementationListImpl extends Proxy implements DOMImplementationList
	{
		private var arr:Array; // of type IDOMImplementation
		
		public function DOMImplementationListImpl(initArr:Array = null) {
			if(initArr == null) {
				arr = [];
			} else {
				arr = initArr.slice();
			}
		}
	
		public function item(index:int):DOMImplementation {
			return arr[index] as DOMImplementation;
		}
		
		public function get length():int {
			return arr.length;
		}
	}
}
