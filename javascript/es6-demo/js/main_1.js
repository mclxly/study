import 'babel-polyfill';
import world from './world';
import 'whatwg-fetch';

document.getElementById('output').innerHTML = `Hello ${world}!`;

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response
  } else {
    var error = new Error(response.statusText)
    error.response = response
    throw error
  }
}

function parseJSON(response) {
  return response.json()
}

function request(url) {
  let ret = new Promise((resolve, reject) => {
    fetch(url, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      // body: JSON.stringify({
      //   name: 'Hubot',
      //   login: 'hubot',
      // })
    })
      .then(checkStatus)
      .then(parseJSON)
      .then(function(json) {
        console.log('request succeeded with JSON response', json)
        it.next( json );
      }).catch(function(error) {
        console.log('request failed', error)
      })
  });

  console.log(ret);

  return ret;
}

// // -------------------------------------------------------------------
// // Case 1
// var url = 'http://106.184.5.143/api/login?username=aaa&password=aaa';

// function *main() {
//     var result1 = yield request( url );
//     // var data = JSON.parse( result1 );
//     console.log('finish r1', result1);

//     var result2 = yield request( "http://106.184.5.143/api/login?password=aaa1&username=" + result1.username );
//     // var resp = JSON.parse( result2 );
//     console.log( "The value you asked for: " + result2 );
// }

// var it = main();
// it.next(); // get it all started

// let ret = request('http://106.184.5.143/api/login?username=aaa&password=aaa');
// console.log(ret);

// // -------------------------------------------------------------------
// // Case 2: Generator
// function *foo() {
//     yield 3;
//     yield 4;
// }

// function *bar() {
//     yield 1;
//     yield 2;
//     yield *foo(); // `yield *` delegates iteration control to `foo()`
//     yield 5;
// }

// for (var v of bar()) {
//     console.log( v );
// }

// // -------------------------------------------------------------------
// // Case 3: Generator handle error
// function *foo() {
//     try {
//         yield 2;
//     }
//     catch (err) {
//         console.log( "foo caught: " + err );
//     }

//     console.log( "pause");
//     yield; // pause

//     // now, throw another error
//     throw "Oops!";
// }

// function *bar() {
//     yield 1;
//     try {
//         yield *foo();
//     }
//     catch (err) {
//         console.log( "bar caught: " + err );
//     }
// }

// var it = bar();

// it.next(); // { value:1, done:false }
// it.next(); // { value:2, done:false }

// it.throw( "Uh oh!" ); // will be caught inside `foo()`
// // foo caught: Uh oh!

// it.next(); // { value:undefined, done:true }  --> No error here!
// // bar caught: Oops!

// -------------------------------------------------------------------
// Case 4 Generator + Promise
