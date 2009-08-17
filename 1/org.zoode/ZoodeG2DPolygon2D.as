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
 * new Polygon2D
 * Method; creates a new instance of the Polygon2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function Polygon2D(mc){
    super(mc);
    this.xPoints = new Array();
    this.yPoints = new Array();
    this.vertices = new Array();
    }
    
    Polygon2D.extend(Shape);
    

/** 
 * getVertices
 * Method; returns an array containing the vertices (Point2D instances) of the Polygon2D instance.
 * @return A an array containing the vertices of the Polygon2D instance.
 */
    Polygon2D.prototype.getVertices = function(){
    return this.vertices;
    }
    

/** 
 * setPolygon
 * Method; sets the vertices of the Polygon2D instance.
 * @param xPoints the array of x coordinates 
 * @param yPoints the array of y coordinates 
 * @param nPoints the total number of points - this value is optional.  
 * @return Nothing.
 */
    Polygon2D.prototype.setPolygon = function(xPoints, yPoints, nPoints){
    this.xPoints = xPoints;
    this.yPoints = yPoints;
    var n = (nPoints != undefined) ? nPoints : Math.min(this.xPoints.length,  this.yPoints.length);
    for (var i = 0; i < n; i++){
    this.vertices.push(new Point2D(this.xPoints[i], this.yPoints[i]));
    }
    }
    

/** 
 * addPoint
 * Method; Adds a vertex point to the Polygon2D instance.
 * @param pt a Point2D instance which will be appended to the Polygon2D instance 
 * @return Nothing.
 */
    Polygon2D.prototype.addPoint = function(pt){
    this.vertices.push(pt);
    this.xPoints.push(pt.getX());
    this.yPoints.push(pt.getY());
    }
    

/** 
 * draw
 * Method; draw method of the Polygon2D class.
 * @return Nothing.
 */
    Polygon2D.prototype.draw = function(){
    var len = this.vertices.length;
    this.startStroke();
    this.startFill();
    this.moveTo (this.vertices[0].getX(), this.vertices[0].getY());
    while (len--) this.lineTo(this.vertices[len].getX(), this.vertices[len].getY());
    this.finishFill();
    }
// custom toString method
    Polygon2D.prototype.toString = function(){
      return "[object Polygon2D]";
      }
      
      