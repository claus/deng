/*
 * Copyright (C) 2006 Claus Wahlers and Max Herkender
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

package deng.fzip
{
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.Dictionary;
	
	import flash.text.*;

	/**
	 * Dispatched when a file contained in a ZIP archive has 
	 * loaded successfully.
	 *
	 * @eventType deng.fzip.FZipEvent.FILE_LOADED
	 */
	[Event(name="fileLoaded", type="deng.fzip.FZipEvent")]

	/**
	 * Dispatched when an error is encountered while parsing a 
	 * ZIP Archive.
	 *
	 * @eventType deng.fzip.FZipErrorEvent.PARSE_ERROR
	 */
	[Event(name="parseError", type="deng.fzip.FZipErrorEvent")]

	/**
	 * Dispatched when data has loaded successfully. 
	 *
	 * @eventType flash.events.Event.COMPLETE 
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Dispatched if a call to FZip.load() attempts to access data 
	 * over HTTP, and the current Flash Player is able to detect 
	 * and return the status code for the request. (Some browser 
	 * environments may not be able to provide this information.) 
	 * Note that the httpStatus (if any) will be sent before (and 
	 * in addition to) any complete or error event
	 *
	 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS 
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]

	/**
	 * Dispatched when an input/output error occurs that causes a 
	 * load operation to fail. 
	 *
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	/**
	 * Dispatched when a load operation starts.
	 *
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name="open", type="flash.events.Event")]

	/**
	 * Dispatched when data is received as the download operation 
	 * progresses.
	 *
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]

	/**
	 * Dispatched if a call to FZip.load() attempts to load data 
	 * from a server outside the security sandbox. 
	 * 
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]


	/**
	 * Loads and parses ZIP archives.
	 * 
	 * <p>FZip is able to process standard ZIP archives as described in the
	 * <a href="http://www.pkware.com/business_and_developers/developer/popups/appnote.txt">PKZIP file format documentation</a>.</p>
	 * 
	 * <p>Limitations:</p>
	 * <ul>
	 * <li>ZIP feature versions &gt; 2.0 are not supported</li>
	 * <li>ZIP archives containing data descriptor records are not supported.</li>
	 * </ul>
	 */		
	public class FZip extends EventDispatcher
	{
		private var filesList:Array;
		private var filesDict:Dictionary;

		private var urlStream:URLStream;
		private var parseState:Namespace;
		private var currentFile:FZipFile;

		// load states
		private namespace idle;
		private namespace signature;
		private namespace localfile;
		
		/**
		 * Constructor
		 */		
		public function FZip() {
			super();
			parseState = idle;
		}

		/**
		 * Begins downloading the ZIP archive specified by the request
		 * parameter.
		 * 
		 * @param req A URLRequest object specifying the URL of a ZIP archive
		 * to download. 
		 * If the value of this parameter or the URLRequest.url property 
		 * of the URLRequest object passed are null, Flash Player throws 
		 * a null pointer error.
		 */		
		public function load(request:URLRequest):void {
			if(!urlStream && parseState == idle) {
				urlStream = new URLStream();
				urlStream.endian = Endian.LITTLE_ENDIAN;
				addEventHandlers();
				filesList = [];
				filesDict = new Dictionary();
				parseState = signature;
				urlStream.load(request);
			}
		}
		
		/**
		 * Immediately closes the stream and cancels the download operation.
		 * Files contained in the ZIP archive being loaded stay accessible
		 * through the getFileAt() and getFileByName() methods.
		 */		
		public function close():void {
			if(urlStream) {
				parseState = idle;
				removeEventHandlers();
				urlStream.close();
				urlStream = null;
			}
		}

		/**
		 * Gets the number of accessible files in the ZIP archive.
		 * 
		 * @return The number of files
		 */				
		public function getFileCount():uint {
			return filesList ? filesList.length : 0;
		}

		/**
		 * Retrieves a file contained in the ZIP archive, by index.
		 * 
		 * @param index The index of the file to retrieve
		 * @return A reference to a FZipFile object
		 */				
		public function getFileAt(index:uint):FZipFile {
			return filesList ? filesList[index] as FZipFile : null;
		}

		/**
		 * Retrieves a file contained in the ZIP archive, by filename.
		 * 
		 * @param name The filename of the file to retrieve
		 * @return A reference to a FZipFile object
		 */				
		public function getFileByName(name:String):FZipFile {
			return filesDict[name] ? filesDict[name] as FZipFile : null;
		}

		/**
		 * @private
		 */		
		protected function parse(stream:IDataInput):Boolean {
			while (parseState::parse(stream));
			return (parseState === idle);
		}

		/**
		 * @private
		 */		
		idle function parse(stream:IDataInput):Boolean {
			return false;
		}
		
		/**
		 * @private
		 */		
		signature function parse(stream:IDataInput):Boolean {
			if(stream.bytesAvailable >= 4) {
				var sig:uint = stream.readUnsignedInt();
				switch(sig) {
					case 0x04034b50:
						parseState = localfile;
						currentFile = new FZipFile();
						break;
					case 0x02014b50:
					case 0x06054b50:
						parseState = idle;
						break;
					default:
						throw(new Error("Unknown record signature."));
						break;
				}
				return true;
			}
			return false;
		}

		/**
		 * @private
		 */		
		localfile function parse(stream:IDataInput):Boolean {
			if(currentFile.parse(stream)) {
				filesList.push(currentFile);
				if (currentFile.filename) {
					filesDict[currentFile.filename] = currentFile;
				}
				dispatchEvent(new FZipEvent(FZipEvent.FILE_LOADED, currentFile));
				currentFile = null;
				parseState = signature;
				return true;
			}
			return false;
		}
		
		/**
		 * @private
		 */		
		protected function progressHandler(evt:Event):void {
			dispatchEvent(evt.clone());
			try {
				if(parse(urlStream)) {
					close();
					dispatchEvent(new Event(Event.COMPLETE));
				}
			} catch(e:Error) {
				close();
				dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, e.message));
			}
		}
		
		/**
		 * @private
		 */		
		protected function defaultHandler(evt:Event):void {
			dispatchEvent(evt.clone());
		}
		
		/**
		 * @private
		 */		
		protected function defaultErrorHandler(evt:Event):void {
			close();
			dispatchEvent(evt.clone());
		}
		
		/**
		 * @private
		 */		
		protected function addEventHandlers():void {
			urlStream.addEventListener(Event.COMPLETE, defaultHandler);
			urlStream.addEventListener(Event.OPEN, defaultHandler);
			urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, defaultHandler);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, defaultErrorHandler);
			urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, defaultErrorHandler);
			urlStream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		/**
		 * @private
		 */		
		protected function removeEventHandlers():void {
			urlStream.removeEventListener(Event.COMPLETE, defaultHandler);
			urlStream.removeEventListener(Event.OPEN, defaultHandler);
			urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, defaultHandler);
			urlStream.removeEventListener(IOErrorEvent.IO_ERROR, defaultErrorHandler);
			urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, defaultErrorHandler);
			urlStream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
	}
}