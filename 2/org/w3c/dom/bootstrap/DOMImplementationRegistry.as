package org.w3c.dom.bootstrap
{
	import org.w3c.dom.IDOMImplementation;
	import org.w3c.dom.IDOMImplementationList;
	import org.w3c.dom.IDOMImplementationSource;
	
	import deng.dom.DOMImplementationSource;

	public final class DOMImplementationRegistry
	{
		private static var sources:Array; // of type IDOMImplementationSource
		
		private static var instance:DOMImplementationRegistry;
		
		public function DOMImplementationRegistry(dummy:Dummy) {
			sources = [];
			addSource(new deng.dom.DOMImplementationSource());
		}
		
		public static function getInstance():DOMImplementationRegistry {
			if(instance == null) {
				instance = new DOMImplementationRegistry(new Dummy());
			}
			return instance;
		}
		
		// -------
		//   DOM
		// -------
		
		public function getDOMImplementation(features:String):IDOMImplementation {
			for (var i:int = 0; i < sources.length; i++) {
				var src:IDOMImplementationSource = IDOMImplementationSource(sources[i]);
				var impl:IDOMImplementation = src.getDOMImplementation(features);
				if (impl != null) {
					return impl;
				}
			}
			return null;
		}
		
		public function getDOMImplementations(features:String):IDOMImplementationList {
			var implementations:Array = [];
			for(var i:int = 0; i < sources.length; i++) {
				var src:IDOMImplementationSource = IDOMImplementationSource(sources[i]);
				var impls:IDOMImplementationList = src.getDOMImplementations(features);
				for(var j:int = 0; j < impls.length; j++) {
					var impl:IDOMImplementation = impls.item(j);
					implementations.push(impl);
				}
			}
			return new DOMImplementationList(implementations);
		}

		// --------------------------
		//   Proprietary extensions
		// --------------------------
		
		public static function addSource(source:IDOMImplementationSource, index:int = -1):void {
			if(sources.indexOf(source) == -1) {
				if(index < 0 || index > sources.length - 1) {
					sources.push(source);
				} else {
					sources.splice(index, 0, source);
				}
			}
		}
	}
}

// ------------------------------------------------
//   Classes private to DOMImplementationRegistry
// ------------------------------------------------

class Dummy { public function Dummy() {} }

import org.w3c.dom.IDOMImplementation;
import org.w3c.dom.IDOMImplementationList;
class DOMImplementationList implements IDOMImplementationList {
	private var arr:Array;
	public function DOMImplementationList(array:Array) { arr = array; }
	public function item(index:int):IDOMImplementation { return IDOMImplementation(arr[index]); }
	public function get length():int { return arr.length; }
}
