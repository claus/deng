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
 * new Arc2D
 * Method; creates a new instance of the Arc2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function Arc2D(mc){
    super(mc);
    this.x = 0;
    this.y = 0;
    this.width = 0;
    this.height = 0;
    this.angleStart = 0;
    this.angleExtent = 0;
    this.closureType = "OPEN";
    this.controlPoints = new Array();
    this.anchorPoints = new Array();
    this.centerPoint = null;
    this.startPoint = null;
    this.endPoint = null;
    }
    
    Arc2D.extend(Shape);
    

/** 
 * getX
 * Method; returns a number value indicating the x property of the Arc2D instance.
 * @return A number value indicating the x property of the Arc2D instance.
 */
    Arc2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y property of the Arc2D instance.
 * @return A number value indicating the y property of the Arc2D instance.
 */
    Arc2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * getWidth
 * Method; returns a number value indicating the width property of the Arc2D instance.
 * @return A number value indicating the width property of the Arc2D instance.
 */
    Arc2D.prototype.getWidth = function(){
    return this.width;
    }
    

/** 
 * getHeight
 * Method; returns a number value indicating the height property of the Arc2D instance.
 * @return A number value indicating the height property of the Arc2D instance.
 */
    Arc2D.prototype.getHeight = function(){
    return this.height;
    }
    

/** 
 * getAngleStart
 * Method; returns a number value indicating the angleStart property of the Arc2D instance.
 * @return A number value indicating the angleStart property of the Arc2D instance.
 */
    Arc2D.prototype.getAngleStart = function(){
    return this.angleStart;
    }
    

/** 
 * getAngleExtent
 * Method; returns a number value indicating the angleExtent property of the Arc2D instance.
 * @return A number value indicating the angleExtent property of the Arc2D instance.
 */
    Arc2D.prototype.getAngleExtent = function(){
    return this.angleExtent;
    }
    

/** 
 * getClosureType
 * Method; returns a string value indicating the closureType property of the Arc2D instance.
 * @return A string value indicating the closureType property of the Arc2D instance.
 */
    Arc2D.prototype.getClosureType = function(){
    return this.closureType;
    }
    

/** 
 * getControlPoints
 * Method; returns an array containing the control points (Point2D instances) which are used to calculate the curves of the Arc2D instance.
 * The order is counter-clock-wise and the number of elements depends on the angleExtent variable (Math.cei(angleExtent/45)).
 * @return An array containing the control points (Point2D instances) of the Arc2D instance.
 */
    Arc2D.prototype.getControlPoints = function(){
    return this.controlPoints;
    }
    

/** 
 * getAnchorPoints
 * Method; returns an array containing the anchor points (Point2D instances) which are used to calculate the curves of the Arc2D instance.
 * The order is counter-clock-wise and the number of elements depends on the angleExtent variable (Math.cei(angleExtent/45)).
 * @return An array containing the anchor points (Point2D instances) of the Arc2D instance.
 */
    Arc2D.prototype.getAnchorPoints = function(){
    return this.anchorPoints;
    }
    

/** 
 * getCenterPoint
 * Method; returns the center point (Point2D instance) of the Arc2D instance.
 * If the closure type of the arc is "PIE" this point is used for drawing the PIE shape.
 * @return A Point2D instance indicating the center point of the Arc2D instance.
 */
    Arc2D.prototype.getCenterPoint = function(){
    return this.centerPoint;
    }
    

/** 
 * getStartPoint
 * Method; returns the start point (Point2D instance) of the Arc2D instance.
 * @return A Point2D instance indicating  the start point of the Arc2D instance.
 */
    Arc2D.prototype.getStartPoint = function(){
    return this.startPoint;
    }
    

/** 
 * getEndPoint
 * Method; returns end point (Point2D instance) of the Arc2D instance.
 * @return A Point2D instance indicating the end point of the Arc2D instance.
 */
    Arc2D.prototype.getEndPoint = function(){
    return this.endPoint;
    }
    

/** 
 * setArc
 * Method; sets the x, y, width, height, angleStart, angleExtent and closureType properties of the Arc2D instance.
 * @param x x coordinate of the start point of the arc 
 * @param y y coordinate of the start point of the arc 
 * @param width the overall width of the full ellipse of which this arc is a partial section 
 * @param height the overall height of the full ellipse of which this arc is a partial section 
 * @param angleStart the starting angle of the arc in degrees 
 * @param angleExtent the angular extent (length of the arc) of the arc in degrees 
 * @param closureType closure type of the arc - can be one of these constant values: "OPEN", "CHORD", "PIE" 
 * @return Nothing.
 */
    Arc2D.prototype.setArc = function(x, y, width, height, angleStart, angleExtent, closureType){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.angleStart = angleStart;
    this.angleExtent = angleExtent;
    this.closureType = closureType;
    // optional last parameter (a string) indicates the closure type: OPEN, CHORD, PIE
    // mc.drawArc() - by Ric Ewing (www.formequalsfunction.com) - version 1.5 - 4.7.2002
    // Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions
    // the arc will be drawn counter-clockwise;
    // init vars
    var theta, currentAngle, angleMid, centerX, centerY, anchorX, anchorY, controlX, controlY;
    var seg = Math.ceil(Math.abs(this.angleExtent) / 45); // 8 segments will give acceptable results
    // the sweep of each segment
    var segmentAngle = this.angleExtent / seg;
    theta = -Math.toRadians(segmentAngle);
    currentAngle = -Math.toRadians(this.angleStart);
    // find our starting points relative to the specified x,y
    centerX = this.getX() - Math.cos(currentAngle) * this.getWidth();
    centerY = this.getY() - Math.sin(currentAngle) * this.getHeight();
    this.centerPoint = new Point2D(centerX, centerY);
    this.startPoint = new Point2D(this.getX(), this.getY());
    // if our arc is larger than 45 degrees, we draw as 45 degree segments
    if (seg > 0) {
    // Loop for calculating arc segment points
    for (var i = 0; i < seg; i++) {
    // increment our angle
    currentAngle += theta;
    // find the angle halfway between the last angle and the new angle
    angleMid = currentAngle - (theta / 2);
    // calculate and store the anchor and control points
    anchorX = centerX + Math.cos(currentAngle) * this.getWidth();
    anchorY = centerY + Math.sin(currentAngle) * this.getHeight();
    controlX = centerX + Math.cos(angleMid) * (this.getWidth() / Math.cos(theta/2));
    controlY = centerY + Math.sin(angleMid) * (this.getHeight() / Math.cos(theta/2));
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
        } // end of for loop
    this.endPoint = this.getAnchorPoints()[this.getAnchorPoints().length-1];
    } // end of if condition
    }
    

/** 
 * draw
 * Method; draw method of the Arc2D class.
 * @return Nothing.
 */
    Arc2D.prototype.draw = function(){
    var len = this.anchorPoints.length;
    this.startStroke();
    this.startFill();
    this.moveTo(this.getX(), this.getY());
    for (var i = 0; i < len; i++) {
    this.curveTo(this.controlPoints[i].getX(), this.controlPoints[i].getY(), this.anchorPoints[i].getX(), this.anchorPoints[i].getY());
    }
    // close the arc according to the closure type
    if (this.getClosureType() == "PIE") {
    this.lineTo(this.getCenterPoint().getX(), this.getCenterPoint().getY());
    this.lineTo(this.getStartPoint().getX(), this.getStartPoint().getY());
    } else if (this.getClosureType() == "CHORD") {
    this.lineTo(this.getStartPoint().getX(), this.getStartPoint().getY());
    }
    this.finishFill();
    }
// custom toString method
    Arc2D.prototype.toString = function(){
      return "[object Arc2D]";
      }
      
      
      
      
