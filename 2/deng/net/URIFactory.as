package deng.net
{
	import deng.net.URI;

	public class URIFactory
	{
		public function URIFactory(dummy:Dummy) {
			// prevent instantiation
		}
		
		public static function createURI(input:String):URI {
			var uri:URI = new URI();
			uri.parse(input, false);
			return uri;
		}
	}
}

class Dummy {
	public function Dummy() {}
}