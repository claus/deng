package deng.dom.etc
{
	public class DOMFeature
	{
		private var _feature:String;
		private var _versionMin:Number;
		private var _versionMax:Number;
		
		public function DOMFeature(feature:String, vMax:Number, vMin:Number = -1) {
			_feature = feature.toLowerCase();
			_versionMax = vMax;
			_versionMin = (vMin <= 0 || isNaN(vMin)) ? vMax : Math.min(vMin, vMax);
		}
		
		public function get feature():String {
			return _feature;
		}
		public function get versionMin():Number {
			return _versionMin;
		}
		public function get versionMax():Number {
			return _versionMax;
		}
		
		public function match(feature:String, version:String):Boolean {
			feature = feature.toLowerCase();
			if(feature.charAt(0) == "+") {
				feature = feature.substring(1);
			}
			if(version == null || version == "") {
				return (feature == _feature);
			} else {
				var v:Number = parseFloat(version);
				if(isNaN(v) || v <= 0) {
					return (feature == _feature);
				} else {
					return (feature == _feature && v >= _versionMin && v <= _versionMax);
				}
			}
		}
	}
}