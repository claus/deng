Math.linearTween = function ( t, b, c, d)
    {
        return c * t / d + b;
    };
Math.easeInQuad = function ( t, b, c, d)
    {
        return c * (t = t / d) * t + b;
    };
Math.easeOutQuad = function ( t, b, c, d)
    {
        return -c * (t = t / d) * (t - 2) + b;
    };
Math.easeInOutQuad = function ( t, b, c, d)
    {
        if( (t = t / (d / 2)) < 1 )
            return c / 2 * t * t + b;
        return -c / 2 * (--t * (t - 2) - 1) + b;
    };
Math.easeInCubic = function ( t, b, c, d)
    {
        return c * (t = t / d) * t * t + b;
    };
Math.easeOutCubic = function ( t, b, c, d)
    {
        return c * ((t = t / d - 1) * t * t + 1) + b;
    };
Math.easeInOutCubic = function ( t, b, c, d)
    {
        if( (t = t / (d / 2)) < 1 )
            return c / 2 * t * t * t + b;
        return c / 2 * ((t = t - 2) * t * t + 2) + b;
    };
Math.easeInQuart = function ( t, b, c, d)
    {
        return c * (t = t / d) * t * t * t + b;
    };
Math.easeOutQuart = function ( t, b, c, d)
    {
        return -c * ((t = t / d - 1) * t * t * t - 1) + b;
    };
Math.easeInOutQuart = function ( t, b, c, d)
    {
        if( (t = t / (d / 2)) < 1 )
            return c / 2 * t * t * t * t + b;
        return -c / 2 * ((t = t - 2) * t * t * t - 2) + b;
    };
Math.easeInQuint = function ( t, b, c, d)
    {
        return c * (t = t / d) * t * t * t * t + b;
    };
Math.easeOutQuint = function ( t, b, c, d)
    {
        return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
    };
Math.easeInOutQuint = function ( t, b, c, d)
    {
        if( (t = t / (d / 2)) < 1 )
            return c / 2 * t * t * t * t * t + b;
        return c / 2 * ((t = t - 2) * t * t * t * t + 2) + b;
    };
Math.easeInSine = function ( t, b, c, d)
    {
        return -c * Math.cos(t / d * 1.5707963267948966) + c + b;
    };
Math.easeOutSine = function ( t, b, c, d)
    {
        return c * Math.sin(t / d * 1.5707963267948966) + b;
    };
Math.easeInOutSine = function ( t, b, c, d)
    {
        return -c / 2 * (Math.cos(3.141592653589793 * t / d) - 1) + b;
    };
Math.easeInExpo = function ( t, b, c, d)
    {
        return (t == 0)? b: c * Math.pow(2, 10 * (t / d - 1)) + b;
    };
Math.easeOutExpo = function ( t, b, c, d)
    {
        return (t == d)? b + c: c * (-Math.pow(2, -10 * t / d) + 1) + b;
    };
Math.easeInOutExpo = function ( t, b, c, d)
    {
        if( t == 0 )
            return b;
        if( t == d )
            return b + c;
        if( (t = t / (d / 2)) < 1 )
            return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
        return c / 2 * (-Math.pow(2, -10 * (--t)) + 2) + b;
    };
Math.easeInCirc = function ( t, b, c, d)
    {
        return -c * (Math.sqrt(1 - ((t = t / d) * t)) - 1) + b;
    };
Math.easeOutCirc = function ( t, b, c, d)
    {
        return c * Math.sqrt(1 - ((t = t / d - 1) * t)) + b;
    };
Math.easeInOutCirc = function ( t, b, c, d)
    {
        if( (t = t / (d / 2)) < 1 )
            return -c / 2 * (Math.sqrt(1 - (t * t)) - 1) + b;
        return c / 2 * (Math.sqrt(1 - ((t = t - 2) * t)) + 1) + b;
    };
Math.easeInElastic = function ( t, b, c, d, a, p)
    {
        if( t == 0 )
            return b;
        if( (t = t / d) == 1 )
            return b + c;
        if( !p )
            p = d * 0.3;
        if( a < Math.abs(c) )
        {
            a = c;
            var s = p / 4;
        }
        else
            var s = p / 6.283185307179586 * Math.asin(c / a);
        return -(a * Math.pow(2, 10 * (t = t - 1)) * Math.sin((t * d - s) * 6.283185307179586 / p)) + b;
    };
Math.easeOutElastic = function ( t, b, c, d, a, p)
    {
        if( t == 0 )
            return b;
        if( (t = t / d) == 1 )
            return b + c;
        if( !p )
            p = d * 0.3;
        if( a < Math.abs(c) )
        {
            a = c;
            var s = p / 4;
        }
        else
            var s = p / 6.283185307179586 * Math.asin(c / a);
        return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * 6.283185307179586 / p) + c + b;
    };
Math.easeInOutElastic = function ( t, b, c, d, a, p)
    {
        if( t == 0 )
            return b;
        if( (t = t / (d / 2)) == 2 )
            return b + c;
        if( !p )
            p = d * 0.44999999999999996;
        if( a < Math.abs(c) )
        {
            a = c;
            var s = p / 4;
        }
        else
            var s = p / 6.283185307179586 * Math.asin(c / a);
        if( t < 1 )
            return -0.5 * (a * Math.pow(2, 10 * (t = t - 1)) * Math.sin((t * d - s) * 6.283185307179586 / p)) + b;
        return a * Math.pow(2, -10 * (t = t - 1)) * Math.sin((t * d - s) * 6.283185307179586 / p) * 0.5 + c + b;
    };
Math.easeInBack = function ( t, b, c, d, s)
    {
        if( s == undefined )
            s = 1.70158;
        return c * (t = t / d) * t * ((s + 1) * t - s) + b;
    };
Math.easeOutBack = function ( t, b, c, d, s)
    {
        if( s == undefined )
            s = 1.70158;
        return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    };
Math.easeInOutBack = function ( t, b, c, d, s)
    {
        if( s == undefined )
            s = 1.70158;
        if( (t = t / (d / 2)) < 1 )
            return c / 2 * (t * t * (((s = s * 1.525) + 1) * t - s)) + b;
        return c / 2 * ((t = t - 2) * t * (((s = s * 1.525) + 1) * t + s) + 2) + b;
    };
Math.easeInBounce = function ( t, b, c, d)
    {
        return (c - Math.easeOutBounce(d - t, 0, c, d)) + b;
    };
Math.easeOutBounce = function ( t, b, c, d)
    {
        if( (t = t / d) < 0.36363636363636365 )
        {
            return c * (7.5625 * t * t) + b;
        }
        else if( t < 0.7272727272727273 )
        {
            return c * (7.5625 * (t = t - 0.5454545454545454) * t + 0.75) + b;
        }
        else if( t < 0.9090909090909091 )
        {
            return c * (7.5625 * (t = t - 0.8181818181818182) * t + 0.9375) + b;
        }
        else
            return c * (7.5625 * (t = t - 0.9545454545454546) * t + 0.984375) + b;
    };
Math.easeInOutBounce = function ( t, b, c, d)
    {
        if( t < (d / 2) )
            return Math.easeInBounce(t * 2, 0, c, d) * 0.5 + b;
        return Math.easeOutBounce(t * 2 - d, 0, c, d) * 0.5 + (c * 0.5) + b;
    };