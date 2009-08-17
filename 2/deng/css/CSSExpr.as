package deng.css
{
	import deng.css.*;
	
	public class CSSExpr
	{
		private var _aTerms:Array;
		// array of anonymous objects:
		// {
		//   op: operator succeeding this term,
		// 	 type: datatype of this term,
		// 	 value: the main data, mixed type depending on term type,
		// 	 dimen: string (the dimen identifier),
		// 	 expr: expr object (the function expression), an array of term objects
		// }
	
		public static const TYPE_NUMBER:uint = 1;
		public static const TYPE_PERCENTAGE:uint = 10;
		public static const TYPE_LENGTH_PX:uint = 20;
		public static const TYPE_LENGTH_CM:uint = 21;
		public static const TYPE_LENGTH_MM:uint = 22;
		public static const TYPE_LENGTH_IN:uint = 23;
		public static const TYPE_LENGTH_PT:uint = 24;
		public static const TYPE_LENGTH_PC:uint = 25;
		public static const TYPE_EMS:uint = 30;
		public static const TYPE_EXS:uint = 31;
		public static const TYPE_ANGLE_DEG:uint = 40;
		public static const TYPE_ANGLE_RAD:uint = 41;
		public static const TYPE_ANGLE_GRAD:uint = 42;
		public static const TYPE_TIME_S:uint = 50;
		public static const TYPE_TIME_MS:uint = 51;
		public static const TYPE_FREQ_KHZ:uint = 60;
		public static const TYPE_FREQ_HZ:uint = 61;
		public static const TYPE_DIMEN:uint = 70;
		public static const TYPE_FUNCTION:uint = 80;
		public static const TYPE_STRING:uint = 90;
		public static const TYPE_IDENT:uint = 100;
		public static const TYPE_URI:uint = 110;
		public static const TYPE_HEXCOLOR:uint = 120;
		public static const TYPE_UNICODERANGE:uint = 130;
	
		public static const TYPE_OP_NONE:uint = 0;
		public static const TYPE_OP_SPACE:uint = 1;
		public static const TYPE_OP_SLASH:uint = 2;
		public static const TYPE_OP_COMMA:uint = 3;
	
		public function CSSExpr() {
			_aTerms = [];
		};
	
		public function addTerm(oTerm:Object):void {
			_aTerms.push(oTerm);
		};
		
		public function getTermCount():Number {
			return _aTerms.length;
		};
		
		public function getTermAt(index:Number):Object {
			return _aTerms[index];
		};
		
	
		////////////////////////////////////////////////////////
		// toString
		////////////////////////////////////////////////////////

		public function toString():String {
			var s:String = "";
			var nTermsLen:Number = _aTerms.length;
			for(var i:Number = 0; i < nTermsLen; i++) {
				var oTerm:Object = _aTerms[i];
				switch(oTerm.type) {
					case TYPE_NUMBER: s += oTerm.value; break;
					case TYPE_PERCENTAGE: s += oTerm.value + "%"; break;
					case TYPE_LENGTH_PX: s += oTerm.value + "px"; break;
					case TYPE_LENGTH_CM: s += oTerm.value + "cm"; break;
					case TYPE_LENGTH_MM: s += oTerm.value + "mm"; break;
					case TYPE_LENGTH_IN: s += oTerm.value + "in"; break;
					case TYPE_LENGTH_PT: s += oTerm.value + "pt"; break;
					case TYPE_LENGTH_PC: s += oTerm.value + "pc"; break;
					case TYPE_EMS: s += oTerm.value + "em"; break;
					case TYPE_EXS: s += oTerm.value + "ex"; break;
					case TYPE_ANGLE_DEG: s += oTerm.value + "deg"; break;
					case TYPE_ANGLE_RAD: s += oTerm.value + "rad"; break;
					case TYPE_ANGLE_GRAD: s += oTerm.value + "grad"; break;
					case TYPE_TIME_S: s += oTerm.value + "s"; break;
					case TYPE_TIME_MS: s += oTerm.value + "mc"; break;
					case TYPE_FREQ_KHZ: s += oTerm.value + "khz"; break;
					case TYPE_FREQ_HZ: s += oTerm.value + "hz"; break;
					case TYPE_DIMEN: s += oTerm.value + oTerm.dimen; break;
					case TYPE_FUNCTION: s += oTerm.value + "(" + CSSExpr(oTerm.expr).toString() + ")"; break;
					case TYPE_STRING: s += "\"" + oTerm.value + "\""; break;
					case TYPE_IDENT: s += oTerm.value; break;
					case TYPE_URI: s += "url(\"" + oTerm.value + "\")"; break;
					case TYPE_HEXCOLOR: s += "#" + oTerm.value.toString(16); break;
					case TYPE_UNICODERANGE: break;
				}
				switch(oTerm.op) {
					case TYPE_OP_NONE: break;
					case TYPE_OP_SPACE: s += " "; break;
					case TYPE_OP_SLASH: s += " / "; break;
					case TYPE_OP_COMMA: s += ", "; break;
				}
			}
			return s;
		};
	}
}	
