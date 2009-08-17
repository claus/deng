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
 * new Rectangle2D
 * Method; creates a new instance of the Rectangle2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function Rectangle2D(mc){
    super(mc);
    this.x = 0;
    this.y = 0;
    this.width = 0;
    this.height = 0;
    this.centered = false;
    this.centerX = 0;
    this.centerY = 0;
    this.minX = 0;
    this.minY = 0;
    this.maxX = 0;
    this.maxY = 0;
    }
    
    Rectangle2D.extend(Shape);
    

/** 
 * getX
 * Method; returns a number value indicating the x property of the Rectangle2D instance.
 * If it is a centered Rectangle2D instance, this will refer to the center point, otherwise it will refer to the upper-left point.
 * If we want to get the coordinates of the upper-left vertex of the Rectangle2D instance, we can use getMinX(), getMinY() methods.
 * @return A number value indicating the x coordinate of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y property of the Rectangle2D instance.
 * If it is a centered Rectangle2D instance, this will refer to the center point, otherwise it will refer to the upper-left point.
 * If we want to get the coordinates of the upper-left vertex of the Rectangle2D instance, we can use getMinX(), getMinY() methods.
 * @return A number value indicating the y property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * getWidth
 * Method; returns a number value indicating the width property of the Rectangle2D instance.
 * @return A number value indicating the width property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getWidth = function(){
    return this.width;
    }
    

/** 
 * getHeight
 * Method; returns a number value indicating the height property of the Rectangle2D instance.
 * @return A number value indicating the height property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getHeight = function(){
    return this.height;
    }
    

/** 
 * getCenterX
 * Method; returns a number value indicating the centerX property of the Rectangle2D instance.
 * @return A number value indicating the centerX property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getCenterX = function(){
    return this.centerX;
    }
    

/** 
 * getCenterY
 * Method; returns a number value indicating the centerY property of the Rectangle2D instance.
 * @return A number value indicating the centerY property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getCenterY = function(){
    return this.centerY;
    }
    

/** 
 * getMinX
 * Method; returns a number value indicating the minX property of the Rectangle2D instance.
 * This value refers to the coordinates of the upper-left vertex of the Rectangle2D instance.
 * @return A number value indicating the minX property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getMinX = function(){
    return this.minX;
    }
    

/** 
 * getMinY
 * Method; returns a number value indicating the minY property of the Rectangle2D instance.
 * This value refers to the coordinates of the upper-left vertex of the Rectangle2D instance.
 * @return A number value indicating the minY property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getMinY = function(){
    return this.minY;
    }
    

/** 
 * getMaxX
 * Method; returns a number value indicating the maxX property of the Rectangle2D instance.
 * This value refers to the coordinates of the lower-right vertex of the Rectangle2D instance.
 * @return A number value indicating the maxX property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getMaxX = function(){
    return this.maxX;
    }
    

/** 
 * getMaxY
 * Method; returns a number value indicating the maxY property of the Rectangle2D instance.
 * This value refers to the coordinates of the lower-right vertex of the Rectangle2D instance.
 * @return A number value indicating the maxY property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.getMaxY = function(){
    return this.maxY;
    }
    

/** 
 * isCentered
 * Method; returns a boolean value, indicating the status of the centered property of the Rectangle2D instance.
 * @return A boolean value, indicating the status of the centered property of the Rectangle2D instance.
 */
    Rectangle2D.prototype.isCentered = function(){
    return this.centered;
    }
    

/** 
 * setRect
 * Method; sets the x, y, width, height and centered properties of the Rectangle2D instance.
 * @param x x coordinate of the rectangle 
 * @param y y coordinate of the rectangle 
 * @param width width of the rectangle 
 * @param height height of the rectangle 
 * @param centered a boolean value defining if the rectangle is centered or not 
 * @return Nothing.
 */
    Rectangle2D.prototype.setRect = function(x, y, width, height, centered){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.centered = centered;
    // optional last parameter (a boolean value) indicates
    //  if the registration point is at top-left (0) or is centered (1)
    this.centerX = this.isCentered() ? this.getX() : this.getX() + this.getWidth()/2;
    this.centerY = this.isCentered() ? this.getY() : this.getY() + this.getHeight()/2;
    this.minX = this.isCentered() ? this.getX() - this.getWidth()/2 : this.getX(); 
    this.maxX = this.isCentered() ? this.getX() + this.getWidth()/2 : this.getX() + this.getWidth(); 
    this.minY = this.isCentered() ? this.getY() - this.getHeight()/2 : this.getY(); 
    this.maxY = this.isCentered() ? this.getY() + this.getHeight()/2 : this.getY() + this.getHeight(); 
    }
    

/** 
 * draw
 * Method; draw method of the Rectangle2D class.
 * @return Nothing.
 */
    Rectangle2D.prototype.draw = function(){
    this.startStroke();
    this.startFill();
    this.moveTo(this.getMinX(), this.getMinY());
    this.lineTo(this.getMaxX(), this.getMinY());
    this.lineTo(this.getMaxX(), this.getMaxY());
    this.lineTo(this.getMinX(), this.getMaxY());
    this.lineTo(this.getMinX(), this.getMinY());
    this.finishFill();
    }
// custom toString method
    Rectangle2D.prototype.toString = function(){
      return "[object Rectangle2D]";
      }
      
      
      
