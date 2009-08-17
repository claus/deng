package deng.dom
{
	import org.w3c.dom.*;

	public class CommentImpl extends CharacterDataImpl implements CharacterData, Comment
	{
		public function CommentImpl(owner:DocumentImpl, data:String)
		{
			super(owner, data);
		}
		
		override public function get nodeType():int {
			return NodeImpl.COMMENT_NODE;
		}
		
		override public function get nodeName():String {
			return "#comment";
		}
	}
}