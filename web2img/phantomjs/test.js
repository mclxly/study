var URLS = ["http://www.bing.com",
            "http://item.jd.com/1065971.html",
            ]

var SCREENSHOT_WIDTH = 1280; 
var SCREENSHOT_HEIGHT = 900; 
var LOAD_WAIT_TIME = 5000; 

var getPageTitle = function(page){
    var documentTitle = page.evaluate(function(){
        return document.title; 
    })
    console.log("getting title:", documentTitle)
    return documentTitle; 
}

var getPageHeight = function(page){
    var documentHeight = page.evaluate(function() { 
        return document.body.offsetHeight; 
    })
    console.log("getting height:", documentHeight)
    return documentHeight; 
}

var renderPage = function(page){

    var title =  getPageTitle(page);

    var pageHeight = getPageHeight(page); 

    page.clipRect = {
        top:0,left:0,width: SCREENSHOT_WIDTH, 
        height: pageHeight
    };
    page.render(title+".png");
    console.log("rendered:", title+".png")
}

var exitIfLast = function(index,array){
    console.log(array.length - index-1, "more screenshots to go!")
    console.log("~~~~~~~~~~~~~~")
    if (index == array.length-1){
        console.log("exiting phantomjs")
        phantom.exit();
    }
}

var takeScreenshot = function(element){

    console.log("opening URL:", element)

    var page = require("webpage").create();

    page.viewportSize = {width:SCREENSHOT_WIDTH, height:SCREENSHOT_HEIGHT};

    page.open(element); 

    console.log("waiting for page to load...")

    page.onLoadFinished = function() {
        setTimeout(function(){
            console.log("that's long enough")
            renderPage(page)
            exitIfLast(index,URLS)
            index++; 
            takeScreenshot(URLS[index]);
        },LOAD_WAIT_TIME)
    }

}

var index = 0; 

takeScreenshot(URLS[index]);
