//!-- UTF8

// Code generated with ASBOT (package module v. 0.2.0) 
// http://www.zoode.org/projects/asbot/
// at 23:30 on 22 Mar 2003

/** 
 * Geometries2D
 * @author Ahmet Zorlu
 * @version 1.0.0
 */

//#include "org.zoode/ASLang.as"
//#include "org.zoode/MathUtilsGeometries.as"

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
      

      
