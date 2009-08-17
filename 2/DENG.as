package
{
	import deng.css.*;
	import deng.etc.List;
	import flash.display.MovieClip;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import org.w3c.dom.IDOMImplementation;
	import org.w3c.dom.bootstrap.DOMImplementationRegistry;

	public class DENG extends MovieClip
	{
		public function DENG()
		{
			// bootstrapping the dom implementation:
			// var reg:DOMImplementationRegistry = DOMImplementationRegistry.getInstance();
			// var impl:IDOMImplementation = reg.getDOMImplementation("XML 1.0 LS 3.0");
			// trace(impl);
			
			// testing the List implementation:
			/*
			var a:List = new List([0]);
			trace(a);
			a.push("huhu");
			trace(a.join(","));
			a[2] = "trallala";
			trace(a.join(","));
			trace(a.item(2));
			trace(a[2]);
			trace(a[5]);
			trace(a.length);
			*/
			
			// testing the css parser:
			testCSS();
		}
		
		protected function testCSS():void {
			// create the parser instance
			var cssp:CSSParser = new CSSParser();

			var s:String = "hello { color: green; } "; // +

			var css:String = "";
			for(var i:uint = 0; i < 1; i++) {
				css += s;
			}

			// parse css	
			var t:Number = getTimer();
			cssp.parse(css);
			t = (getTimer()-t);
			
			// display results
			var tf:TextField = new TextField();
			var strDebug:String;
			strDebug = "parsing time: " + t + " ms\n";
			strDebug += "bytes: " + css.length + " (" + Math.round(css.length / t) + " bytes/ms)\n--\n";
			strDebug += cssp.toString();
			tf.text = strDebug + "\n\n";
			tf.width = 550;
			tf.height = 400;
			this.addChild(tf);
		}
	}
}

