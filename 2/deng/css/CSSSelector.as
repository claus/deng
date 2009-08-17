package deng.css
{
	import deng.css.*;
	
	public class CSSSelector
	{
		private var _oRoot:CSSSimpleSelector;
		private var _aSimpleSelectors:Array;
		private var _bHasPseudoElements:Boolean;
		private var _bHasPseudoClasses:Boolean;
		private var _nSpecificity:Number;
		
		public function CSSSelector() {
			_oRoot = null;
			_aSimpleSelectors = [];
			_bHasPseudoElements = false;
			_bHasPseudoClasses = false;
		};
		
		public function addSimpleSelector(oSimpleSelector:CSSSimpleSelector):void {
			if(_oRoot != null) {
				_aSimpleSelectors.push(_oRoot);
			}
			_oRoot = oSimpleSelector;
		};
	
		public function setCombinator(sCombinator:String):void {
			if(_oRoot != null) {
				_oRoot.setCombinator(sCombinator);
			}
		};
		
		public function calculateSpecificity():void {
			var nSpecB:Number = 0;
			var nSpecC:Number = 0;
			var nSpecD:Number = 0;
			for(var i:String in _aSimpleSelectors) {
				var oSS:CSSSimpleSelector = CSSSimpleSelector(_aSimpleSelectors[i]);
				/*
				for(var j in _ss) {
					// simpleselector type
					//  0 element, no/default namespace
					//  1 element, namespace
					// 10 class selector "."
					// 11 attribute selector "[..]"
					// 12 pseudo class
					// 13 id selector "#"
					// 20 pseudo element (ignored)
					switch(_ss[j].type) {
						case 0:
						case 1:
							if(_ss[j].name != "*") {
								_sd++;
							}
							break;
						case 10:
						case 11:
							_sc++;
							break;
						case 12:
							oSelector.hasPseudoClasses = true;
							if(_ss[j].name != "not") {
								_sc++;
							} else {
								// negation pseudo class:
								// "negative selectors are counted like their simple selectors argument"
								_sb = 0; _sc = 0; _sd = 0;
								for(var k in _ss[j].farg) {
									var _fargss = _ss[j].farg[k];
									switch(_fargss.type) {
										case 0:
										case 1:
											if(_fargss.name != "*") { _sd++;	}; break;
										case 10:
										case 11:
										case 12:
											_sc++; break;
										case 13:
											_sb++; break;
									}
								}
							}
							break;
						case 13:
							_sb++;
							break;
						case 20:
							oSelector.hasPseudoElements = true;
							break;
					}
				}
				specificity = (((_sb * 1000) + _sc) * 1000) + _sd;
				*/
			}
		}
		
	
		////////////////////////////////////////////////////////
		// toString
		////////////////////////////////////////////////////////
	
		public function toString():String {
			var s:String = "";
			var i: Number = 0;
			var l:Number = _aSimpleSelectors.length;
			for(; i < l; i++) {
				s += CSSSimpleSelector(_aSimpleSelectors[i]).toString();
			}
			return s + _oRoot.toString();
		};
	}
}
