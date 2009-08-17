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
 * new RoundRectangle2D
 * Method; creates a new instance of the RoundRectangle2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function RoundRectangle2D(mc){
    super(mc);
    this.x = 0;
    this.y = 0;
    this.width = 0;
    this.height = 0;
    this.arcWidth = 0;
    this.arcHeight = 0;
    this.centered = false;
    this.centerX = 0;
    this.centerY = 0;
    this.minX = 0;
    this.minY = 0;
    this.maxX = 0;
    this.maxY = 0;
    this.controlPoints = new Array();
    this.anchorPoints = new Array();
    }
    
    RoundRectangle2D.extend(Shape);
    

/** 
 * getX
 * Method; returns a number value indicating the x property of the RoundRectangle2D instance.
 * If it is a centered RoundRectangle2D instance, this will refer to the center point, otherwise it will refer to the upper-left point.
 * If we want to get the coordinates of the upper-left vertex of the RoundRectangle2D instance, we can use getMinX(), getMinY() methods.
 * @return A number value indicating the x property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y property of the RoundRectangle2D instance.
 * If it is a centered RoundRectangle2D instance, this will refer to the center point, otherwise it will refer to the upper-left point.
 * If we want to get the coordinates of the upper-left vertex of the RoundRectangle2D instance, we can use getMinX(), getMinY() methods.
 * @return A number value indicating the y property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * getWidth
 * Method; returns a number value indicating the width property of the RoundRectangle2D instance.
 * @return A number value indicating the width property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getWidth = function(){
    return this.width;
    }
    

/** 
 * getHeight
 * Method; returns a number value indicating the height property of the RoundRectangle2D instance.
 * @return A number value indicating the height property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getHeight = function(){
    return this.height;
    }
    

/** 
 * getArcWidth
 * Method; returns a number value indicating the arcWidth property of the RoundRectangle2D instance.
 * @return A number value indicating the arcWidth property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getArcWidth = function(){
    return this.arcWidth;
    }
    

/** 
 * getArcHeight
 * Method; returns a number value indicating the arcHeight property of the RoundRectangle2D instance.
 * @return A number value indicating the arcHeight property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getArcHeight = function(){
    return this.arcHeight;
    }
    

/** 
 * getCenterX
 * Method; returns a number value indicating the centerX property of the RoundRectangle2D instance.
 * @return A number value indicating the centerX property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getCenterX = function(){
    return this.centerX;
    }
    

/** 
 * getCenterY
 * Method; returns a number value indicating the centerY property of the RoundRectangle2D instance.
 * @return A number value indicating the centerY property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getCenterY = function(){
    return this.centerY;
    }
    

/** 
 * getMinX
 * Method; returns a number value indicating the minX property of the RoundRectangle2D instance.
 * This value refers to the coordinates of the upper-left vertex of a virtual rectangle that bounds the RoundRectangle2D instance.
 * @return A number value indicating the minX property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getMinX = function(){
    return this.minX;
    }
    

/** 
 * getMinY
 * Method; returns a number value indicating the minY property of the RoundRectangle2D instance.
 * This value refers to the coordinates of the upper-left vertex of a virtual rectangle that bounds the RoundRectangle2D instance.
 * @return A number value indicating the minY property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getMinY = function(){
    return this.minY;
    }
    

/** 
 * getMaxX
 * Method; returns a number value indicating the maxX property of the RoundRectangle2D instance.
 * This value refers to the coordinates of the lower-right vertex of a virtual rectangle that bounds the RoundRectangle2D instance.
 * @return A number value indicating the maxX property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getMaxX = function(){
    return this.maxX;
    }
    

/** 
 * getMaxY
 * Method; returns a number value indicating the maxY property of the RoundRectangle2D instance.
 * @return A number value indicating the maxY property of the RoundRectangle2D instance.
 * @return This value refers to the coordinates of the lower-right vertex of a virtual rectangle that bounds the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getMaxY = function(){
    return this.maxY;
    }
    

/** 
 * getControlPoints
 * Method; returns an array containing the control points (Point2D instances) which are used to calculate the corners of the RoundRectangle2D instance.
 * The order is clock-wise and the first element refers to the upper-right corner.
 * @return An array containing the control points of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getControlPoints = function(){
    return this.controlPoints;
    }
    

/** 
 * getAnchorPoints
 * Method; returns an array containing the anchor points (Point2D instances) which are used to calculate the corners of the RoundRectangle2D instance.
 * The order is clock-wise and the first element refers to the upper-right corner.
 * This array contains 8 elements and elements 0, 2, 4 and 6 refer to the upper-right, lower-right, lower-left and upper-left corners (respectively) on the RoundRectangle2D instance.
 * @return An array containing the anchor points of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.getAnchorPoints = function(){
    return this.anchorPoints;
    }
    

/** 
 * isCentered
 * Method; returns a boolean value, indicating the status of the centered property of the RoundRectangle2D instance.
 * @return A boolean value, indicating the status of the centered property of the RoundRectangle2D instance.
 */
    RoundRectangle2D.prototype.isCentered = function(){
    return this.centered;
    }
    

/** 
 * setRoundRect
 * Method; sets the x, y, width, height, arcWidth, arcHeight and centered properties of the RoundRectangle2D instance.
 * @param x x coordinate of the round rectangle 
 * @param y y coordinate of the round rectangle 
 * @param width width of the round rectangle 
 * @param height height of the round rectangle 
 * @param arcWidth width of the arc that rounds off the corners 
 * @param arcHeight height of the arc that rounds off the corners 
 * @param centered a boolean value defining if the round rectangle is centered or not 
 * @return Nothing.
 */
    RoundRectangle2D.prototype.setRoundRect = function(x, y, width, height, arcWidth, arcHeight, centered){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.arcWidth = arcWidth;
    this.arcHeight = arcHeight;
    this.centered = centered;
    // optional last parameter (a boolean value) indicates
    //  if the registration point is at top-left (0) or is centered (1)
    this.centerX = this.isCentered() ? this.x : this.x + this.width/2;
    this.centerY = this.isCentered() ? this.y : this.y + this.height/2;
    this.minX = this.isCentered() ? this.x - this.width/2 : this.x; 
    this.maxX = this.isCentered() ? this.x + this.width/2 : this.x + this.width; 
    this.minY = this.isCentered() ? this.y - this.height/2 : this.y; 
    this.maxY = this.isCentered() ? this.y + this.height/2 : this.y + this.height; 
    // the long and windy road...
    // init vars
    var theta, currentAngle, controlX, controlY, anchorX, anchorY;
    // error check: w + h should be larger than arcWidth + arcHeight
    if (this.getArcWidth() + this.getArcHeight() > Math.min(this.getWidth(), this.getHeight()) / 2) this.arcWidth = this.arcHeight = Math.min(this.getWidth(), this.getHeight()) / 2;
    // theta = 45 degrees in radians
    theta = Math.PI / 4;
    // currentAngle is currently 90 degrees
    currentAngle =  -Math.PI / 2;
    
    controlX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight());
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() + this.getWidth() - this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() + this.getHeight() - this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    
    anchorY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    currentAngle  += theta;
    controlX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +(theta/2))* this.getArcWidth() /Math.cos(theta/2));
    controlY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +(theta/2))* this.getArcHeight() /Math.cos(theta/2));
    anchorX = this.getMinX() +  this.getArcWidth() +(Math.cos(currentAngle +theta)* this.getArcWidth() );
    anchorY = this.getMinY() +  this.getArcHeight() +(Math.sin(currentAngle +theta)* this.getArcHeight() );
    this.controlPoints.push(new Point2D(controlX, controlY));
    this.anchorPoints.push(new Point2D(anchorX, anchorY));
    
    }
    

/** 
 * draw
 * Method; draw method of the RoundRectangle2D class.
 * @return Nothing.
 */
    RoundRectangle2D.prototype.draw = function(){
    this.startStroke();
    this.startFill();
    //draw top edge
    this.moveTo(this.getMinX() + this.getArcWidth(), this.getMinY());
    this.lineTo(this.getMinX() + this.getWidth() - this.getArcWidth(), this.getMinY());
    // draw top right corner in two parts
    this.curveTo(this.controlPoints[0].getX(), this.controlPoints[0].getY(), this.anchorPoints[0].getX(), this.anchorPoints[0].getY());
    this.curveTo(this.controlPoints[1].getX(), this.controlPoints[1].getY(), this.anchorPoints[1].getX(), this.anchorPoints[1].getY());
    // draw right edge
    this.lineTo(this.getMinX() + this.getWidth() , this.getMinY() + this.getHeight() - this.getArcHeight());
    // draw bottom right corner
    this.curveTo(this.controlPoints[2].getX(), this.controlPoints[2].getY(), this.anchorPoints[2].getX(), this.anchorPoints[2].getY());
    this.curveTo(this.controlPoints[3].getX(), this.controlPoints[3].getY(), this.anchorPoints[3].getX(), this.anchorPoints[3].getY());
    // draw bottom edge
    this.lineTo(this.getMinX() +  this.getArcWidth() , this.getMinY() + this.getHeight());
    // draw bottom left corner
    this.curveTo(this.controlPoints[4].getX(), this.controlPoints[4].getY(), this.anchorPoints[4].getX(), this.anchorPoints[4].getY());
    this.curveTo(this.controlPoints[5].getX(), this.controlPoints[5].getY(), this.anchorPoints[5].getX(), this.anchorPoints[5].getY());
    // draw left edge
    this.lineTo(this.getMinX(), this.getMinY() + this.getArcHeight());
    // draw top left corner
    this.curveTo(this.controlPoints[6].getX(), this.controlPoints[6].getY(), this.anchorPoints[6].getX(), this.anchorPoints[6].getY());
    this.curveTo(this.controlPoints[7].getX(), this.controlPoints[7].getY(), this.anchorPoints[7].getX(), this.anchorPoints[7].getY());
    this.finishFill();
    }
// custom toString method
    RoundRectangle2D.prototype.toString = function(){
      return "[object RoundRectangle2D]";
      }
      
      
      
      
