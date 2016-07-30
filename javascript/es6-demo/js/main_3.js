// https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20&%20beyond/ch4.md
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

// run (async) a generator to completion
// Note: simplified approach: no error handling here
function runGenerator(g) {
    var it = g(), ret;

    // asynchronously iterate over generator
    (function iterate(val){
        ret = it.next( val );

        if (!ret.done) {
            // poor man's "is it a promise?" test
            if ("then" in ret.value) {
                // wait on the promise
                ret.value.then( iterate );
            }
            // immediate value: just send right back in
            else {
                // avoid synchronous recursion
                setTimeout( function(){
                    iterate( ret.value );
                }, 0 );
            }
        }
    })();
}

var url = 'http://106.184.5.143/api/login?username=aaa&password=aaa';

// -------------------------------------------------------------------
// Case 1 Generator + Promise
runGenerator( function *main(){
    var result1 = yield request( url );
    // var data = JSON.parse( result1 );
    console.log('finish r1', result1);

    var result2 = yield request( "http://106.184.5.143/api/login?password=aaa1&username=" + result1.username );
    // var resp = JSON.parse( result2 );
    console.log( "The value you asked for: " + result2 );
} );