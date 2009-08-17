//!-- UTF8

// Code generated with ASBOT (package module v. 0.2.0) 
// http://www.zoode.org/projects/asbot/
// at 23:30 on 22 Mar 2003

// interim patch : 05.18.2003

/** 
 * Geometries2D
 * @author Ahmet Zorlu
 * @version 1.0.0
 */

#include "org.zoode/ZoodeGeometries2DBasics.as"

/** 
 * new GeneralPath
 * Method; creates a new instance of the GeneralPath class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function GeneralPath(mc){
    super(mc);
    this.subPaths = new Array();
    }
    
    GeneralPath.extend(Shape);
    

/** 
 * getSubPaths
 * Method; returns an array containing the individual subPaths of the GeneralPath instance.
 * Each element of the array is a custom object with defined fields.
 * The main field is "command" and it can have these values: "m" (move), "l" (addLine), "q" (addQuad), "c" (addCubic), "close" (closePath).
 * The object with the command field "m" (move) has two more fields: arg1:x, arg2:y.
 * The object with the command field "l" (addLine) has two more fields: arg1:x, arg2:y.
 * The object with the command field "q" (addQuad) has four more fields: arg1:ctrlX, arg2:ctrlY, arg3:x, arg4:y.
 * The object with the command field "c" (addCubic) has six more fields: arg1:ctrlX1, arg2:ctrlY1, arg3:ctrlX2, arg4:ctrlY2, arg5:x, arg6:y.
 * The object with the command field "close" (closePath) doesn't have any more fields.
 * @return A object value indicating the subPaths property of the GeneralPath instance.
 */
    GeneralPath.prototype.getSubPaths = function(){
    return this.subPaths;
    }
    

/** 
 * move
 * Method; adds a point to the path by moving to the specified coordinates.
 * @param x the new x coordinate where the drawing pen will be moved 
 * @param y the new y coordinate where the drawing pen will be moved 
 * @return Nothing.
 */
    GeneralPath.prototype.move = function(x, y){
    this.subPaths.push({command:"m", arg1:x, arg2:y});
    // v1.0.2 :: penStart and pen are at the same location
    this.penStartX = this.penX = x;
    this.penStartY = this.penY = y;
    }
    

/** 
 * addLine
 * Method; adds a straight line segment to the path by drawing a straight line from the current coordinates to the new specified coordinates.
 * @param x x coordinate of the end point of the line 
 * @param y y coordinate of the end point of the line 
 * @return Nothing.
 */
    GeneralPath.prototype.addLine = function(x, y){
    this.subPaths.push({command:"l", arg1:x, arg2:y});
    this.penX = x;
    this.penY = y;
    }
    

/** 
 * addQuad
 * Method; adds a curved segment to the path by drawing a quadratic curve that intersects both the current coordinates and the coordinates (x, y), using the specified point (ctrlX, ctrlY) as a quadratic parametric control point.
 * @param ctrlX x coordinate of the quadratic parametric control point 
 * @param ctrlY y coordinate of the quadratic parametric control point 
 * @param x x coordinate of the last anchor point of the quadratic parametric 
 * @param y y coordinate of the last anchor point of the quadratic parametric 
 * @return Nothing.
 */
    GeneralPath.prototype.addQuad = function(ctrlX, ctrlY, x, y){
    this.subPaths.push({command:"q", arg1:ctrlX, arg2:ctrlY, arg3:x, arg4:y});
    this.penX = x;
    this.penY = y;
    }
    

/** 
 * addCubic
 * Method; adds a curved segment to the path by drawing a cubic curve that intersects both the current coordinates and the coordinates (x, y), using the specified points (ctrlX1, ctrlY1) and (ctrlX2, ctrlY2) as cubic control points.
 * @param ctrlX1 x coordinate of the first cubic parametric control point 
 * @param ctrlY1 y coordinate of the first cubic parametric control point 
 * @param ctrlX x coordinate of the second cubic parametric control point 
 * @param ctrlY y coordinate of the second cubic parametric control point 
 * @param x x coordinate of the last anchor point of the quadratic parametric 
 * @param y y coordinate of the last anchor point of the quadratic parametric 
 * @return Nothing.
 */
    GeneralPath.prototype.addCubic = function(ctrlX1, ctrlY1, ctrlX2, ctrlY2, x, y){
    this.subPaths.push({command:"c", arg1:ctrlX1, arg2:ctrlY1, arg3:ctrlX2, arg4:ctrlY2, arg5:x, arg6:y});
    this.penX = x;
    this.penY = y;
    }

/** 
 * closePath
 * Method; closes the current subpath by drawing a straight line back to the coordinates of the last move command.
 * @return Nothing.
 */
    GeneralPath.prototype.closePath = function(){
    // closes the current subpath by drawing a straight line back to the coordinates of the last moveTo
    this.subPaths.push( { command:"close"} );
    this.penX = this.penStartX;
    this.penY = this.penStartY;
    }

/** 
 * draw
 * Method; draw method of the GeneralPath class.
 * @return Nothing.
 */
GeneralPath.prototype.draw = function()
{
	this.startStroke();
	this.startFill();
	var len = this.subPaths.length;
	for (var i = 0; i < len; i++) {
		var _sp = this.subPaths[i];
		switch(_sp.command) {
			case "m":
				this.moveTo(_sp.arg1, _sp.arg2);
				break;
			case "l":
				this.lineTo(_sp.arg1, _sp.arg2);
				break;
			case "q":
				this.curveTo(_sp.arg1, _sp.arg2, _sp.arg3, _sp.arg4);
				break;
			case "c":
				// v1.0.2 :: 
				// BUG FIX:: if the last command is a *move* command 
				// the first point2D is the pen start location
				// else it is the pen location
				// Math.solveCubic parameters order is pt1, pt2, ctrlPt1, ctrlPt2
				var startPt = new Point2D();
				if (this.subPaths[i-1].command == "m" || this.subPaths[i-1].command == undefined) {
					startPt.setLocation(this.penStartX, this.penStartY);
				} else {
					startPt.setLocation(this.penX, this.penY);
				}	   
				var s = Math.solveCubic(startPt, new Point2D(_sp.arg5, _sp.arg6), new Point2D(_sp.arg1, _sp.arg2), new Point2D(_sp.arg3, _sp.arg4));
				this.curveTo(s.cp1.x, s.cp1.y, s.ap1.x, s.ap1.y);
				this.curveTo(s.cp2.x, s.cp2.y, s.ap2.x, s.ap2.y);
				this.curveTo(s.cp3.x, s.cp3.y, s.ap3.x, s.ap3.y);
				this.curveTo(s.cp4.x, s.cp4.y, _sp.arg5, _sp.arg6);
				break;
			case "close":
				this.lineTo(this.penStartX, this.penStartY);
				break;
		}
	}
	this.finishFill();
}



// custom toString method
GeneralPath.prototype.toString = function()
{
	return "[object GeneralPath]";
}
      
      
