package deng.dom
{
	import org.w3c.dom.Node;
	import org.w3c.dom.EntityReference;
	import org.w3c.dom.UserDataHandler;

	public class EntityReferenceImpl extends ParentNode implements EntityReference
	{
		public function EntityReferenceImpl(owner:DocumentImpl, name:String)
		{
			super(owner);
			//this.name = name;
			isReadOnly = true;
			needsSyncChildren = true;
		}
	}
}