AppEmber.Router.reopen({
  // location: 'history'
});

AppEmber.Router.map(function () {
  this.route('activity', {
    path: 'activity'
  });
  this.route('search-results', {
    path: 'search/:term'
  });
  this.route('artist', {
    path: 'artist/:enid'
  });
  this.route('song', {
    path: 'song/:sid'
  });
});
