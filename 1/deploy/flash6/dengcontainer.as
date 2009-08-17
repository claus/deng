var DENG_SWF_URL = "deng.swf";
var DOCUMENT_URL = "sample.html";
if(typeof _level0.documentURL != "undefined" && _level0.documentURL != "") {
	DOCUMENT_URL = _level0.documentURL;
}

var done = false;

Stage.align = "TL";
Stage.scaleMode = "noScale";
Stage.addListener(this);

this.createEmptyMovieClip("dengcontainer", 1);
this.dengcontainer.loadMovie(DENG_SWF_URL);
this.onEnterFrame = this.checkLoadProgress;
this.displayStatus("Loading DENG Modular XML Browser");

stop();

function checkLoadProgress() {
	var bl = this.dengcontainer.getBytesLoaded();
	var bt = this.dengcontainer.getBytesTotal();
	if(bl > 0 && bt > 0) {
		if(bl == bt) {
			delete this.onEnterFrame;
			this.initDeng();
		} else {
			var percent = Math.round(100 * bl / bt);
			this.displayStatus("Loading DENG Modular XML Browser: " + percent + "%");
		}
	}
}

function initDeng() {
	var deng = this.dengcontainer.deng_mc;
	deng.addListener(this);
	deng.setDocumentUri(DOCUMENT_URL);
	deng.setSize(Stage.width, Stage.height);
	deng.render();
	this.displayStatus("Loading Document");
}

function onLoadXML(success, status) {
	this.displayStatus("Rendering Document: 1/5");
	this.onResize();
}

function onParseCSS() {
	this.displayStatus("Rendering Document: 2/5");
}

function onCreate() {
	this.displayStatus("Rendering Document: 3/5");
}

function onSize() {
	this.displayStatus("Rendering Document: 4/5");
}

function onPosition() {
	this.displayStatus("Rendering Document: 5/5");
}

function onRender() {
	this.displayStatus();
	done = true;
}

function onClickHandler(linkUrl, targetStyle, targetPosition, targetName) {
	getURL(linkUrl);
}

function onResize() {
	this.dengcontainer.deng_mc.setSize(Stage.width, Stage.height);
	this.tfDebug._width = Stage.width;
}

function displayStatus(txt) {
	if(txt == undefined) {
		this.tfDebug.removeTextField();
	} else if(!done) {
		if(this.tfDebug == undefined) {
			this.createTextField("tfDebug", 50000, 0, 0, Stage.width, 20);
			this.tfDebug.selectable = false;
			this.tfDebug.multiline = false;
			this.tfDebug.wordWrap = false;
			this.tfDebug.font = "_sans";
			this.tfDebug.text = "";
		}
		this.tfDebug.text = txt;
	}
}
