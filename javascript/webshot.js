// phantomjs中文网页截图质量不好
// 2014-05-30 13:53
var page = require('webpage').create();
page.open('http://www.jd.com', function() {
  page.render('example.png');
  phantom.exit();
});