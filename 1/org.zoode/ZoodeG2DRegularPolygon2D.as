//!-- UTF8

// Code generated with ASBOT (package module v. 0.2.0) 
// http://www.zoode.org/projects/asbot/
// at 23:30 on 22 Mar 2003

/** 
 * Geometries2D
 * @author Ahmet Zorlu
 * @version 1.0.0
 */

//#include "org.zoode/ZoodeGeometries2DBasics.as"

/** 
 * new RegularPolygon2D
 * Method; creates a new instance of the RegularPolygon2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function RegularPolygon2D(mc){
    super(mc);
    this.vertices = new Array();
    this.x = 0;
    this.y = 0;
    this.circumRadius = 0;
    this.sidesNum = 0;
    this.startAngle = 0;
    this.inRadius = 0;
    this.sideLength = 0;
    }
    
    RegularPolygon2D.extend(Shape);
    

/** 
 * getVertices
 * Method; returns an array containing the vertices (Point2D instances) of the RegularPolygon2D instance.
 * @return An array containing the vertices (Point2D instances) of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getVertices = function(){
    return this.vertices;
    }
    

/** 
 * getX
 * Method; returns a number value indicating the x coordinate of the center of the RegularPolygon2D instance.
 * @return A number value indicating the x coordinate of the center of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y coordinate of the center of the RegularPolygon2D instance.
 * @return A number value indicating the y coordinate of the center of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * getInRadius
 * Method; returns a number value indicating the inRadius property of the RegularPolygon2D instance.
 * @return A number value indicating the inRadius property of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getInRadius = function(){
    return this.inRadius;
    }
    

/** 
 * getCircumRadius
 * Method; returns a number value indicating the circumRadius property of the RegularPolygon2D instance.
 * @return A number value indicating the circumRadius property of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getCircumRadius = function(){
    return this.circumRadius;
    }
    

/** 
 * getStartAngle
 * Method; returns a number value indicating the startAngle property of the RegularPolygon2D instance.
 * @return A number value indicating the startAngle property of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getStartAngle = function(){
    return this.startAngle;
    }
    

/** 
 * getSidesNum
 * Method; returns a number value indicating the sidesNum property of the RegularPolygon2D instance.
 * @return A number value indicating the sidesNum property of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getSidesNum = function(){
    return this.sidesNum;
    }
    

/** 
 * getSideLength
 * Method; returns a number value indicating the sideLength property of the RegularPolygon2D instance.
 * @return A number value indicating the sideLength property of the RegularPolygon2D instance.
 */
    RegularPolygon2D.prototype.getSideLength = function(){
    return this.sideLength;
    }
    

/** 
 * setRegularPolygon
 * Method; sets the x, y, circumRadius, sidesNum and startAngle properties of the RegularPolygon2D instance.
 * @param x x coordinate of the center point of the regular polygon 
 * @param y x coordinate of the center point of the regular polygon 
 * @param circumRadius circumradius of the regular polygon 
 * @param sidesNum total number of the sides of the regular polygon 
 * @param startAngle start angle of the regular polygon - defines the amount of rotation in degrees 
 * @return Nothing.
 */
    RegularPolygon2D.prototype.setRegularPolygon = function(x, y, circumRadius, sidesNum, startAngle){
    this.x = x;
    this.y = y;
    this.circumRadius = circumRadius;
    this.sidesNum = sidesNum;
    this.startAngle = startAngle;
    // reference: mc.drawPoly() - by Ric Ewing (www.formequalsfunction.com) - version 1.4 - 4.7.2002
    // calculation of inradius and sidelength (http://mathworld.wolfram.com/RegularPolygon.html)
    this.inRadius = this.circumRadius * Math.cos(Math.PI / this.sidesNum);
    this.sideLength = 2 * this.circumRadius * Math.sin(Math.PI / this.sidesNum);
    // check that count is sufficient to build polygon
    if (this.sidesNum>2) {
    // init vars
    var dx, dy;
    // calculate span of sides
    var steps = (Math.PI * 2) / this.sidesNum;
    // calculate the points of the polygon
    for (var i = 1; i <= this.sidesNum; i++) {
    dx = this.x + Math.cos(Math.toRadians(this.startAngle) +(steps * i))* this.circumRadius;
    dy = this.y - Math.sin(Math.toRadians(this.startAngle) +(steps * i))* this.circumRadius;
    this.vertices.push(new Point2D(dx, dy));
        } // for loop ends here
    } // if condition ends here
    }
    

/** 
 * draw
 * Method; draw method of the RegularPolygon2D class.
 * @return Nothing.
 */
    RegularPolygon2D.prototype.draw = function(){
    var len = this.vertices.length;
    this.startStroke();
    this.startFill();
    this.moveTo(this.getX() + (Math.cos(Math.toRadians(this.startAngle))* this.circumRadius), this.getY() - (Math.sin(Math.toRadians(this.startAngle)) * this.circumRadius));
    for (var i = 0; i < len; i++) {
    this.lineTo(this.vertices[i].getX(), this.vertices[i].getY());
    }
    this.finishFill();
    }
// custom toString method
    RegularPolygon2D.prototype.toString = function(){
      return "[object RegularPolygon2D]";
      }
      
      