package deng.dom
{
	public class NodeListCache
	{
		internal var length:int = -1;
		internal var childIndex:int = -1;
		internal var child:ChildNode;
		internal var owner:ParentNode;
		internal var next:NodeListCache;
		
		public function NodeListCache(owner:ParentNode) {
			this.owner = owner;
		}
	}
}