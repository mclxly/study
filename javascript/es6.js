/*
npm install -g traceur-runner, then do traceur-runner myscript.js.
*/
{ let a = 'I am declared inside an anonymous block'; }
console.log(a); // ReferenceError: a is not defined