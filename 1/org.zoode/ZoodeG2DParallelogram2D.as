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
 * new Parallelogram2D
 * Method; creates a new instance of the Parallelogram2D class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function Parallelogram2D(mc){
    super(mc);
    this.x = 0;
    this.y = 0;
    this.sideA = 0;
    this.sideB = 0;
    this.startAngle = 0;
    this.rotationAngle = 0;
    this.vertex1 = null;
    this.vertex2 = null;
    this.vertex3 = null;
    this.vertex4 = null;
    }
    
    Parallelogram2D.extend(Shape);
    

/** 
 * getX
 * Method; returns a number value indicating the x property of the Parallelogram2D instance.
 * @return A number value indicating the x property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y property of the Parallelogram2D instance.
 * @return A number value indicating the y property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * getSideA
 * Method; returns a number value indicating the sideA property of the Parallelogram2D instance.
 * @return A number value indicating the sideA property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getSideA = function(){
    return this.sideA;
    }
    

/** 
 * getSideB
 * Method; returns a number value indicating the sideB property of the Parallelogram2D instance.
 * @return A number value indicating the sideB property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getSideB = function(){
    return this.sideB;
    }
    

/** 
 * getStartAngle
 * Method; returns a number value indicating the startAngle property of the Parallelogram2D instance.
 * @return A number value indicating the startAngle property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getStartAngle = function(){
    return this.startAngle;
    }
    

/** 
 * getRotationAngle
 * Method; returns a number value indicating the rotationAngle property of the Parallelogram2D instance.
 * @return A number value indicating the rotationAngle property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getRotationAngle = function(){
    return this.rotationAngle;
    }
    

/** 
 * getVertex1
 * Method; returns vertex1 (a Point2D instance) of the Parallelogram2D instance.
 * @return Vertex1 (a Point2D instance) of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getVertex1 = function(){
    return this.vertex1;
    }
    

/** 
 * getVertex2
 * Method; returns vertex2 (a Point2D instance) of the Parallelogram2D instance.
 * @return Vertex2 (a Point2D instance) of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getVertex2 = function(){
    return this.vertex2;
    }
    

/** 
 * getVertex3
 * Method; returns vertex3 (a Point2D instance) of the Parallelogram2D instance.
 * @return Vertex3 (a Point2D instance) of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getVertex3 = function(){
    return this.vertex3;
    }
    

/** 
 * getVertex4
 * Method; returns vertex4 (a Point2D instance) of the Parallelogram2D instance.
 * @return Vertex4 (a Point2D instance) property of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getVertex4 = function(){
    return this.vertex4;
    }
    

/** 
 * getCenterPt
 * Method; returns the center point (Point2D instance) of the Parallelogram2D instance.
 * @return Center point (Point2D instance) of the Parallelogram2D instance.
 */
    Parallelogram2D.prototype.getCenterPt = function(){
    return this.centerPt;
    }
    

/** 
 * setPara
 * Method; sets the x, y, sideA, sideB, startAngle and rotationAngle properties of the Parallelogram2D instance.
 * @param x x coordinate of the parallelogram - this refers to the first vertex of the parallelogram 
 * @param y y coordinate of the parallelogram - this refers to the first vertex of the parallelogram 
 * @param sideA the length of the first side of the parallelogram 
 * @param sideB the length of the second side of the parallelogram 
 * @param startAngle the angle (in degrees) between first and second sides of the parallelogram 
 * @param rotationAngle the rotation angle (in degrees) of the parallelogram 
 * @return Nothing.
 */
    Parallelogram2D.prototype.setPara = function(x, y, sideA, sideB, startAngle, rotationAngle){
    this.x = x;
    this.y = y;
    this.sideA = sideA;
    this.sideB = sideB;
    this.startAngle = startAngle;
    this.rotationAngle = rotationAngle;
    this.vertex1 = new Point2D(this.getX(), this.getY());
    this.vertex2 = Math.toPoint2D(this.vertex1, this.sideA, this.startAngle);
    this.vertex3 = Math.toPoint2D(this.vertex2, this.sideB, this.rotationAngle);
    this.vertex4 = Math.toPoint2D(this.vertex1, this.sideB, this.rotationAngle);
    this.centerPt = Math.intersect2Lines(this.getVertex1(), this.getVertex3(), this.getVertex2(), this.getVertex4());
    }
    

/** 
 * draw
 * Method; draw method of the Parallelogram2D class.
 * @return Nothing.
 */
    Parallelogram2D.prototype.draw = function(){
    this.startStroke();
    this.startFill();
    this.moveTo(this.getVertex1().getX(), this.getVertex1().getY());
    this.lineTo(this.getVertex2().getX(), this.getVertex2().getY());
    this.lineTo(this.getVertex3().getX(), this.getVertex3().getY());
    this.lineTo(this.getVertex4().getX(), this.getVertex4().getY());
    this.lineTo(this.getVertex1().getX(), this.getVertex1().getY());
    this.finishFill();
    }
// custom toString method
    Parallelogram2D.prototype.toString = function(){
      return "[object Parallelogram2D]";
      }

