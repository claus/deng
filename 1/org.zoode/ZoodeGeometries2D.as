//!-- UTF8

// Code generated with ASBOT (package module v. 0.2.0) 
// http://www.zoode.org/projects/asbot/
// at 23:30 on 22 Mar 2003

/** 
 * Geometries2D
 * @author Ahmet Zorlu
 * @version 1.0.0
 */

#include "org.zoode/ASLang.as"

#include "org.zoode/MathUtilsGeometries.as"

 // Note: *extend* method is used for __proto__ based inheritance
 // reference: http://www.quantumwave.com/flash/inheritance.html 

/** 
 * new Shape
 * Method; creates a new instance of the Shape class.
 * Note that this constructor shouldn't be invoked unless you are extending the Shape superclass.
 * The classes that extend the Shape superclass inherits the methods and properties of this class.
 * The coordinates are relative to the movieclip with which we are drawing.
 * @return Nothing.
 */
    _global.Shape = function(mc){
    this.mc = mc;
    this.lineThickness = 0;
    this.lineRGB = 0;
    this.lineAlpha = 100;
    this.fillRGB = 0;
    this.fillAlpha = 100;
    this.filled = false;
    this.gradientType = "linear";
    this.gradientColorsArray = new Array();
    this.gradientAlphasArray = new Array();
    this.gradientRatiosArray = new Array();
    this.gradientMatrixObject = new Array();
    this.gradientFilled = false;
    this.penX = 0;
    this.penY = 0;
    this.penStartX = 0;
    this.penStartY = 0;
    }
    

/** 
 * getTarget
 * Method; returns a movieclip value indicating the mc property of the Shape instance.
 * @return A reference to the target movieclip that we are drawing with.
 */
    Shape.prototype.getTarget = function(){
    return this.mc;
    }
    

/** 
 * getLineThickness
 * Method; returns a number value indicating the lineThickness property of the Shape instance.
 * @return A number value indicating the lineThickness property of the Shape instance.
 */
    Shape.prototype.getLineThickness = function(){
    return this.lineThickness;
    }
    

/** 
 * getLineRGB
 * Method; returns a number value indicating the lineRGB property of the Shape instance.
 * @return A number value indicating the lineRGB property of the Shape instance.
 */
    Shape.prototype.getLineRGB = function(){
    return this.lineRGB;
    }
    

/** 
 * getLineAlpha
 * Method; returns a number value indicating the lineAlpha property of the Shape instance.
 * @return A number value indicating the lineAlpha property of the Shape instance.
 */
    Shape.prototype.getLineAlpha = function(){
    return this.lineAlpha;
    }
    

/** 
 * getFillRGB
 * Method; returns a number value indicating the fillRGB property of the Shape instance.
 * @return A number value indicating the fillRGB property of the Shape instance.
 */
    Shape.prototype.getFillRGB = function(){
    return this.fillRGB;
    }
    

/** 
 * getFillAlpha
 * Method; returns a number value indicating the fillAlpha property of the Shape instance.
 * @return A number value indicating the fillAlpha property of the Shape instance.
 */
    Shape.prototype.getFillAlpha = function(){
    return this.fillAlpha;
    }
    

/** 
 * getGradientType
 * Method; returns a string value indicating the gradientType property of the Shape instance.
 * @return A string value indicating the gradientType property of the Shape instance.
 */
    Shape.prototype.getGradientType = function(){
    return this.gradientType;
    }
    

/** 
 * getGradientColorsArray
 * Method; returns a object value indicating the gradientColorsArray property of the Shape instance.
 * @return A object value indicating the gradientColorsArray property of the Shape instance.
 */
    Shape.prototype.getGradientColorsArray = function(){
    return this.gradientColorsArray;
    }
    

/** 
 * getGradientAlphasArray
 * Method; returns a object value indicating the gradientAlphasArray property of the Shape instance.
 * @return A object value indicating the gradientAlphasArray property of the Shape instance.
 */
    Shape.prototype.getGradientAlphasArray = function(){
    return this.gradientAlphasArray;
    }
    

/** 
 * getGradientRatiosArray
 * Method; returns a object value indicating the gradientRatiosArray property of the Shape instance.
 * @return A object value indicating the gradientRatiosArray property of the Shape instance.
 */
    Shape.prototype.getGradientRatiosArray = function(){
    return this.gradientRatiosArray;
    }
    

/** 
 * getGradientMatrixObject
 * Method; returns a object value indicating the gradientMatrixObject property of the Shape instance.
 * @return A object value indicating the gradientMatrixObject property of the Shape instance.
 */
    Shape.prototype.getGradientMatrixObject = function(){
    return this.gradientMatrixObject;
    }
    

/** 
 * getPenX
 * Method; returns a number value indicating the penX property of the Shape instance.
 * @return A number value indicating the penX property of the Shape instance.
 */
    Shape.prototype.getPenX = function(){
    return this.penX;
    }
    

/** 
 * getPenY
 * Method; returns a number value indicating the penY property of the Shape instance.
 * @return A number value indicating the penY property of the Shape instance.
 */
    Shape.prototype.getPenY = function(){
    return this.penY;
    }
    

/** 
 * getPenStartX
 * Method; returns a number value indicating the penStartX property of the Shape instance.
 * @return A number value indicating the penStartX property of the Shape instance.
 */
    Shape.prototype.getPenStartX = function(){
    return this.penStartX;
    }
    

/** 
 * getPenStartY
 * Method; returns a number value indicating the penStartY property of the Shape instance.
 * @return A number value indicating the penStartY property of the Shape instance.
 */
    Shape.prototype.getPenStartY = function(){
    return this.penStartY;
    }
    

/** 
 * isFilled
 * Method; returns a boolean value, indicating the status of the filled property of the Shape instance.
 * @return A boolean value, indicating the status of the filled property of the Shape instance.
 */
    Shape.prototype.isFilled = function(){
    return this.filled;
    }
    

/** 
 * isGradientFilled
 * Method; returns a boolean value, indicating the status of the gradientFilled property of the Shape instance.
 * @return A boolean value, indicating the status of the gradientFilled property of the Shape instance.
 */
    Shape.prototype.isGradientFilled = function(){
    return this.gradientFilled;
    }
    

/** 
 * setStroke
 * Method; initializes the lineThickness, lineRGB and lineAlpha properties of the Shape instance to initial values.
 * @param lineThickness the thickness of the line in pixels; valid values are 0 to 255 
 * @param lineRGB a  hexadecimal color value - such as 0x00ff00 
 * @param lineAlpha alpha value of the line's color; valid values are 0-100 
 * @return Nothing.
 */
    Shape.prototype.setStroke = function(lineThickness, lineRGB, lineAlpha){
    this.lineThickness = lineThickness;
    this.lineRGB = lineRGB;
    this.lineAlpha = lineAlpha;
    }
    

/** 
 * setFillColor
 * Method; sets the fillRGB and fillAlpha properties of the Shape instance.
 * @param fillRGB a  hexadecimal color value - such as 0x00ff00 
 * @param fillAlpha alpha value of the fill color; valid values are 0-100 
 * @return Nothing.
 */
    Shape.prototype.setFillColor = function(fillRGB, fillAlpha){
    this.fillRGB = fillRGB;
    this.fillAlpha = fillAlpha;
    this.filled = true;
    }
    

/** 
 * setFillGradient
 * Method; sets the gradientType, gradientColorsArray, gradientAlphasArray, gradientRatiosArray and gradientMatrixObject properties of the Shape instance.
 * @param gradientType  
 * @param gradientColorsArray  
 * @param gradientAlphasArray  
 * @param gradientRatiosArray  
 * @param gradientMatrixObject  
 * @return Nothing.
 */
    Shape.prototype.setFillGradient = function(gradientType, gradientColorsArray, gradientAlphasArray, gradientRatiosArray, gradientMatrixObject){
    this.gradientType = gradientType;
    this.gradientColorsArray = gradientColorsArray;
    this.gradientAlphasArray = gradientAlphasArray;
    this.gradientRatiosArray = gradientRatiosArray;
    this.gradientMatrixObject = gradientMatrixObject;
    this.gradientFilled = true;
    }
    

/** 
 * reset
 * Method; reset method of the Shape class.
 * @return Nothing.
 */
    Shape.prototype.reset = function(){
    this.mc.clear();
    this.lineThickness = 0;
    this.lineRGB = 0;
    this.lineAlpha = 100;
    this.fillRGB = 0;
    this.fillAlpha = 100;
    this.filled = false;
    this.gradientType = "linear";
    this.gradientColorsArray = new Array();
    this.gradientAlphasArray = new Array();
    this.gradientRatiosArray = new Array();
    this.gradientMatrixObject = new Array();
    this.gradientFilled = false;
    this.penX = 0;
    this.penY = 0;
    this.penStartX = 0;
    this.penStartY = 0;
    }

/** 
 * startStroke
 */
    Shape.prototype.startStroke = function(){
    // private method: start (define) line stroke
    this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
    }

/** 
 * startFill
 */
    Shape.prototype.startFill = function(){
    // private method: start color or gradient fill
    if (this.isFilled()) this.mc.beginFill(this.fillRGB, this.fillAlpha);
    if (this.isGradientFilled()) this.mc.beginGradientFill(this.gradientType, this.gradientColorsArray, this.gradientAlphasArray, this.gradientRatiosArray, this.gradientMatrixObject);
    }

/** 
 * finishFill
 */
    Shape.prototype.finishFill = function(){
    // private method: finish color or gradient fill
    if (this.isFilled() || this.isGradientFilled()) this.mc.endFill();
    }

/** 
 * moveTo
 */
    Shape.prototype.moveTo = function(x, y){
    this.penStartX = x;
    this.penStartY = y;
    // private method: moves the current pen to the start of a subpath
    this.mc.moveTo(this.penStartX, this.penStartY);
    }
    

/** 
 * lineTo
 */
    Shape.prototype.lineTo = function(x, y){
    this.penX = x;
    this.penY = y;
    // private method: moves the current pen to the end of a subpath and draws a line
    this.mc.lineTo(this.penX, this.penY);
    }
    

/** 
 * curveTo
 */
    Shape.prototype.curveTo = function(cx, cy, ax, ay){
    this.penX = ax;
    this.penY = ay;
    // private method: moves the current pen to the end of a subpath and draws a quadratic curve
    this.mc.curveTo(cx, cy, this.penX, this.penY);
    }
    
// custom toString method
    Shape.prototype.toString = function(){
      return "[object Shape]";
      }
      
      

/** 
 * new Point2D
 * Method; creates a new instance of the Point2D class.
 * @param x  
 * @param y  
 * @return Nothing.
 */
    _global.Point2D = function(x, y){
    this.x = x == undefined ? 0 : x;
    this.y = y == undefined ? 0 : y;
    }
    

/** 
 * getX
 * Method; returns a number value indicating the x property of the Point2D instance.
 * @return A number value indicating the x property of the Point2D instance.
 */
    Point2D.prototype.getX = function(){
    return this.x;
    }
    

/** 
 * getY
 * Method; returns a number value indicating the y property of the Point2D instance.
 * @return A number value indicating the y property of the Point2D instance.
 */
    Point2D.prototype.getY = function(){
    return this.y;
    }
    

/** 
 * setLocation
 * Method; sets the x and y properties of the Point2D instance.
 * @param x x coordinate of Point2D - swf coordinate system uses the same x values as in Cartesian coordinate system 
 * @param y y coordinate of Point2D - swf coordinate system uses y values that are opposite to the values in Cartesian coordinate system 
 * @return Nothing.
 */
    Point2D.prototype.setLocation = function(x, y){
    this.x = x;
    this.y = y;
    }
    
// custom toString method
    Point2D.prototype.toString = function(){
      return "[object Point2D]";
      }
      
      

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
      
      
// interim patch : 05.18.2003

/** 
 * new GeneralPath
 * Method; creates a new instance of the GeneralPath class.
 * @param mc The target movieclip with which we are drawing. 
 * @return Nothing.
 */

    function GeneralPath(mc){
    super(mc);
    this.subPaths = new Array();
    }
    
    GeneralPath.extend(Shape);
    

/** 
 * getSubPaths
 * Method; returns an array containing the individual subPaths of the GeneralPath instance.
 * Each element of the array is a custom object with defined fields.
 * The main field is "command" and it can have these values: "m" (move), "l" (addLine), "q" (addQuad), "c" (addCubic), "close" (closePath).
 * The object with the command field "m" (move) has two more fields: arg1:x, arg2:y.
 * The object with the command field "l" (addLine) has two more fields: arg1:x, arg2:y.
 * The object with the command field "q" (addQuad) has four more fields: arg1:ctrlX, arg2:ctrlY, arg3:x, arg4:y.
 * The object with the command field "c" (addCubic) has six more fields: arg1:ctrlX1, arg2:ctrlY1, arg3:ctrlX2, arg4:ctrlY2, arg5:x, arg6:y.
 * The object with the command field "close" (closePath) doesn't have any more fields.
 * @return A object value indicating the subPaths property of the GeneralPath instance.
 */
    GeneralPath.prototype.getSubPaths = function(){
    return this.subPaths;
    }
    

/** 
 * move
 * Method; adds a point to the path by moving to the specified coordinates.
 * @param x the new x coordinate where the drawing pen will be moved 
 * @param y the new y coordinate where the drawing pen will be moved 
 * @return Nothing.
 */
    GeneralPath.prototype.move = function(x, y){
    this.subPaths.push({command:"m", arg1:x, arg2:y});
    // v1.0.2 :: penStart and pen are at the same location
    this.penStartX = this.penX = x;
    this.penStartY = this.penY = y;
    }
    

/** 
 * addLine
 * Method; adds a straight line segment to the path by drawing a straight line from the current coordinates to the new specified coordinates.
 * @param x x coordinate of the end point of the line 
 * @param y y coordinate of the end point of the line 
 * @return Nothing.
 */
    GeneralPath.prototype.addLine = function(x, y){
    this.subPaths.push({command:"l", arg1:x, arg2:y});
    this.penX = x;
    this.penY = y;
    }
    

/** 
 * addQuad
 * Method; adds a curved segment to the path by drawing a quadratic curve that intersects both the current coordinates and the coordinates (x, y), using the specified point (ctrlX, ctrlY) as a quadratic parametric control point.
 * @param ctrlX x coordinate of the quadratic parametric control point 
 * @param ctrlY y coordinate of the quadratic parametric control point 
 * @param x x coordinate of the last anchor point of the quadratic parametric 
 * @param y y coordinate of the last anchor point of the quadratic parametric 
 * @return Nothing.
 */
    GeneralPath.prototype.addQuad = function(ctrlX, ctrlY, x, y){
    this.subPaths.push({command:"q", arg1:ctrlX, arg2:ctrlY, arg3:x, arg4:y});
    this.penX = x;
    this.penY = y;
    }
    

/** 
 * addCubic
 * Method; adds a curved segment to the path by drawing a cubic curve that intersects both the current coordinates and the coordinates (x, y), using the specified points (ctrlX1, ctrlY1) and (ctrlX2, ctrlY2) as cubic control points.
 * @param ctrlX1 x coordinate of the first cubic parametric control point 
 * @param ctrlY1 y coordinate of the first cubic parametric control point 
 * @param ctrlX x coordinate of the second cubic parametric control point 
 * @param ctrlY y coordinate of the second cubic parametric control point 
 * @param x x coordinate of the last anchor point of the quadratic parametric 
 * @param y y coordinate of the last anchor point of the quadratic parametric 
 * @return Nothing.
 */
    GeneralPath.prototype.addCubic = function(ctrlX1, ctrlY1, ctrlX2, ctrlY2, x, y){
    this.subPaths.push({command:"c", arg1:ctrlX1, arg2:ctrlY1, arg3:ctrlX2, arg4:ctrlY2, arg5:x, arg6:y});
    this.penX = x;
    this.penY = y;
    }

/** 
 * closePath
 * Method; closes the current subpath by drawing a straight line back to the coordinates of the last move command.
 * @return Nothing.
 */
    GeneralPath.prototype.closePath = function(){
    // closes the current subpath by drawing a straight line back to the coordinates of the last moveTo
    this.subPaths.push( { command:"close"} );
    this.penX = this.penStartX;
    this.penY = this.penStartY;
    }

/** 
 * draw
 * Method; draw method of the GeneralPath class.
 * @return Nothing.
 */
GeneralPath.prototype.draw = function()
{
	with(this) {
		startStroke();
		startFill();
		var len = subPaths.length;
		for (var i = 0; i < len; i++) {
			var _sp = subPaths[i];
			switch(_sp.command) {
				case "m":
					moveTo(_sp.arg1, _sp.arg2);
					break;
				case "l":
					lineTo(_sp.arg1, _sp.arg2);
					break;
				case "q":
					curveTo(_sp.arg1, _sp.arg2, _sp.arg3, _sp.arg4);
					break;
				case "c":
					// v1.0.2 :: 
					// BUG FIX:: if the last command is a *move* command 
					// the first point2D is the pen start location
					// else it is the pen location
					// Math.solveCubic parameters order is pt1, pt2, ctrlPt1, ctrlPt2
					var startPt = new Point2D();
					if(subPaths[i-1].command == "m" || subPaths[i-1].command == undefined) {
						startPt.setLocation(penStartX, penStartY);
					} else {
						startPt.setLocation(penX, penY);
					}	   
					var s = Math.solveCubic(startPt, new Point2D(_sp.arg5, _sp.arg6), new Point2D(_sp.arg1, _sp.arg2), new Point2D(_sp.arg3, _sp.arg4));
					curveTo(s.cp1.x, s.cp1.y, s.ap1.x, s.ap1.y);
					curveTo(s.cp2.x, s.cp2.y, s.ap2.x, s.ap2.y);
					curveTo(s.cp3.x, s.cp3.y, s.ap3.x, s.ap3.y);
					curveTo(s.cp4.x, s.cp4.y, _sp.arg5, _sp.arg6);
					break;
				case "close":
					lineTo(penStartX, penStartY);
					break;
			}
		}
		finishFill();
	}
}


// custom toString method
    GeneralPath.prototype.toString = function(){
      return "[object GeneralPath]";
      }
      
      
      
