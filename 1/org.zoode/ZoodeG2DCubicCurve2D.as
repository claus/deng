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
 * new CubicCurve2D
 * Method; creates a new instance of the CubicCurve2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function CubicCurve2D(mc){
    super(mc);
    this.x1 = 0;
    this.y1 = 0;
    this.x2 = 0;
    this.y2 = 0;
    this.ctrlX1 = 0;
    this.ctrlY1 = 0;
    this.ctrlX2 = 0;
    this.ctrlY2 = 0;
    this.p1 = null;
    this.p2 = null;
    this.ctrlP1 = null;
    this.ctrlP2 = null;
    this.anchorP1 = null;
    this.anchorP2 = null;
    this.anchorP3 = null;
    }
    
    CubicCurve2D.extend(Shape);
    

/** 
 * getX1
 * Method; returns a number value indicating the x1 property of the CubicCurve2D instance.
 * @return A number value indicating the x1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getX1 = function(){
    return this.x1;
    }
    

/** 
 * getY1
 * Method; returns a number value indicating the y1 property of the CubicCurve2D instance.
 * @return A number value indicating the y1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getY1 = function(){
    return this.y1;
    }
    

/** 
 * getX2
 * Method; returns a number value indicating the x2 property of the CubicCurve2D instance.
 * @return A number value indicating the x2 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getX2 = function(){
    return this.x2;
    }
    

/** 
 * getY2
 * Method; returns a number value indicating the y2 property of the CubicCurve2D instance.
 * @return A number value indicating the y2 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getY2 = function(){
    return this.y2;
    }
    

/** 
 * getP1
 * Method; returns a Point2D instance indicating the p1 property of the CubicCurve2D instance.
 * @return A Point2D instance indicating the p1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getP1 = function(){
    return this.p1;
    }
    

/** 
 * getP2
 * Method; returns a Point2D instance indicating the p2 property of the CubicCurve2D instance.
 * @return A Point2D instance indicating the p2 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getP2 = function(){
    return this.p2;
    }
    

/** 
 * getCtrlX1
 * Method; returns a number value indicating the ctrlX1 property of the CubicCurve2D instance.
 * @return A number value indicating the ctrlX1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getCtrlX1 = function(){
    return this.ctrlX1;
    }
    

/** 
 * getCtrlY1
 * Method; returns a number value indicating the ctrlY1 property of the CubicCurve2D instance.
 * @return A number value indicating the ctrlY1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getCtrlY1 = function(){
    return this.ctrlY1;
    }
    

/** 
 * getCtrlX2
 * Method; returns a number value indicating the ctrlX2 property of the CubicCurve2D instance.
 * @return A number value indicating the ctrlX2 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getCtrlX2 = function(){
    return this.ctrlX2;
    }
    

/** 
 * getCtrlY2
 * Method; returns a number value indicating the ctrlY2 property of the CubicCurve2D instance.
 * @return A number value indicating the ctrlY2 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getCtrlY2 = function(){
    return this.ctrlY2;
    }
    

/** 
 * getCtrlP1
 * Method; returns a Point2D instance indicating the ctrlP1 property of the CubicCurve2D instance.
 * @return A Point2D instance indicating the ctrlP1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getCtrlP1 = function(){
    return this.ctrlP1;
    }
    

/** 
 * getCtrlP2
 * Method; returns a Point2D instance indicating the ctrlP2 property of the CubicCurve2D instance.
 * @return A Point2D instance indicating the ctrlP2 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getCtrlP2 = function(){
    return this.ctrlP2;
    }
    

/** 
 * getAnchorP1
 * Method; returns a Point2D instance indicating the anchorP1 property of the CubicCurve2D instance.
 * As cubic curve is approximated from four quadratic curves, this Point2D instance refers to the first calculated anchor point that comes after the start point of the curve.
 * @return A Point2D instance indicating the anchorP1 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getAnchorP1 = function(){
    return this.anchorP1;
    }
    

/** 
 * getAnchorP2
 * Method; returns a Point2D instance indicating the anchorP2 property of the CubicCurve2D instance.
 * @return A Point2D instance indicating the anchorP2 property of the CubicCurve2D instance.
 * @return As cubic curve is approximated from four quadratic curves, this Point2D instance refers to the second calculated anchor point.
 */
    CubicCurve2D.prototype.getAnchorP2 = function(){
    return this.anchorP2;
    }
    

/** 
 * getAnchorP3
 * Method; returns a Point2D instance indicating the anchorP3 property of the CubicCurve2D instance.
 * As cubic curve is approximated from four quadratic curves, this Point2D instance refers to the last calculated anchor point that comes before the end point of the curve.
 * @return A Point2D instance indicating the anchorP3 property of the CubicCurve2D instance.
 */
    CubicCurve2D.prototype.getAnchorP3 = function(){
    return this.anchorP3;
    }
    

/** 
 * setCurve
 * Method; sets the x1, y1, ctrlX1, ctrlY1, ctrlX2, ctrlY2, x2 and y2 properties of the CubicCurve2D instance.
 * @param x1 x coordinate of the start point 
 * @param y1 y coordinate of the start point  
 * @param ctrlX1 x coordinate of the first control point 
 * @param ctrlY1 y coordinate of the first control point 
 * @param ctrlX2 x coordinate of the second control point 
 * @param ctrlY2 y coordinate of the second control point 
 * @param x2 x coordinate of the end point  
 * @param y2 y coordinate of the end point  
 * @return Nothing.
 */
    CubicCurve2D.prototype.setCurve = function(x1, y1, ctrlX1, ctrlY1, ctrlX2, ctrlY2, x2, y2){
    this.x1 = x1;
    this.y1 = y1;
    this.ctrlX1 = ctrlX1;
    this.ctrlY1 = ctrlY1;
    this.ctrlX2 = ctrlX2;
    this.ctrlY2 = ctrlY2;
    this.x2 = x2;
    this.y2 = y2;
    // start, end and 2 control points of the cubic curve instance
    this.p1 = new Point2D(this.x1, this.y1);
    this.p2 = new Point2D(this.x2, this.y2);
    this.ctrlP1 = new Point2D(this.ctrlX1, this.ctrlY1);
    this.ctrlP2 = new Point2D(this.ctrlX2, this.ctrlY2);
    }
    

/** 
 * getPointsOnCurve
 * Method; returns point2D instances at n intervals along a CubicCurve2D instance.
 * Note that (with the current release), this method gives approximative results.
 * It requires that n is a multiple of 4, last anchor point of the CubicCurve2D is not returned.
 * @return Nothing.
 */
    CubicCurve2D.prototype.getPointsOnCurve = function(num){
    return Math.plotPointsOnCubicCurve(this.getP1(), this.getCtrlP1(), this.getCtrlP2(), this.getP2(), num);
    }

/** 
 * getEquidistantPointsOnCurve
 * Method; returns virtually equidistant point2D instances along a CubicCurve2D instance.
 * Note that this method will not return first and last anchor points of the CubicCurve2D.
 * @return Nothing.
 */
    CubicCurve2D.prototype.getEquidistantPointsOnCurve = function(dist, step, stray){
    return Math.plotEquidistantPointsOnCubicCurve(this.getP1(), this.getCtrlP1(), this.getCtrlP2(), this.getP2(), dist, step, stray);
    }

/** 
 * draw
 * Method; draw method of the CubicCurve2D class.
 * @return Nothing.
 */
    CubicCurve2D.prototype.draw = function(){
     // see Math.solveCubic
     var s = Math.solveCubic(this.p1, this.p2, this.ctrlP1, this.ctrlP2);
     // set anchor points
     this.anchorP1 = s.ap1;
     this.anchorP2 = s.ap2;
     this.anchorP3 = s.ap3;
    this.startStroke();
    this.startFill();
    this.moveTo(this.getX1(), this.getY1());
    // draw the four quadratic subsegments
    this.curveTo(s.cp1.getX(), s.cp1.getY(), s.ap1.getX(), s.ap1.getY());
    this.curveTo(s.cp2.getX(), s.cp2.getY(), s.ap2.getX(), s.ap2.getY());
    this.curveTo(s.cp3.getX(), s.cp3.getY(), s.ap3.getX(), s.ap3.getY());
    this.curveTo(s.cp4.getX(), s.cp4.getY(), this.getX2(), this.getY2());
    this.finishFill();
    }
// custom toString method
    CubicCurve2D.prototype.toString = function(){
      return "[object CubicCurve2D]";
      }
      
      


      
