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
 * new QuadCurve2D
 * Method; creates a new instance of the QuadCurve2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function QuadCurve2D(mc){
    super(mc);
    this.x1 = 0;
    this.y1 = 0;
    this.x2 = 0;
    this.y2 = 0;
    this.ctrlX = 0;
    this.ctrlY = 0;
    this.ctrlPt = null;
    this.p1 = null;
    this.p2 = null;
    }
    
    QuadCurve2D.extend(Shape);
    

/** 
 * getX1
 * Method; returns a number value indicating the x1 property of the QuadCurve2D instance.
 * @return A number value indicating the x1 property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getX1 = function(){
    return this.x1;
    }
    

/** 
 * getY1
 * Method; returns a number value indicating the y1 property of the QuadCurve2D instance.
 * @return A number value indicating the y1 property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getY1 = function(){
    return this.y1;
    }
    

/** 
 * getX2
 * Method; returns a number value indicating the x2 property of the QuadCurve2D instance.
 * @return A number value indicating the x2 property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getX2 = function(){
    return this.x2;
    }
    

/** 
 * getY2
 * Method; returns a number value indicating the y2 property of the QuadCurve2D instance.
 * @return A number value indicating the y2 property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getY2 = function(){
    return this.y2;
    }
    

/** 
 * getP1
 * Method; returns a Point2D instance indicating the p1 property of the QuadCurve2D instance.
 * @return A Point2D instance indicating the p1 property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getP1 = function(){
    return this.p1;
    }
    

/** 
 * getP2
 * Method; returns a object value indicating the p2 property of the QuadCurve2D instance.
 * @return A object value indicating the p2 property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getP2 = function(){
    return this.p2;
    }
    

/** 
 * getCtrlX
 * Method; returns a number value indicating the ctrlX property of the QuadCurve2D instance.
 * @return A number value indicating the ctrlX property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getCtrlX = function(){
    return this.ctrlX;
    }
    

/** 
 * getCtrlY
 * Method; returns a number value indicating the ctrlY property of the QuadCurve2D instance.
 * @return A number value indicating the ctrlY property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getCtrlY = function(){
    return this.ctrlY;
    }
    

/** 
 * getCtrlPt
 * Method; returns a Point2D instance indicating the ctrlPt property of the QuadCurve2D instance.
 * @return A Point2D instance indicating the ctrlPt property of the QuadCurve2D instance.
 */
    QuadCurve2D.prototype.getCtrlPt = function(){
    return this.ctrlPt;
    }
    

/** 
 * setCurve
 * Method; sets the x1, y1, ctrlX, ctrlY, x2 and y2 properties of the QuadCurve2D instance.
 * @param x1 x coordinate of the start point 
 * @param y1 y coordinate of the start point 
 * @param ctrlX x coordinate of the control point 
 * @param ctrlY y coordinate of the control point 
 * @param x2 x coordinate of the end point 
 * @param y2 y coordinate of the end point 
 * @return Nothing.
 */
    QuadCurve2D.prototype.setCurve = function(x1, y1, ctrlX, ctrlY, x2, y2){
    this.x1 = x1;
    this.y1 = y1;
    this.ctrlX = ctrlX;
    this.ctrlY = ctrlY;
    this.x2 = x2;
    this.y2 = y2;
    // start, end and control points of the quadratic curve instance
    this.p1 = new Point2D(this.x1, this.y1);
    this.p2 = new Point2D(this.x2, this.y2);
    this.ctrlPt = new Point2D(this.ctrlX, this.ctrlY);
    }
    

/** 
 * getPointsOnCurve
 * Method; returns point2D instances at n intervals along a QuadCurve2D instance.
 * Note that this method will return n Point2D instances, last anchor point of the QuadCurve2D is not returned.
 * @return Nothing.
 */
    QuadCurve2D.prototype.getPointsOnCurve = function(num){
     return Math.plotPointsOnQuadCurve(this.getP1(), this.getCtrlPt(), this.getP2(), num);
    }

/** 
 * getEquidistantPointsOnCurve
 * Method; returns virtually equidistant point2D instances along a QuadCurve2D instance.
 * Note that this method will not return first and last anchor points of the QuadCurve2D.
 * @return Nothing.
 */
    QuadCurve2D.prototype.getEquidistantPointsOnCurve = function(dist, step, stray){
    return Math.plotEquidistantPointsOnQuadCurve(this.getP1(), this.getCtrlPt(), this.getP2(), dist, step, stray);
    }

/** 
 * draw
 * Method; draw method of the QuadCurve2D class.
 * @return Nothing.
 */
    QuadCurve2D.prototype.draw = function(){
    this.startStroke();
    this.startFill();
    this.moveTo(this.getX1(), this.getY1());
    this.curveTo(this.getCtrlX(), this.getCtrlY(), this.getX2(), this.getY2());
    this.finishFill();
    }
// custom toString method
    QuadCurve2D.prototype.toString = function(){
      return "[object QuadCurve2D]";
      }
      
      


      
      
