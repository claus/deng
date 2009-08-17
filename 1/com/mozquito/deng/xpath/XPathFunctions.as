/**
	Copyright (c) 2002 Neeld Tanksley.  All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	1. Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.
	
	2. Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the documentation
	and/or other materials provided with the distribution.
	
	3. The end-user documentation included with the redistribution, if any, must
	include the following acknowledgment:
	
	"This product includes software developed by Neeld Tanksley
	(http://xfactorstudio.com)."
	
	Alternately, this acknowledgment may appear in the software itself, if and
	wherever such third-party acknowledgments normally appear.
	
	4. The name Neeld Tanksley must not be used to endorse or promote products 
	derived from this software without prior written permission. For written 
	permission, please contact neeld@xfactorstudio.com.
	
	THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES,
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
	FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL NEELD TANKSLEY
	BE LIABLE FOR ANY DIRECT, INDIRECT,	INCIDENTAL, SPECIAL, EXEMPLARY, OR 
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
	GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
	HOWEVER CAUSED AND ON ANY THEORY OF	LIABILITY, WHETHER IN CONTRACT, STRICT 
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
	OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
_global.XPathFunctions = function(){

}

XPathFunctions.Tokens = new Object();
XPathFunctions.Tokens["last("] = "last";
XPathFunctions.Tokens["position("] = "position";
XPathFunctions.Tokens["count("] = "count";
XPathFunctions.Tokens["id("] = "id";
XPathFunctions.Tokens["name("] = "name";
XPathFunctions.Tokens["string("] = "string";
XPathFunctions.Tokens["concat("] = "concat";
XPathFunctions.Tokens["starts-with("] = "startsWith";
XPathFunctions.Tokens["contains("] = "contains";
XPathFunctions.Tokens["substring-before("] = "substringBefore";
XPathFunctions.Tokens["substring-after("] = "substringAfter";
XPathFunctions.Tokens["substring("] = "substring";
XPathFunctions.Tokens["string-length("] = "stringLength";
XPathFunctions.Tokens["normalize-space("] = "normalizeSpace";
XPathFunctions.Tokens["translate("] = "translate";
XPathFunctions.Tokens["boolean("] = "boolean";
XPathFunctions.Tokens["not("] = "Not";
XPathFunctions.Tokens["true("] = "myTrue";
XPathFunctions.Tokens["false("] = "myFalse";
XPathFunctions.Tokens["lang("] = "lang";
XPathFunctions.Tokens["number("] = "number";
XPathFunctions.Tokens["sum("] = "sum";
XPathFunctions.Tokens["floor("] = "floor";
XPathFunctions.Tokens["ceiling("] = "ceiling";
XPathFunctions.Tokens["round("] = "round";
XPathFunctions.Tokens["local-name("] = "localName";
XPathFunctions.Tokens["namespace-uri("] = "namespaceURI";
XPathFunctions.Tokens["instance("] = "instance";
XPathFunctions.Tokens["if("] = "iffunction";
XPathFunctions.Tokens["index("] = "index";
XPathFunctions.Tokens["now("] = "now";


///////////////////////////////////////////////
//
//     XPath functions
//
//     XPath supports a limited number of functions
//     These are the equivilent functions in AS
//
//     Because these functions are called automatically by the 
//     expression parser, each function is passed the same four 
//     arguments. args is an array containg the user supplied 
//     arguments, context is the current context XMLNode, nodeSet 
//     is the current nodeSet that contains the contextNode, 
//     
//
//////////////////////////////////////////////
XPathFunctions.parseArgs = function(args,context,nodeSet){
	
	var argArray = [];
	var collChars = "";
	var c;
	var bracketStack = [];
	for(var i=0;i<args.length;i++){
		c = args.charAt(i);
		switch(c){
			case "\"":
				if (!bracketStack.length) {
					i++; //kill quote
					j=i;
					while(args.charAt(j) != '"' && j<args.length){
						j++;
					}
					collChars = args.substr(i,j-i);
					argArray.push(collChars);
					collChars = "";
					i=j;
				} else {
					collChars += c;
				}
				break;
			case "(":
				//stop listening to quotes
				bracketStack.push(true);
				collChars += c;
				break;
			case ")":
				//unqueue one bracket
				bracketStack.pop();
				collChars += c;
				break;
			case ",":
				if(collChars != ""){
					if(isNaN(collChars)){
						//argArray.push(XPath.selectNodes(context,collChars));
						argArray.push(XPathPredicate.evaluate(context, collChars, nodeSet, XPathPredicate.parse(collChars)));
					}else{
						argArray.push(collChars);
					}
					
				}
				collChars = "";
				break;
			case " ":
				break;
			default:
				collChars += c;
				break;
		}
	}
	
	if(collChars != ""){
		if(isNaN(collChars)){
			argArray.push(XPathPredicate.evaluate(context, collChars, nodeSet, XPathPredicate.parse(collChars)));
			//argArray.push(XPath.selectNodes(context,collChars));
		}else{
			argArray.push(collChars);
		}
	}

	return argArray;
}

//////////////////////
// Node Set Functions
//////////////////////
XPathFunctions.instance = function(args,context,nodeSet){
	//trace("instance function invoked")
	/*for (var i in args) {
		trace(args[i])
	}
	trace("context: " +context.nodeName)
	trace("nodeset length: " +nodeSet.length)*/
	var ID = args[0]
	var document = context.root().pop().xmlDomRef
	return document.getInstance(ID).documentElement
}
XPathFunctions.iffunction = function (args,context,nodeSet){
//	trace("if function invoked")
	/*for (var i in args) {
		trace(args[i])
	}
	trace("context: " +context.nodeName)
	trace("nodeset length: " +nodeSet.length)*/
	return (args[0]) ? args[1] : args[2]
}
XPathFunctions.now = function (args,context,nodeSet){
//	trace("now function invoked")
	/*for (var i in args) {
		trace(args[i])
	}
	trace("context: " +context.nodeName)
	trace("nodeset length: " +nodeSet.length)*/
	return new Date().toString();
}
XPathFunctions.last = function(args,context,nodeSet){
//	trace("last function invoked")
	/*for (var i in args) {
		trace(args[i])
	}
	trace("context: " +context.nodeName)
	trace("nodeset length: " +nodeSet.length)*/
	return Number(nodeSet.length);
}
XPathFunctions.index = function(args,context,nodeSet){
//	trace("index function invoked")
	/*for (var i in args) {
		trace(args[i])
	}
	trace("context: " +context.nodeName)
	trace("nodeset length: " +nodeSet.length)*/
	var root = context.root().pop();
	return root.xmlDomRef.getRepeat(args[0]).index;
}
XPathFunctions.position = function(args,context,nodeSet){
	return XPathParser.getChildIndex(context);
}
XPathFunctions.count = function(args,context,nodeSet){
	return args[0].length;
}
XPathFunctions.id = function(args,context,nodeSet){
	//not implemented
}
XPathFunctions.name = function(args,context,nodeSet){
	var targetNode = (args.length == 0)? context : args[0][0];
	return targetNode.nodeName;
}
XPathFunctions.localName = function(args,context,nodeSet){
	var targetNode = (args.length == 0)? context : args[0][0];
	return targetNode.nsNodeName;
}
XPathFunctions.namespaceURI = function(args,context,nodeSet){
	var targetNode = (args.length == 0)? context : args[0][0];
	return targetNode.nsUri
}
//////////////////////
// String Functions
//////////////////////
XPathFunctions.toString = function(args){
	if(args instanceof Array){
		args = XPathAxes.stringValue(args[0]).join("");
	}
	return String(args);
}
XPathFunctions.string = function(args,context,nodeSet){
	return XPathFunctions.toString(args[0]);
}

XPathFunctions.concat = function(args,context,nodeSet){
	for(var i=0;i<args.length;i++){
		args[i] = XPathFunctions.toString(args[i]);
	}
	return args.join("");
}
XPathFunctions.startsWith = function(args,context,nodeSet){
	args[0] = XPathFunctions.toString(args[0]);
	args[1] = XPathFunctions.toString(args[1]);
	return (args[0].substr(0,args[1].length) == args[1])? true : false;
}
XPathFunctions.contains = function(args,context,nodeSet){
	args[0] = XPathFunctions.toString(args[0]);
	args[1] = XPathFunctions.toString(args[1]);
	return (args[0].indexOf(args[1]) != -1)? true : false;
}
XPathFunctions.substringBefore = function(args,context,nodeSet){
	args[0] = XPathFunctions.toString(args[0]);
	args[1] = XPathFunctions.toString(args[1]);
	return args[0].substr(0,args[0].indexOf(args[1]));
}
XPathFunctions.substringAfter = function(args,context,nodeSet){
	args[0] = XPathFunctions.toString(args[0]);
	args[1] = XPathFunctions.toString(args[1]);
	return args[0].substr(args[0].indexOf(args[1])+args[1].length,args[0].length);
}
XPathFunctions.substring = function(args,context,nodeSet){
	args[0] = XPathFunctions.toString(args[0]);
	args[1] = XPathFunctions.toString(args[1]);
	return args[0].substr(args[1]-1,Math.min(args[2],args[0].length));
}
XPathFunctions.stringLength = function(args,context,nodeSet){
	args = XPathFunctions.toString(args[0]);
	return (args != null)? args.length : XPathAxes.stringValue(context).length;
}
XPathFunctions.normalizeSpace = function(args,context,nodeSet){
	args = XPathFunctions.toString(args[0]);
	var i,s
	for(i=0;i<args.length;i++){
		if(args.charCodeAt(i) < 33){
			s=i;
			while(args.charCodeAt(s) < 33){
				s++;
			}
			if(s > i+1){
				args = args.split(args.substr(i,s-i)).join(" ");
			}
		}
	}
	//leading
	i=0;
	while(args.charCodeAt(i) < 33){
		i++;
	}
	args = args.substr(i,args.length);
	//trailing
	i=args.length-1;
	while(args.charCodeAt(i) < 33){
		i--;
	}
	args = args.substr(0,i+1);
	return args;
}
XPathFunctions.translate = function(context,nodeSet,args){
	//not implemented
}
//}
	
	
	
//////////////////////
// Number Functions
//////////////////////
XPathFunctions.toNumber = function(args){
	//return XPathFunctions.number([args]);
	if(args instanceof Array){
		args = XPathFunctions.toString(args);
	}
	switch(typeof(args)){
		case "string":
			return Number(args);
		case "boolean":
			return (args)? 1 : 0;
		default:
			return args;
	}
	/**
	if(typeof(args) == "string"){
		return Number(args);
	}
	if(typeof(args) == "boolean"){
		return (args)? 1 : 0;
	}
	
	return args;
	**/
}
XPathFunctions.number = function(args,context,nodeSet){
	return XPathFunctions.toNumber(args[0]);
}
XPathFunctions.sum = function(args,context,nodeSet){
	//args = args[0];
	var total = 0;
	for(var i=0;i<args[0].length;i++){
		total += Number(XPathAxes.stringValue(args[0][i])[0]);
	}
	return total;
}
XPathFunctions.floor = function(args,context,nodeSet){
	args[0] = XPathFunctions.toNumber(args[0]);
	return Math.floor(Number(args[0]));
}
XPathFunctions.ceiling = function(args,context,nodeSet){
	args[0] = XPathFunctions.toNumber(args[0]);
	return Math.ceil(Number(args[0]));
}
XPathFunctions.round = function(args,context,nodeSet){
	args[0] = XPathFunctions.toNumber(args[0]);
	return Math.round(Number(args[0]));
}


//////////////////////
// Boolean Functions
//////////////////////
XPathFunctions.toBoolean = function(args){
	return XPathFunctions.boolean([args]);
}

XPathFunctions.boolean = function(args,context,nodeSet){
	args = args[0];	
	if(args instanceof Array){
		return (args.length > 0)? true : false;
	}
	switch(typeof(args)){
		case "number":
			return (args != 0)? true : false;
		case "string":
			return (args.length > 0)? true : false;
		default:
			return args;
	}
	/**
	if(typeof(args) == "number"){
		return (args != 0)? true : false;
	}
	if(typeof(args) == "string"){
		return (args.length > 0)? true : false;
	}
	return args;
	**/
}
XPathFunctions.Not = function(args,context,nodeSet){
	args = args[0];
	if(args == "false" || args == false){
		return true;
	}else{
		return false;
	}
}
XPathFunctions.myTrue = function(args,context,nodeSet){
	return true;
}
XPathFunctions.myFalse = function(args,context,nodeSet){
	return false;
}
XPathFunctions.lang = function(args,context,nodeSet){
	//not implemented
}
