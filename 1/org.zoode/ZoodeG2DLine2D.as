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
 * new Line2D
 * Method; creates a new instance of the Line2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function Line2D(mc){
    super(mc);
    this.x1 = 0;
    this.y1 = 0;
    this.x2 = 0;
    this.y2 = 0;
    this.p1 = null;
    this.p2 = null;
    }
    
    Line2D.extend(Shape);
    

/** 
 * getX1
 * Method; returns a number value indicating the x1 property of the Line2D instance.
 * @return A number value indicating the x1 property of the Line2D instance.
 */
    Line2D.prototype.getX1 = function(){
    return this.x1;
    }
    

/** 
 * getY1
 * Method; returns a number value indicating the y1 property of the Line2D instance.
 * @return A number value indicating the y1 property of the Line2D instance.
 */
    Line2D.prototype.getY1 = function(){
    return this.y1;
    }
    

/** 
 * getX2
 * Method; returns a number value indicating the x2 property of the Line2D instance.
 * @return A number value indicating the x2 property of the Line2D instance.
 */
    Line2D.prototype.getX2 = function(){
    return this.x2;
    }
    

/** 
 * getY2
 * Method; returns a number value indicating the y2 property of the Line2D instance.
 * @return A number value indicating the y2 property of the Line2D instance.
 */
    Line2D.prototype.getY2 = function(){
    return this.y2;
    }
    

/** 
 * getP1
 * Method; returns a Point2D instance indicating the p1 property of the Line2D instance.
 * @return A Point2D instance indicating the p1 property of the Line2D instance.
 */
    Line2D.prototype.getP1 = function(){
    return this.p1;
    }
    

/** 
 * getP2
 * Method; returns a Point2D instance indicating the p2 property of the Line2D instance.
 * @return A Point2D instance indicating the p2 property of the Line2D instance.
 */
    Line2D.prototype.getP2 = function(){
    return this.p2;
    }
    

/** 
 * setLine
 * Method; sets the x1, y1, x2 and y2 properties of the Line2D instance.
 * @param x1 x coordinate of the start point of the line 
 * @param y1 y coordinate of the start point of the line 
 * @param x2 x coordinate of the end point of the line 
 * @param y2 y coordinate of the end point of the line 
 * @return Nothing.
 */
    Line2D.prototype.setLine = function(x1, y1, x2, y2){
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    // start and end points of the line instance
    this.p1 = new Point2D(this.x1, this.y1);
    this.p2 = new Point2D(this.x2, this.y2);
    }
    

/** 
 * getPointsOnLine
 * Method; returns point2D instances at n intervals along a Line2D instance.
 * Note that this method will return n Point2D instances, last anchor point of the Line2D is not returned.
 * @return Nothing.
 */
    Line2D.prototype.getPointsOnLine = function(num){
    return Math.plotPointsOnLine(this.getP1(), this.getP2(), num);
    }

/** 
 * getEquidistantPointsOnLine
 * Method; returns virtually equidistant point2D instances along a Line2D instance.
 * Note that this method will not return first and last anchor points of the Line2D.
 * @return Nothing.
 */
    Line2D.prototype.getEquidistantPointsOnLine = function(dist, step, stray){
    return Math.plotEquidistantPointsOnLine(this.getP1(), this.getP2(), dist, step, stray);
    }

/** 
 * draw
 * Method; draw method of the Line2D class.
 * @return Nothing.
 */
    Line2D.prototype.draw = function(){
    this.startStroke();
    this.moveTo(this.getX1(),this.getY1());
    this.lineTo(this.getX2(),this.getY2());
    }
// custom toString method
    Line2D.prototype.toString = function(){
      return "[object Line2D]";
      }
      
      

