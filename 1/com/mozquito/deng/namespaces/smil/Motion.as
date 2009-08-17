DENG.Motion = function ( obj, prop, begin, duration, useSeconds)
    {
        this.setObj(obj);
        this.setProp(prop);
        this.setBegin(begin);
        this.setPosition(begin);
        this.setDuration(duration);
        this.setUseSeconds(useSeconds);
        this._listeners = [];
        this.addListener(this);
        this.start();
    };
var MP = DENG.Motion.prototype;
AsBroadcaster.initialize(MP);
MP.setFPS = function ( fps)
    {
        var oldIsPlaying = this.isPlaying;
        this.stopEnterFrame();
        this.fps = fps;
        if( oldIsPlaying )
            this.startEnterFrame();
    };
MP.getFPS = function ( )
    {
        return this.fps;
    };
MP.startEnterFrame = function ( )
    {
        if( this.fps == undefined )
        {
            _global.MovieClip.addListener(this);
        }
        else
            this.intervalID = setInterval(this, "onEnterFrame", 1000 / this.fps);
        this.isPlaying = true;
    };
MP.stopEnterFrame = function ( )
    {
        if( this.fps == undefined )
        {
            _global.MovieClip.removeListener(this);
        }
        else
            clearInterval(this.intervalID);
        this.isPlaying = false;
    };
MP.start = function ( )
    {
        this.rewind();
        this.startEnterFrame();
        this.broadcastMessage("onMotionStarted", this);
    };
MP.stop = function ( )
    {
        this.stopEnterFrame();
        this.broadcastMessage("onMotionStopped", this);
    };
MP.resume = function ( )
    {
        this.fixTime();
        this.startEnterFrame();
        this.broadcastMessage("onMotionResumed", this);
    };
MP.rewind = function ( t)
    {
        this.$time = (t == undefined)? 0: t;
        this.fixTime();
        this.update();
    };
MP.fforward = function ( )
    {
        this.setTime(this.$duration);
        this.fixTime();
    };
MP.nextFrame = function ( )
    {
        if( this.$useSeconds )
        {
            this.setTime((getTimer() - this.startTime) / 1000);
        }
        else
            this.setTime(this.$time + 1);
    };
MP.onEnterFrame = MP.nextFrame;
MP.prevFrame = function ( )
    {
        if( !this.$useSeconds )
            this.setTime(this.$time - 1);
    };
MP.toString = function ( )
    {
        return "[Motion prop=" + this.prop + " t=" + this.time + " pos=" + this.getPosition() + "]";
    };
MP.getPosition = function ( t)
    {
    };
MP.setPosition = function ( p)
    {
        this.$prevPos = this.$pos;
        this.$pos = p;
        this.$obj[this.$prop] = this.$pos;
        this.broadcastMessage("onMotionChanged", this, this.$pos);
        updateAfterEvent();
    };
MP.setTime = function ( t)
    {
        this.prevTime = this.$time;
        if( t > this.duration )
        {
            //if( this.$looping )
            if( --this.$counter > 0 )
            {
                this.rewind(t - this.$duration);
                this.update();
                this.broadcastMessage("onMotionLooped", this);
            }
            else
            {
                if( this.$useSeconds )
                {
                    this.$time = this.$duration;
                    this.update();
                }
                this.stop();
                this.broadcastMessage("onMotionFinished", this);
            }
        }
        else if( t < 0 )
        {
            this.rewind();
            this.update();
        }
        else
        {
            this.$time = t;
            this.update();
        }
    };
MP.getTime = function ( )
    {
        return this.$time;
    };
MP.setBegin = function ( b)
    {
        if( b == undefined )
        {
            this.$begin = this.$obj[this.$prop];
        }
        else
            this.$begin = b;
    };
MP.getBegin = function ( )
    {
        return this.$begin;
    };
MP.setDuration = function ( d)
    {
        this.$duration = (d == null || (d <= 0))? Infinity: d;
    };
MP.getDuration = function ( )
    {
        return this.$duration;
    };
MP.setObj = function ( o)
    {
        this.$obj = o;
    };
MP.getObj = function ( )
    {
        return this.$obj;
    };
MP.setProp = function ( p)
    {
        this.$prop = p;
    };
MP.getProp = function ( )
    {
        return this.$prop;
    };
MP.setUseSeconds = function ( useSecs)
    {
        this.$useSeconds = useSecs;
    };
MP.getUseSeconds = function ( )
    {
        return this.$useSeconds;
    };
MP.setLooping = function ( b)
    {
        this.$looping = b;
    };
MP.getLooping = function ( )
    {
        return this.$looping;
    };
MP.getPrevPos = function ( )
    {
        return this.$prevPos;
    };
MP.fixTime = function ( )
    {
        if( this.$useSeconds )
            this.startTime = getTimer() - (this.$time * 1000);
    };
MP.update = function ( )
    {
        this.setPosition(this.getPosition(this.$time));
    };
with( MP)
{
    addProperty("obj", getObj, setObj);
    addProperty("prop", getProp, setProp);
    addProperty("begin", getBegin, setBegin);
    addProperty("duration", getDuration, setDuration);
    addProperty("useSeconds", getUseSeconds, setUseSeconds);
    addProperty("looping", getLooping, setLooping);
    addProperty("prevPos", getPrevPos, null);
    addProperty("time", getTime, setTime);
    addProperty("position", function ( )
        {
            return this.getPosition();
        }, function ( p)
        {
            this.setPosition(p);
        });
}
delete(MP);
