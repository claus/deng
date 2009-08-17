package deng.dom
{
	import org.w3c.dom.*;

	public class DocumentFragmentImpl extends ParentNode implements DocumentFragment
	{
		public function DocumentFragmentImpl(owner:DocumentImpl)
		{
			super(owner);
		}
	}
}