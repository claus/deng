package deng.dom
{
	import deng.dom.*;
	import deng.dom.etc.DOMFeature;
	import deng.util.XMLChar;
	import org.w3c.dom.*;

	public class DOMImplementationImpl implements DOMImplementation
	{
		private static var instance:DOMImplementationImpl;
		
		// This DOM implementation supports the DOM3 modules Core, XML and LS/LS-Async.
		private static var features:Array = [
			new DOMFeature("Core", 3, 1),
			new DOMFeature("XML", 3, 1),
			new DOMFeature("LS", 3),
			new DOMFeature("LS-Async", 3)
		];
		
		private var docAndDoctypeCounter:uint = 0;
		
		
		public function DOMImplementationImpl(dummy:Dummy) {
			if(dummy == null) {
				throw new Error("DOMImplementationImpl is a singleton. Use DOMImplementationImpl.getInstance().");
			}
		}
		
		public static function getInstance():DOMImplementationImpl {
			if(instance == null) {
				instance = new DOMImplementationImpl(new Dummy());
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
		
		public function createDocumentType(qName:String, pubId:String, sysId:String):DocumentType {
			// REVISIT: this might allow creation of invalid name for DOCTYPE xmlns prefix.
			// also there is no way for a user to turn off error checking.
			checkQName(qName);
			return new DocumentTypeImpl(null, qName, pubId, sysId);
		}
		
		public function createDocument(nsURI:String, qName:String, doctype:DocumentType):Document {
			if(nsURI == null && qName == null && doctype == null) {
				// if namespaceURI, qualifiedName and doctype are null, 
				// returned document is empty with no document element
				return new DocumentImpl();
			} else if(doctype != null && doctype.ownerDocument != null) {
				throw new DOMException(DOMException.WRONG_DOCUMENT_ERR);
			}
			var doc:DocumentImpl = new DocumentImpl(doctype);
			var e:Element = doc.createElementNS(nsURI, qName);
			doc.appendChild(e);
			return doc;
		}
		
		public function getFeature(feature:String, version:String):Object {
			if(hasFeature(feature, version)) {
				return instance;
			}
			return null;
		}


		// ----------
		//   DOM LS
		// ----------
		
		// CW:: TODO:
		//public LSParser createLSParser(short mode, String schemaType) ..

		// CW:: TODO:
		//public LSSerializer createLSSerializer() { ..
		
		// CW:: TODO:
		//public LSInput createLSInput() {
		
		// CW:: TODO:
		//synchronized RevalidationHandler getValidator(String schemaType, String xmlVersion) { ..
		
		// CW:: TODO:
		//synchronized void releaseValidator(String schemaType, String xmlVersion, RevalidationHandler validator) { ..
		
		// CW:: TODO:
		//synchronized final XMLDTDLoader getDTDLoader(String xmlVersion) { ..
		
		// CW:: TODO:
		//synchronized final void releaseDTDLoader(String xmlVersion, XMLDTDLoader loader) { ..
		
		// CW:: TODO:
		//public LSOutput createLSOutput() { ..


		internal function assignDocumentNumber():uint {
			return ++docAndDoctypeCounter;
		}
		
		internal function assignDocTypeNumber():uint {
			return ++docAndDoctypeCounter;
		}


		protected function checkQName(qname:String):void {
			var index:int = qname.indexOf(':');
			var lastIndex:int = qname.lastIndexOf(':');
			var length:int = qname.length;
			// It is an error for NCName to have more than one ':'
			// Check if it is a valid QName [Namespace in XML production 6]
			if(index == 0 || index == length - 1 || lastIndex != index) {
				throw new DOMException(DOMException.NAMESPACE_ERR);
			}
			var i:int;
			var start:int = 0;
			// Namespace in XML production [6]
			if(index > 0) {
				// check that prefix is NCName
				if(!XMLChar.isNCNameStart(qname.charCodeAt(start))) {
					throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
				}
				for(i = 1; i < index; i++) {
					if(!XMLChar.isNCName(qname.charCodeAt(i))) {
						throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
					}
				}
				start = index + 1;
			}
			// check local part
			if(!XMLChar.isNCNameStart(qname.charCodeAt(start))) {
				throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
			}
			for(i = start + 1; i < length; i++) {
				if(!XMLChar.isNCName(qname.charCodeAt(i))) {
					throw new DOMException(DOMException.INVALID_CHARACTER_ERR);
				}
			}
		}
	}
}

// ----------------------------------------
//   Classes private to DOMImplementation
// ----------------------------------------

class Dummy { public function Dummy() {} }

