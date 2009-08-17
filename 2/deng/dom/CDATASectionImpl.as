package deng.dom
{
	import org.w3c.dom.CDATASection;

	public class CDATASectionImpl extends TextImpl implements CDATASection
	{
		public function CDATASectionImpl(owner:DocumentImpl, data:String)
		{
			super(owner, data);
		}
	}
}