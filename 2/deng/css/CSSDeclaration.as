package deng.css
{
	import deng.css.*;
	
	public class CSSDeclaration
	{
		private var _property:String;
		private var _propertyShort:String;
		private var _value:CSSExpr;
		private var _priority:Boolean = false;
		
		
		public function CSSDeclaration()
		{
		}
	
		
		public function get property():String {
			return _property;
		}
		public function set property(aProperty:String):void {
			if (aProperty && aProperty.length > 0) {
				_property = aProperty;
				_propertyShort = aProperty.split("-").join("");
			} else {
				_property = _propertyShort = null;
			}
		}
	
		
		public function get value():CSSExpr {
			return _value;
		}
		public function set value(aValue:CSSExpr):void {
			_value = aValue;
		}
	
		
		public function get priority():Boolean {
			return _priority;
		}
		public function set priority(aPriority:Boolean):void {
			_priority = aPriority;
		}
		

		public function get propertyShort():String {
			return _propertyShort;
		}

		
		public function get isWellformed():Boolean {
			return (property != null && value != null);
		}
		
	
		////////////////////////////////////////////////////////
		// toString
		////////////////////////////////////////////////////////

		public function toString():String {
			var s:String = "";
			if (isWellformed) {
				s += property + ": " + value.toString();
				if(priority) { s += " !important"; }
			} else {
				s += "###MALFORMED###";
			}
			return s;
		}
	}
}
