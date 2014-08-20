AppEmber.IndexController = Ember.Controller.extend({
  enableAritst: true,

  actions: {
    viewedArtist: function(artist) {
      console.log('hang on I"m viewing: ' + artist.name)
      }
  }
});
