class DENGContainer
{
	static var app:DENGContainer;
	
	var DENG_SWF_URL:String = "deng.swf";
	var DOCUMENT_URL:String = "sample.html";
	
	var done:Boolean = false;
	var ivid:Number;

	static function main(mc) {
		app = new DENGContainer();
	}

	function DENGContainer() {
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		Stage.addListener(this);
		if(typeof _level0.documentURL != "undefined" && _level0.documentURL != "") {
			DOCUMENT_URL = _level0.documentURL;
		}
		_root.createEmptyMovieClip("dengcontainer", 1);
		_root.dengcontainer.loadMovie(DENG_SWF_URL);
		ivid = setInterval(this, "checkLoadProgress", 10);
		displayStatus("Loading DENG Modular XML Browser");
	}
	
	private function checkLoadProgress():Void {
		var bl = _root.dengcontainer.getBytesLoaded();
		var bt = _root.dengcontainer.getBytesTotal();
		if(bl > 0 && bt > 0) {
			if(bl == bt) {
				clearInterval(ivid);
				ivid = setInterval(this, "initDeng", 50);
			} else {
				var percent = Math.round(100 * bl / bt);
				displayStatus("Loading DENG Modular XML Browser: " + percent + "%");
			}
		}
	}

	private function initDeng():Void {
		clearInterval(ivid);
		var deng = _root.dengcontainer.deng_mc;
		deng.addListener(this);
		deng.setDocumentUri(DOCUMENT_URL);
		deng.setSize(Stage.width, Stage.height);
		deng.render();
		displayStatus("Loading Document");
	}
	
	private function onLoadXML(success:Boolean, status:Number):Void {
		displayStatus("Rendering Document: 1/5");
		onResize();
	}
	
	private function onParseCSS():Void {
		displayStatus("Rendering Document: 2/5");
	}
	
	private function onCreate():Void {
		displayStatus("Rendering Document: 3/5");
	}
	
	private function onSize():Void {
		displayStatus("Rendering Document: 4/5");
	}
	
	private function onPosition():Void {
		displayStatus("Rendering Document: 5/5");
	}
	
	private function onRender():Void {
		displayStatus();
		done = true;
	}
	
	private function onClickHandler(linkUrl, targetStyle, targetPosition, targetName):Void {
		getURL(linkUrl);
	}
	
	private function onResize():Void {
		_root.dengcontainer.deng_mc.setSize(Stage.width, Stage.height);
		_root.tfDebug._width = Stage.width;
	}

	private function displayStatus(txt:String):Void {
		if(txt == undefined) {
			_root.tfDebug.removeTextField();
		} else if(!done) {
			if(_root.tfDebug == undefined) {
				_root.createTextField("tfDebug", 50000, 0, 0, Stage.width, 20);
				_root.tfDebug.selectable = false;
				_root.tfDebug.multiline = false;
				_root.tfDebug.wordWrap = false;
				_root.tfDebug.font = "_sans";
				_root.tfDebug.text = "";
			}
			_root.tfDebug.text = txt;
		}
	}
}
