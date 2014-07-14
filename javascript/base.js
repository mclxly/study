function EventTarget() {
}

EventTarget.prototype = {
  constructor: EventTarget,

  addListener: function(type, listener) {
    if (!this.hasOwnProperty("_listeners")) {
      this._listeners = [];
    };

    if (typeof this._listeners[type] == "undefined") {
      this._listeners[type] = []
    };

    this._listeners[type].push(listener);
  },

  fire: function(event) {
    if (!event.target) {
      event.target = this;
    };

    if (!event.type) {
      throw new Error("Event Object missing 'type' property.");
    };

    if (this._listeners && this._listeners[event.type] instanceof Array) {
      var listener = this._listeners[event.type];
      for (var i = 0; i < listener.length; i++) {
        listener[i].call(this, event);
      };
    };
  }
};

var target = new EventTarget();
target.addListener("message", function(event) {
  console.log("Message is " + event.data);
})

target.fire({
  type: "message",
  data: "Hello world!"
});

// function Rectangle(length, width) {
//   this.length = length;
//   this.width = width;
// }

// Rectangle.prototype.getArea = function() {
//   return this.length * this.width;
// }

// Rectangle.prototype.toString = function() {
//   return "[Rectangle " + this.length + "x" + this.width + "]";
// };

// function Square(size) {
//   this.length = this.width = size;
// }

// Square.prototype = new Rectangle();
// Square.prototype.constructor = Square;

// Square.prototype.toString = function() {
//   return "[Square " + this.length + "x" + this.width + "]";
// };

// var rect = new Rectangle(5, 10);
// var squa = new Square(6);

// console.log(rect.getArea());
// console.log(squa.getArea());

// console.log(rect.toString());
// console.log(squa.toString());

// console.log(rect instanceof Rectangle);
// console.log(rect instanceof Object);

// console.log(squa instanceof Square);
// console.log(squa instanceof Rectangle);
// console.log(squa instanceof Object);





// var book = {
//   title: "The principles of OO JS"
// }

// console.log("title" in book);
// console.log(book.hasOwnProperty("title"));
// console.log("hasOwnProperty" in book);
// console.log(book.hasOwnProperty("hasOwnProperty"));
// console.log(Object.prototype.hasOwnProperty("hasOwnProperty"));