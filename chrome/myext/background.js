//$("body").append('Test');
console.debug('loading my extension');

var cars = ['focus'];

var pollInterval = 1000 * 20; // in milliseconds
var timerId, timerId2;

function startRequest() {
  var idx = Math.floor( (Math.random() * cars.length) );  
  set_text(cars[idx]);
  timerId = window.setTimeout(startRequest, pollInterval);
}

function stopRequest() {
  window.clearTimeout(timerId);
}

function startRequest2() {
  var idx = Math.floor( (Math.random() * cars.length) );  
  hit_egg();
  timerId2 = window.setTimeout(startRequest2, pollInterval);
}

function stopRequest2() {
  window.clearTimeout(timerId2);
}

function sleep(callback, val) {
    setTimeout( function() {
        callback(val)}
    , 2000);
}

function hit_egg() {
  for (var k = 0; k < cars.length; k++) {   
    $('a[data-dismiss="modal"]').click();
  }
  console.log('hit egg...b');  

  var closebtn = document.getElementById('myclosebtn');
  closebtn.click();  
  $('a[data-dismiss="modal"]').click();
  $('li[data-index="2"]').click();
}

function set_text(val) {
   //setTimeout(function()           { callback(val); }    , millis);
  //$('#commentContent').val(cars[i]);
  if ($('a[data-dismiss="modal"]')) {
    $('a[data-dismiss="modal"]').click();
    //$('li[data-index="2"]').click();
  }
  var sendclosebtn = document.getElementById('mysendclosebtn');
  if (sendclosebtn) sendclosebtn.click();
  
  console.log(val + 'sendclosebtn');//return;
  $('#commentContent').val(val);
  var myEl = document.getElementById('sentBtn');
  myEl.click();  
}

function rush() {
  for (var i = 0; i < cars.length; i++) {   
  //for (var i = 0; i < 10; i++) {   
   // sleep(set_text, cars[i], 3000);   
   //set_text(cars[i]);
   sleep(set_text, cars[i]);
  }  
}

$('body').keyup(function(e){
   if(e.keyCode == 17){
      // Ctrl: 17 Alt: 18 Enter: 13 G: 71
       // user has pressed Ctrl
       console.log('rush...');
       //console.log(e);
       startRequest();
       //rush();
   }
   if(e.keyCode == 18) {
    console.log('stop...');
    stopRequest();
    stopRequest2();
   }
   if(e.keyCode == 13) {
    console.log('rush egg...');
    startRequest2();
   }
});
/*
// direct event
$('.nav').on('mousemove', function() {
	console.log('direct');
});

// create a jQuery event
e = $.Event('mousemove');

// set coordinates
e.pageX = 100;
e.pageY = 100;

// trigger event - must trigger on document
$(document).trigger(e);


window.setInterval(function() {
 console.log('go');
			 $( ".hypScratchArea j_HYPScratchArea" ).mousemove();
}, 50);

$('body').keyup(function(e){
   if(e.keyCode == 17){
       // user has pressed space
       console.log('go');
			 $( ".hypScratchArea j_HYPScratchArea" ).mousemove();
			 
			 
   }
});
*/