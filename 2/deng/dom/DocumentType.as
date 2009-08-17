package deng.dom
{
	import org.w3c.dom.*;
	import deng.dom.*;

	public class DocumentType extends Node
		implements IDocumentType
	{
		private var _name:String;
		private var _entities:NamedNodeMap;
		private var _notations:NamedNodeMap;
		private var _systemId:String;
		private var _publicId:String;
		private var _internalSubset:String;
		
		public function DocumentType(name:String, publicId:String, systemId:String, internalSubset:String = null, entities:INamedNodeMap = null, notations:INamedNodeMap = null) {
			_name = name;
			_entities = entities;
			_notations = notations;
			_systemId = systemId;
			_publicId = publicId;
			_internalSubset = internalSubset;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get entities():NamedNodeMap {
			return _entities;
		}
		
		public function get notations():NamedNodeMap {
			return _notations;
		}
		
		public function get systemId():String {
			return _systemId;
		}
		
		public function get publicId():String {
			return _publicId;
		}
		
		public function get internalSubset():String {
			return _internalSubset;
		}
	}
}