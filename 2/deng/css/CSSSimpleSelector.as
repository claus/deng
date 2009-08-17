package deng.css
{
	public class CSSSimpleSelector
	{
		private var _sCombinator:String;
		private var _aElements:Array;
	
		public static const TYPE_ELEMENT:uint = 1;
		public static const TYPE_ELEMENT_NS:uint = 2;
		public static const TYPE_ID:uint = 10;
		public static const TYPE_CLASS:uint = 20;
		public static const TYPE_ATTRIBUTE:uint = 30;
		public static const TYPE_ATTRIBUTE_NS:uint = 31;
		public static const TYPE_PSEUDOCLASS:uint = 40;
		public static const TYPE_PSEUDOCLASS_NEG:uint = 41;
		public static const TYPE_PSEUDOCLASS_EXPR:uint = 42;
		public static const TYPE_PSEUDOELEMENT:uint = 50;
	
		public static const TYPE_ATTR_OP_NONE:uint = 0;
		public static const TYPE_ATTR_OP_EQ:uint = 1;
		public static const TYPE_ATTR_OP_WORD:uint = 2;
		public static const TYPE_ATTR_OP_LANG:uint = 3;
		public static const TYPE_ATTR_OP_SUBSTR:uint = 4;
		public static const TYPE_ATTR_OP_SUBSTR_BEGIN:uint = 5;
		public static const TYPE_ATTR_OP_SUBSTR_END:uint = 6;
		
		public function CSSSimpleSelector()
		{
			_sCombinator = "";
			_aElements = [];
		};
		
		public function addElementSelector(sName:String):void {
			_aElements.push({ type:TYPE_ELEMENT, name:sName });
		}
	
		public function addElementSelectorNS(sName:String, sPrefix:String):void {
			_aElements.push({ type:TYPE_ELEMENT_NS, name:sName, prefix:sPrefix });
		}
		
		public function addIDSelector(sName:String):void {
			_aElements.push({ type:TYPE_ID, name:sName });
		}
		
		public function addClassSelector(sName:String):void {
			_aElements.push({ type:TYPE_CLASS, name:sName });
		}
	
		public function addAttributeSelector(sName:String, nOperator:Number, sExpression:String):void {
			_aElements.push({ type:TYPE_ATTRIBUTE, name:sName, op:nOperator, expr:sExpression });
		}
	
		public function addAttributeSelectorNS(sName:String, sPrefix:String, nOperator:Number, sExpression:String):void {
			_aElements.push({ type:TYPE_ATTRIBUTE_NS, name:sName, prefix:sPrefix, op:nOperator, expr:sExpression });
		}
	
		public function addPseudoClassSelector(sName:String, sArg:String):void {
			_aElements.push({ type:TYPE_PSEUDOCLASS, name:sName, arg:sArg });
		}
	
		public function addPseudoClassExprSelector(sName:String, sArg:Object):void {
			_aElements.push({ type:TYPE_PSEUDOCLASS_EXPR, name:sName, arg:sArg });
		}
	
		public function addPseudoClassNegSelector(oSS:CSSSimpleSelector):void {
			_aElements.push({ type:TYPE_PSEUDOCLASS_NEG, name:"not", arg:oSS });
		}
	
		public function addPseudoElementSelector(sName:String, sArg:String):void {
			_aElements.push({ type:TYPE_PSEUDOELEMENT, name:sName, arg:sArg });
		}
	
		public function hasElements():Boolean {
			return (_aElements.length > 0);
		}
	
		public function setCombinator(sCombinator:String):void {
			_sCombinator = sCombinator;
		}


		////////////////////////////////////////////////////////
		// toString
		////////////////////////////////////////////////////////
	
		public function toString():String {
			var s:String = "";
			var i:Number = 0;
			var l:Number = _aElements.length;
			for(; i < l; i++) {
				var o:Object = _aElements[i];
				switch(o.type) {
					case TYPE_ELEMENT:
						if(o.name == "*" && i < l-1) {
						} else {
							s += o.name;
						}
						break;
					case TYPE_ELEMENT_NS:
						s += o.prefix + "|" + o.name;
						break;
					case TYPE_ID:
						s += "#" + o.name;
						break;
					case TYPE_CLASS:
						s += "." + o.name;
						break;
					case TYPE_ATTRIBUTE:
						s += "[" + o.name;
						if(o.op != TYPE_ATTR_OP_NONE) {
							switch(o.op) {
								case TYPE_ATTR_OP_EQ: s += "="; break;
								case TYPE_ATTR_OP_WORD: s += "~="; break;
								case TYPE_ATTR_OP_LANG: s += "|="; break;
								case TYPE_ATTR_OP_SUBSTR: s += "*="; break;
								case TYPE_ATTR_OP_SUBSTR_BEGIN: s += "^="; break;
								case TYPE_ATTR_OP_SUBSTR_END: s += "$="; break;
							}
							s += o.expr;
						}
						s +=  "]"
						break;
					case TYPE_ATTRIBUTE_NS:
						s += "[" + o.prefix + "|" + o.name;
						if(o.op != TYPE_ATTR_OP_NONE) {
							switch(o.op) {
								case TYPE_ATTR_OP_EQ: s += "="; break;
								case TYPE_ATTR_OP_WORD: s += "~="; break;
								case TYPE_ATTR_OP_LANG: s += "|="; break;
								case TYPE_ATTR_OP_SUBSTR: s += "*="; break;
								case TYPE_ATTR_OP_SUBSTR_BEGIN: s += "^="; break;
								case TYPE_ATTR_OP_SUBSTR_END: s += "$="; break;
							}
							s += o.expr;
						}
						s +=  "]"
						break;
					case TYPE_PSEUDOCLASS:
						s += ":" + o.name;
						if(o.arg != undefined) {
							s += "(" + o.arg + ")";
						}
						break;
					case TYPE_PSEUDOCLASS_EXPR:
						s += ":" + o.name + "(";
						if(o.arg.a == 1) {
							s += "n";
						} else if(o.arg.a == -1) {
							s += "-n";
						} else if(o.arg.a != 0) {
							s += o.arg.a + "n";
						}
						if(o.arg.b > 0) {
							if(o.arg.a) {
								s += "+";
							}
							s += o.arg.b;
						} else if(o.arg.b < 0) {
							s += o.arg.b;
						}
						s += ")";
						break;
					case TYPE_PSEUDOCLASS_NEG:
						s += ":not(";
						if(o.arg != undefined) {
							s += CSSSimpleSelector(o.arg).toString();
						}
						s += ")";
						break;
					case TYPE_PSEUDOELEMENT:
						s += "::" + o.name;
						if(o.arg != undefined) {
							s += "(" + o.arg + ")";
						}
						break;
				}
			}
			if(_sCombinator != "") {
				s += (_sCombinator == " ") ? " " : " " + _sCombinator + " ";
			}
			return s;
		}
	}
}
