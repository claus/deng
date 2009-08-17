package deng.dom
{
	import deng.dom.*;
	import org.w3c.dom.*;

	public class DOMImplementation implements IDOMImplementation
	{
		private static var instance:DOMImplementation;
		
		private static var features:Array = [
			new DOMFeature("Core", 3, 1),
			new DOMFeature("XML", 3, 1),
			new DOMFeature("LS", 3),
		];
		
		public function DOMImplementation(dummy:Dummy) {}
		
		public static function getInstance():DOMImplementation {
			if(instance == null) {
				instance = new DOMImplementation(new Dummy());
			}
			return instance;
		}
		
		// -------
		//   DOM
		// -------
		
		public function hasFeature(feature:String, version:String):Boolean {
			for(var i:Number = 0; i < features.length; i++) {
				var f:DOMFeature = features[i] as DOMFeature;
				if(f.match(feature, version)) {
					return true;
				}
			}
			return false;
		}
		
		public function createDocumentType(qualifiedName:String, publicId:String, systemId:String):IDocumentType {
			// CW:: TODO: Check QName syntax
			// prefix = ([A-Za-z][A-Za-z0-9_]*)? | '_'
			// name = [A-Za-z0-9_]+
			return new DocumentType(qualifiedName, publicId, systemId);
		}
		
		public function createDocument(namespaceURI:String, qualifiedName:String, doctype:IDocumentType):IDocument {
			return null;
		}
		
		public function getFeature(feature:String, version:String):Object {
			return instance;
		}
	}
}

// ----------------------------------------
//   Classes private to DOMImplementation
// ----------------------------------------

class Dummy { public function Dummy() {} }

