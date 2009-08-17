package deng.etc
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.errors.IllegalOperationError;
	
	public dynamic class List extends Proxy
	{
		protected var _arr:Array;

		public function List(arr:Array = null) {
			_arr = (arr == null) ? [] : arr;
		}
		
		public function item(index:uint):* {
			return _arr[index];
		}
		
		public function get length():Number {
			return _arr.length;
		}
		
		flash_proxy override function setProperty(name:*, value:*):void {
			var n:String = name.toString();
			var c:Number = n.charCodeAt(0);
			if(c >= 0x30 && c <= 0x39) {
				_arr[parseInt(n)] = value;
			} else {
				throw new IllegalOperationError("Error: Access of undefined property " + n);
			}
		}

		flash_proxy override function getProperty(name:*):* {
			var n:String = name.toString();
			var c:Number = n.charCodeAt(0);
			if(c >= 0x30 && c <= 0x39) {
				var value:* = _arr[parseInt(n)];
				return (value == undefined) ? null : value;
			} else {
				throw new IllegalOperationError("Error: Access of undefined property " + n);
			}
		}

		flash_proxy override function callProperty(name:*, ...args):* {
			var n:String = name.toString();
			if(_arr[n] != undefined) {
				return _arr[n].apply(_arr, args);
			} else {
				throw new IllegalOperationError("Error: Access of undefined method " + n + "()");
			}
		}
	}
}