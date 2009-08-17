	// Math Utilities - Geometries
	// v.0.3.0
		
	Math.toRadians = function (theta) { 
	return theta * (Math.PI / 180); 
	} 

	Math.toDegrees = function (theta) { 
	return theta * (180 / Math.PI); 
	} 

	// Returns the distance from one Point2D instance to a specified Point2D instance
	Math.getDistance2D = function(pt1, pt2){
	return Math.sqrt(Math.pow((pt1.x - pt2.x), 2) + Math.pow((pt1.y - pt2.y), 2));
	}
	
	// Returns the angle of rotation between Point2D instances in degrees
	Math.getAngle2D = function(pt1, pt2){
	return Math.toDegrees(Math.atan2(pt1.y - pt2.y, pt1.x - pt2.x));
	}

	// Calculates x and y coordinates of the point at the middle 
	// of the segment between Point2D's
	// returns a Point2D object object with two properties x and y
	// The point on a line segment dividing it into two segments of equal length. 
	Math.plotMiddlePoint = function(pt1, pt2){
	return new Point2D((pt1.x + pt2.x)/2, (pt1.y + pt2.y)/2);
	}

	//  Calculates x and y coordinates of the point at a ratio 
	// of the segment between Point2D's
	// returns a Point2D object with two properties x and y
	Math.plotPointOnSegment = function(pt1, pt2, ratio){
	return new Point2D(pt1.x + ((pt2.x - pt1.x) * ratio), pt1.y + ((pt2.y - pt1.y) * ratio));
	}
	
	// Adds a Vector2D to a Point2D and returns the plotted Point2D 
	// A Vector2D is defined by a length and an angle (in degrees)
	Math.toPoint2D = function (pt, length, angle) {
	return new Point2D(pt.x + (length * Math.cos(Math.toRadians(angle))), pt.y + (length * Math.sin(Math.toRadians(angle))));
	}

    	Math.solveCubic = function(pt1, pt2, ctrlPt1, ctrlPt2){
    	// author: Timothee Groleau
    	// This function will give a cubic approximation of the cubic Bezier curve
   	 // It will calculate a series of control point/anchor point which
    	// will be used to draw quadratic Bezier starting from origin point
    	// and will find control and anchor Points for cubic Bezier curve
    	// This function uses midPoint algorithm
    	// Reference: Bezier_lib.as - v1.2 - 19/05/02
    	// http://www.timotheegroleau.com/Flash/articles/cubic_bezier/cubic_bezier_in_flash.htm
    	// this method expects four parameters (as Point2D instances): start and end points of the curve & 2 control points 
    	// and returns and object with seven fields - matching seven Point2D instances 
    	// (4 control and 3 anchor points) with this order: pc_1, pc_2, pc_3, pc_4, pa_1, pa_2, pa_3
    	var pa = Math.plotPointOnSegment(pt1, ctrlPt1, 3/4);
    	var pb = Math.plotPointOnSegment(pt2, ctrlPt2, 3/4);
    	// get 1/16 of the pt2, pt1 segment
    	var dx = (pt2.x - pt1.x)/16;
    	var dy = (pt2.y - pt1.y)/16;
    	// calculate and return 4 control and 3 anchor points
    	var pc_1 = Math.plotPointOnSegment(pt1, ctrlPt1, 3/8);
    	var pc_2 = Math.plotPointOnSegment(pa, pb, 3/8);
    	pc_2.setLocation(pc_2.x - dx, pc_2.y - dy);
    	var pc_3 = Math.plotPointOnSegment(pb, pa, 3/8);
    	pc_3.setLocation(pc_3.x + dx, pc_3.y + dy);
    	var pc_4 = Math.plotPointOnSegment(pt2, ctrlPt2, 3/8);
    	var pa_1 = Math.plotMiddlePoint(pc_1, pc_2);
    	var pa_2 = Math.plotMiddlePoint(pa, pb);
    	var pa_3 = Math.plotMiddlePoint(pc_3, pc_4);
    	return ({cp1: pc_1, cp2: pc_2, cp3: pc_3, cp4: pc_4, ap1: pa_1, ap2: pa_2, ap3: pa_3});
    	}

	// author: Robert Penner 
	// modified to work with 2 Line2D instances also
	// accepts 4 (4 points) or 2 (2 line 2D) arguments 
	Math.intersect2Lines = function (args) {
	var x11, x12, x21, x22, y11, y12, y21, y22; 
	if (arguments.length == 2) {
	x11 = arguments[0].getX1();
	x12 = arguments[0].getX2();
	x21 = arguments[1].getX1();
	x22 = arguments[1].getX2();
	y11 = arguments[0].getY1();
	y12 = arguments[0].getY2();
	y21 = arguments[1].getY1();
	y22 = arguments[1].getY2();
	} else {
	x11 = arguments[0].x;
	x12 = arguments[1].x;
	x21 = arguments[2].x;
	x22 = arguments[3].x;
	y11 = arguments[0].y;
	y12 = arguments[1].y;
	y21 = arguments[2].y;
	y22 = arguments[3].y;
	}
	var dx1 = x12 - x11;
	var dx2 = x21 - x22;
		if (!(dx1 || dx2))  return NaN;
	var m1 = (y12 - y11) / dx1;
	var m2 = (y21 - y22) / dx2;
		if (!dx1) { // infinity
		return new Point2D(x11, m2 * (x11 - x22) + y22);
		} else if (!dx2) { // infinity
		return new Point2D(x22, m1 * (x22 - x11) + y11);
		}
	//var xInt = (-m2 * x22 + y22 + m1 * x11 - y11) / (m1 - m2);
	//var yInt = m1 * (xInt - x11) + y11;
	return new Point2D((-m2 * x22 + y22 + m1 * x11 - y11) / (m1 - m2), m1 * (xInt - x11) + y11);
	}
	
	// line interpolation
	// (A. Zorlu)
	//x = (1 - t) x1 + tx2, 
	//y = (1 - t) y1 + ty2, 0 # t #1
	Math.plotPointOnLine = function (p1, p2, t) {
    	return new Point2D((1-t)*p1.x + t*p2.x, (1-t)*p1.y + t*p2.y);
	}

	Math.plotPointsOnLine = function (p1, p2, n) {
    	var pts = new Array();
    		for (var i=0; i < n; i++) {
        		pts.push(Math.plotPointOnLine(p1, p2, i/n));
    		} 
    	return pts;
	}
	
	// returns a point2D instance on a quad curve 
	// defined by start point, control point, and end point and a time coefficient
	// author: Robert Penner
	Math.plotPointOnQuadCurve = function (sp, cp, ep, t) {
    	return new Point2D(sp.x + t*(2*(1-t)*(cp.x-sp.x) + t*(ep.x - sp.x)), sp.y + t*(2*(1-t)*(cp.y-sp.y) + t*(ep.y - sp.y)));
	}

	// returns point2D instances at n intervals (t=1/n, 2/n, etc) along a quad curve
	Math.plotPointsOnQuadCurve = function (sp, cp, ep, n) {
    	var pts = new Array();
    		for (var i=0; i < n; i++) {
        		pts.push(Math.plotPointOnQuadCurve(sp, cp, ep, i/n));
    		} 
    	return pts;
	}

	Math.plotEquidistantPointsOnLine = function(p1, p2, dist, step, stray) {
	var pts = new Array(); 
	var currentp = new Point2D(p1.x, p1.y);
	for (i = 0; i <= 1; i += step) { // step through curve time (0 to 1)
      	p = Math.plotPointOnLine(p1, p2, i); // find the point on the curve at time i 
      		if ((Math.getDistance2D(p, currentp) - dist) > stray) { // overshot
         		i -= step; // repeat the step
         		step *= .9; // a bit further back in time
      		} else if ((Math.getDistance2D(p, currentp) - dist) < -stray) { // undershot 
         		i -= step; // repeat the step
         		step *= 1.1; // a bit further forward in time
      		} else { // if we're in tolerance limits
         		currentp.setLocation(p.x, p.y); // make it the current point for our next distance check
         		pts.push(p);
     			}
  	 	}
  	 return pts;
	}
	
	// returns virtually equidistant point2D instances along a quad curve
	// dist : goal distance to spread points by
	// step : number of calculation steps (0 to 1)
	// stray : acceptable amount of stray from distance
	// author: Gary Fixler
	Math.plotEquidistantPointsOnQuadCurve = function(sp, cp, ep, dist, step, stray) {
	var pts = new Array(); 
	var currentp = new Point2D(sp.x, sp.y);
	for (i = 0; i <= 1; i += step) { // step through curve time (0 to 1)
      	p = Math.plotPointOnQuadCurve(sp, cp, ep, i); // find the point on the curve at time i 
      		if ((Math.getDistance2D(p, currentp) - dist) > stray) { // overshot
         		i -= step; // repeat the step
         		step *= .9; // a bit further back in time
      		} else if ((Math.getDistance2D(p, currentp) - dist) < -stray) { // undershot 
         		i -= step; // repeat the step
         		step *= 1.1; // a bit further forward in time
      		} else { // if we're in tolerance limits
         		currentp.setLocation(p.x, p.y); // make it the current point for our next distance check
         		pts.push(p);
     			}
  	 	}
  	 return pts;
	}

	// returns point2D instances at n intervals (t=1/n, 2/n, etc) along a cubic curve
	// defined by start point, two control points, and end point
	// for convenience, we use Math.solveCubic 
	// and calculate points on sub quadratic curves
	// with Math.plotPointsOnQuadCurve
	Math.plotPointsOnCubicCurve = function (sp, cp1, cp2, ep, n) {
    	var result = new Array();
    	var s = Math.solveCubic(sp, ep, cp1, cp2);
    	// cubic curve has four quadratic subsegments
    	var pts1 = Math.plotPointsOnQuadCurve(sp, s.cp1, s.ap1, Math.floor(n/4));
    	var pts2 = Math.plotPointsOnQuadCurve(s.ap1, s.cp2, s.ap2, Math.floor(n/4));
    	var pts3 = Math.plotPointsOnQuadCurve(s.ap2, s.cp3, s.ap3, Math.floor(n/4));
    	var pts4 = Math.plotPointsOnQuadCurve(s.ap3, s.cp4, ep, Math.floor(n/4));
    	var pts = result.concat(pts1, pts2, pts3, pts4);
    	return pts;
	}

	// returns virtually equidistant point2D instances along a cubic curve
	Math.plotEquidistantPointsOnCubicCurve = function (sp, cp1, cp2, ep, dist, step, stray) {
    	var result = new Array();
    	var s = Math.solveCubic(sp, ep, cp1, cp2);
    	// cubic curve has four quadratic subsegments
    	var pts1 = Math.plotEquidistantPointsOnQuadCurve(sp, s.cp1, s.ap1, dist, step, stray);
    	var pts2 = Math.plotEquidistantPointsOnQuadCurve(s.ap1, s.cp2, s.ap2, dist, step, stray);
    	var pts3 = Math.plotEquidistantPointsOnQuadCurve(s.ap2, s.cp3, s.ap3, dist, step, stray);
    	var pts4 = Math.plotEquidistantPointsOnQuadCurve(s.ap3, s.cp4, ep, dist, step, stray);
    	// temporary fix 
    	if (Math.getDistance2D(pts1[pts1.length-1], pts2[0]) > dist*1.5) pts1.push(s.ap1);
    	if (Math.getDistance2D(pts2[pts2.length-1], pts3[0]) > dist*1.5) pts2.push(s.ap2);
    	if (Math.getDistance2D(pts3[pts3.length-1], pts4[0]) > dist*1.5) pts3.push(s.ap3);
    	var pts = result.concat(pts1, pts2, pts3, pts4);
    	return pts;
	}
	
	


