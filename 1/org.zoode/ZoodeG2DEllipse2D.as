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
 * new Ellipse2D
 * Method; creates a new instance of the Ellipse2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function Ellipse2D(mc){
    super(mc);
    this.x = 0;
    this.y = 0;
    this.width = 0;
    this.height = 0;
    this.controlPoints = new Array();
    this.anchorPoints = new Array();
    }
    
    Ellipse2D.extend(Shape);
    

/** 
 * getX
 * Method; returns a number value indicating the x coordinate of the center of the Ellipse2D instance.
 * @return A number value indicating the x coordinate of the center of the Ellipse2D instance.
 */
    Ellipse2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y coordinate of the center of the Ellipse2D instance.
 * @return A number value indicating the y coordinate of the center of the Ellipse2D instance.
 */
    Ellipse2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * getWidth
 * Method; returns a number value indicating the width property of the Ellipse2D instance.
 * @return A number value indicating the width property of the Ellipse2D instance.
 */
    Ellipse2D.prototype.getWidth = function(){
    return this.width;
    }
    

/** 
 * getHeight
 * Method; returns a number value indicating the height property of the Ellipse2D instance.
 * @return A number value indicating the height property of the Ellipse2D instance.
 */
    Ellipse2D.prototype.getHeight = function(){
    return this.height;
    }
    

/** 
 * getControlPoints
 * Method; returns an array containing the control points (Point2D instances) which are used to calculate the curves of the Ellipse2D instance.
 * The order is clock-wise and the default number of elements is 8.
 * If the segmentCount variable is defined, number of elements is equal to this value.
 * @return An array containing the control points (Point2D instances) of the Ellipse2D instance.
 */
    Ellipse2D.prototype.getControlPoints = function(){
    return this.controlPoints;
    }
    

/** 
 * getAnchorPoints
 * Method; returns an array containing the anchor points (Point2D instances) which are used to calculate the curves of the Ellipse2D instance.
 * The order is clock-wise and the default number of elements is 8.
 * If the segmentCount variable is defined, number of elements is equal to this value.
 * @return An array containing the anchor points (Point2D instances) of the Ellipse2D instance.
 */
    Ellipse2D.prototype.getAnchorPoints = function(){
    return this.anchorPoints;
    }
    

/** 
 * setEllipse
 * Method; sets the x, y, width, height and  properties of the Ellipse2D instance.
 * @param x x coordinate of the center of the ellipse 
 * @param y y coordinate of the center of the ellipse 
 * @param width width of the ellipse 
 * @param height height of the ellipse 
 * @param segmentCount the number of quadratic curve segments which are used for drawing the ellipse 
 * @return Nothing.
 */
    Ellipse2D.prototype.setEllipse = function(x, y, width, height, segmentCount){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    // Ref: http://www.layer51.com/proto/d.aspx?f=383 (slightly modified by A. Zorlu)
    // (c) Ivan Dembicki, thanks for help Casper Schuirink
    // optional last parameter defines the number of set of points that will be used to draw the ellipse
    // default value for this parameter is 8 : in swf 8 quadratic segments will give acceptable results (360/45)
    // min value for last parameter is 1 (360 points)  - max value for last parameter is 180 (straight line)
    var seg = segmentCount ? 360 / Math.max(Math.min(segmentCount, 180), 1) : 45;
    var controlX, controlY, anchorX, anchorY;
    for (var s = seg; s <= 360; s += seg) {
    anchorX = this.getWidth() * Math.cos(Math.toRadians(s));
    anchorY = this.getHeight() * Math.sin(Math.toRadians(s ));
    controlX = anchorX + this.getWidth() * Math.tan(Math.toRadians(seg/2)) *Math.cos(Math.toRadians(s-90));
    controlY = anchorY + this.getHeight() * Math.tan(Math.toRadians(seg/2)) *Math.sin(Math.toRadians(s-90));
    this.anchorPoints.push(new Point2D(anchorX + this.getX(), anchorY + this.getY()));
    this.controlPoints.push(new Point2D(controlX + this.getX(), controlY + this.getY()));
    }
    }
    

/** 
 * draw
 * Method; draw method of the Ellipse2D class.
 * @return Nothing.
 */
    Ellipse2D.prototype.draw = function(){
    var len = this.anchorPoints.length;
    this.startStroke();
    this.startFill();
    this.moveTo(this.getX() + this.getWidth(), this.getY()); 
    for (var i = 0; i < len; i++) {
    this.curveTo(this.controlPoints[i].getX(), this.controlPoints[i].getY(), this.anchorPoints[i].getX(), this.anchorPoints[i].getY());
    }
    this.finishFill();
    }
// custom toString method
    Ellipse2D.prototype.toString = function(){
      return "[object Ellipse2D]";
      }
      
      
