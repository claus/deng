/*
DENG Modular XBrowser
Copyright (C) 2002-2004 Mozquito, Helen Triolo, Gerrit Hobbelt, Timothee Groleau

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

// ===========================================================================================
//   String prototypes
//   Sources:
//   - Helen Triolo's svg:path parsing rendering study: classDefs.as, drawsvg.as
//   - Gerrit E.G. 'Insh_Allah' Hobbelt's trim functions
// ===========================================================================================


// -------------------------------------------------------------------------------------------
//	String method replace   
//	Search for a string of one or multiple characters, replace with another string 
// of one or multiple chars
//	Parameters:
//		sFind: string to find
//		sReplace: string to replace found string with
// -------------------------------------------------------------------------------------------
//String.prototype.replace = function(sFind, sReplace) {
  //return this.split(sFind).join(sReplace);
//}

// -------------------------------------------------------------------------------------------
//	Timothee Groleau's String method shrinkSequencesOf
//	Shrink all sequences of a given character in a string to one
//	Parameters:
//		ch: a single character
// -------------------------------------------------------------------------------------------
String.prototype.shrinkSequencesOf = function(ch) {
	var len = this.length;
	var idx = 0;
	var idx2 = 0;
	var rs = "";
	while ((idx2 = this.indexOf(ch, idx) + 1) != 0) {
		// include string up to first character in sequence
		rs += this.substring(idx, idx2);
		idx = idx2;
		// remove all subsequent characters in sequence
		while ((this.charAt(idx) == ch) && (idx < len)) idx++;
	}
	return rs + this.substring(idx, len);
}

String.prototype.parsePolyCoords = function() {
	var s0 = this.split(",").join(" ");
	s0 = s0.split("-").join(" -");
	s0 = s0.split("+").join(" ");
	// use textfields collapseWhite property to shrink whitespaces
	_level0.__$DENG_TF$__.htmlText = s0; s0 = _level0.__$DENG_TF$__.text;
	var res = s0.split(" ");
	// cw:: delete trailing/leading whitespace if any
	if(res[0] == " ") { res.splice(0,1); }
	if(res[res.length-1] == " " || res[res.length-1].length == 0) { res.pop(); }
	return res; 
}

// -------------------------------------------------------------------------------------------
//  we will use Triolo's method for parsing points and path data
//  returns the array of coords
//  cw:: optimized
// -------------------------------------------------------------------------------------------
String.prototype.parsePathCoords = function() {
	// cw:: insert whitespace instead of commas
	// cw:: (then collapse whitespaces and split on " ")
	// cw:: avoid "replace" function call, use split directly
	var s0 = this.split(",").join(" ");
	s0 = s0.split("M").join(" M ");
	s0 = s0.split("m").join(" m ");
	s0 = s0.split("L").join(" L ");
	s0 = s0.split("l").join(" l ");
	s0 = s0.split("H").join(" H ");
	s0 = s0.split("h").join(" h ");
	s0 = s0.split("V").join(" V ");
	s0 = s0.split("v").join(" v ");
	s0 = s0.split("C").join(" C ");
	s0 = s0.split("c").join(" c ");
	s0 = s0.split("S").join(" S ");
	s0 = s0.split("s").join(" s ");
	s0 = s0.split("Q").join(" Q ");
	s0 = s0.split("q").join(" q ");
	s0 = s0.split("T").join(" T ");
	s0 = s0.split("t").join(" t ");
	s0 = s0.split("A").join(" A ");
	s0 = s0.split("a").join(" a ");
	s0 = s0.split("Z").join(" Z ");
	s0 = s0.split("z").join(" z ");
	// ht:: Adobe includes no delimiter before negative numbers
	s0 = s0.split("-").join(" -");
	// cw:: use textfields collapseWhite property to shrink whitespaces
	_level0.__$DENG_TF$__.htmlText = s0; s0 = _level0.__$DENG_TF$__.text;
	var res = s0.split(" ");
	// cw:: delete trailing/leading whitespace if any
	if(res[0] == " ") { res.splice(0,1); }
	if(res[res.length-1] == " " || res[res.length-1].length == 0) { res.pop(); }
	return res; 
}


// -------------------------------------------------------------------------------------------
// trim functions by Gerrit E.G. 'Insh_Allah' Hobbelt
// -------------------------------------------------------------------------------------------
String.prototype.trimLeft = function(s) {
	if(s == undefined) { s = this; }
	var mx = s.length + 1;      
	var i;
	for(i = 1; i < mx; ++i) {
		if(ord(substring(s, i, 1)) > 32) {
			break;
		}
	}
	return substring(s, i, mx - i);
}

String.prototype.trimRight = function(s) {        
	if (s == undefined) { s = this; }
	var i;
	for(i = s.length; i > 0; --i) {
		if (ord(substring(s, i, 1)) > 32) {
			break;
		}
	}
	return substring(s, 1, i);
}

String.prototype.trim = function(s) {   
	if (s == undefined) { s = this; }
	var mx, i;
	for(mx = s.length; mx > 0; --mx) {
		if(ord(substring(s, mx, 1)) > 32) { break; }
	}
	for(i = 1; i < mx; ++i) {
		if(ord(substring(s, i, 1)) > 32) { break; }
	}
	return substring(s, i, mx + 1 - i);
}


