DENG.Tween = function ( obj, prop, func, begin, finish, duration, useSeconds, count) {
	this.superCon(obj, prop, begin, duration, useSeconds);
	this.setFunc(func);
	this.setFinish(finish);
	this.$counter = count;
};
DENG.Tween.extend(DENG.Motion);
var TP = DENG.Tween.prototype;
TP.toString = function ( )
    {
        return "[Tween obj=" + this.obj + " prop=" + this.prop + " beg=" + this.begin + " fin=" + this.finish + " dur=" + this.duration + " t=" + this.time + " pos=" + this.getPosition() + "]";
    };
TP.continueTo = function ( finish, duration)
    {
        this.setBegin(this.getPosition());
        this.setFinish(finish);
        if( duration != undefined )
            this.setDuration(duration);
        this.start();
    };
TP.yoyo = function ( )
    {
        with( this)
        {
            continueTo(getBegin(), getTime());
        }
    };
TP.getPosition = function ( t)
    {
        if( t == undefined )
            t = this.$time;
        with( this)
        {
            return $func(t, $begin, $change, $duration);
        }
    };
TP.setFunc = function ( f)
    {
        this.$func = f;
    };
TP.getFunc = function ( )
    {
        return this.$func;
    };
TP.setChange = function ( c)
    {
        this.$change = c;
    };
TP.getChange = function ( )
    {
        return this.$change;
    };
TP.setFinish = function ( f)
    {
        this.$change = f - this.$begin;
    };
TP.getFinish = function ( )
    {
        return this.$begin + this.$change;
    };
TP.superCon = function ( )
    {
        arguments.caller.prototype.__proto__.constructor.apply(this, arguments);
    };
with( TP)
{
    addProperty("func", getFunc, setFunc);
    addProperty("change", getChange, setChange);
    addProperty("finish", getFinish, setFinish);
}
delete(TP);
