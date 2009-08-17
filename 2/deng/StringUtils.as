package deng
{
	import flash.utils.ByteArray;
	
	public class StringUtils
	{
		public static function trim(input:String):String {
			return StringUtils.ltrim(StringUtils.rtrim(input));
		}

		public static function ltrim(input:String):String {
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++) {
				if(input.charCodeAt(i) > 32) {
					return input.substring(i);
				}
			}
			return "";
		}

		public static function rtrim(input:String):String {
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--) {
				if(input.charCodeAt(i - 1) > 32) {
					return input.substring(0, i);
				}
			}
			return "";
		}

		public static function condenseWhitespace(input:String):String {
			input = StringUtils.trim(input);
			var result:Array = [];
			var words:Array = StringUtils.trim(input).split(" ");
			var size:Number = words.length;
			for(var i:Number = 0; i < size; i++) {
				if(words[i] != "") {
					result.push(words[i]);
				}
			}
			return result.join(" ");
		}

		public static function escapeUTF8(s:String):String {
			if(s == null || s.length == 0) {
				return s;
			}
			var r:String = "";
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(s);
			data.position = 0;
			while(data.bytesAvailable) {
				var hex:String = data.readUnsignedByte().toString(16);
				if(hex.length == 1) { hex = "0" + hex; }
				r += "%" + hex.toUpperCase();
			}
			return r;
		}

		public static function unescapeUTF8(s:String):String {
			if(s == null || s.length == 0 || s.indexOf('%') == -1) {
				return s;
			}
			var data:ByteArray = new ByteArray();
			var len:Number = s.length;
			for(var i:Number = 0; i < len; i++) {
				var c:String = s.charAt(i);
				if(c == '%') {
					if(i < len - 2) {
						data.writeByte(parseInt(s.substr(i + 1, 2), 16));
						i += 2;
					} else {
						break;
					}
				} else {
					data.writeUTFBytes(c);
				}
			}
			data.position = 0;
			return data.readUTFBytes(data.length);
		}
	}
}