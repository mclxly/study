// A simple decorator
@annotation
class MyClass { 
  cc() {
    return this.annotated;
  }
}

function annotation(target) {
  // Add a property on target
  target.annotated = true;
}

let a = new MyClass;
console.log(a);
console.log(a.annotated);
console.log(a.cc());