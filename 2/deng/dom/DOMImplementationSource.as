package deng.dom
{
	import deng.StringUtils;
	import org.w3c.dom.IDOMImplementation;
	import org.w3c.dom.IDOMImplementationList;
	import org.w3c.dom.IDOMImplementationSource;

	public class DOMImplementationSource
		implements IDOMImplementationSource
	{
		public function getDOMImplementation(features:String):IDOMImplementation {
			var impl:IDOMImplementation = DOMImplementation.getInstance();
			if(testImpl(impl, features)) {
				return impl;
			}
			// more implementations of this source may be added here
			// i.e. sub/superclasses of DOMImplementation
			return null;
		}
		
		public function getDOMImplementations(features:String):IDOMImplementationList {
			var implementations:Array = [];
			var impl:IDOMImplementation = DOMImplementation.getInstance();
			if(testImpl(impl, features)) {
				implementations.addElement(impl);
			}
			// more implementations of this source may be added here
			// i.e. sub/superclasses of DOMImplementation
			return new DOMImplementationList(implementations);
		}
		
		private function testImpl(impl:IDOMImplementation, features:String):Boolean {
			var fa:Array = StringUtils.condenseWhitespace(features).split(" ");
			for(var i:int = 0; i < fa.length; i++) {
				var feature:String = fa[i];
				var version:String = null;
				if(i < fa.length - 1) {
					var c:Number = fa[i + 1].charCodeAt(0);
					if(c >= 0x30 && c <= 0x39) {
						version = fa[++i];
					}
				}
				if(!impl.hasFeature(feature, version)) {
					return false;
				}
			}
			return true;
		}
	}
}