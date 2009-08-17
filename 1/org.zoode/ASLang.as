//!-- UTF8
// ASLang ver.0.1.0

 // this method is used for __proto__ based inheritance
 // reference: http://www.quantumwave.com/flash/inheritance.html 
 Function.prototype.extend = function(superClass) {
    this.prototype.__proto__ = superClass.prototype;
    this.prototype.__constructor__ = superClass;
    ASSetPropFlags(this.prototype, ["__constructor__"], 1);
    }
    ASSetPropFlags(Function.prototype, ["extend"], 1);