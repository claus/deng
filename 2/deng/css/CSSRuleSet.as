package deng.css
{
	import deng.css.*;
	
	public class CSSRuleSet
	{
		private var _selectors:Vector.<CSSSelector>;
		private var _declarations:Vector.<CSSDeclaration>;
	
		public function CSSRuleSet()
		{
			_selectors = new Vector.<CSSSelector>();
			_declarations = new Vector.<CSSDeclaration>();
		}
	
		
		public function get selectors():Vector.<CSSSelector> {
			return _selectors;
		}
		
		public function get declarations():Vector.<CSSDeclaration> {
			return _declarations;
		}
		

		public function addSelector(aSelector:CSSSelector):void {
			_selectors.push(aSelector);
		};
		
		public function addDeclaration(aDeclaration:CSSDeclaration):void {
			_declarations.push(aDeclaration);
		};
		
	
		////////////////////////////////////////////////////////
		// toString
		////////////////////////////////////////////////////////

		public function toString():String {
			var s:String = "";
			var i:uint = 0;
			var len:uint = selectors.length;
			for(; i < len; i++) {
				s += selectors[i].toString();
				if(i < len - 1) {
					s += ", ";
				} else {
					s += " { ";
				}
			}
			len = declarations.length;
			for(i = 0; i < len; i++) {
				s += declarations[i].toString();
				if(i < len - 1) {
					s += "; ";
				}
			}
			s += (len > 0) ? " }" : "}";
			return s;
		};
	}
}
