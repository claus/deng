package deng.dom
{
	import org.w3c.dom.Node;
	
	public class NamedNodeMapItem
	{
		protected var _node:Node;
		protected var _arrIndex:uint;
		
		public function NamedNodeMapItem(node:Node, arrIndex:uint)
		{
			_node = node;
			_arrIndex = arrIndex;
		}
		
		public function get node():Node {
			return _node;
		}
		
		public function set node(arg:Node):void {
			_node = arg;
		}
		
		public function get arrIndex():uint {
			return _arrIndex;
		}
		
		public function set arrIndex(arg:uint):void {
			_arrIndex = arg;
		}
	}
}