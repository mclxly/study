Ember.Application.initializer({
  name: 'DBseeds',

  initialize: function(container, application) {
    // console.log('do something');
    localStorage.clear();

    store = container.lookup('store:main');
    console.log('sotre: ', store);

    for (var i = 0; i < 300; i++) {
      var id = 'ARNH6LU1187FB430FA';
      var random_id = id.split('').sort(function() {
        return 0.5 - Math.random()
      }).join('');

      var types = [
        'song',
        'artist'
      ];

      var random_type = Math.floor(Math.random() * types.length);
      var name = 'Jesse Cravens';
      var random_name = name.split('').sort(function() {
            return 0.5 - Math.random()
          }).join('');
      var random_hotness = Math.floor(Math.random() * 100) + 1;
      var random_timestamp = new Date(new Date(2013, 9, 30).getTime() +
          Math.random() *
          (new Date().getTime() - new Date(2013, 9, 30).getTime()));

      activity = store.createRecord('activity', {
        display_id: random_id,
        type: types[random_type],
        display_name: random_name,
        hotttnesss: random_hotness,
        timestamp: random_timestamp
      });
      activity.save();
    };

    console.log(store.find('activity')
      .then(function(stuff) {
        console.log('Total Activity Records: ' + stuff.toArray().length)
      })
    );
  }
});

var AppEmber = window.AppEmber = Ember.Application.create({
  LOG_TRANSITIONS: true,
  LOG_ACTIVE_GENERATION: true
});
AppEmber.applicationName = "Rock'n'Roll Call";

AppEmber.dummySearchResultsArtists = [
  {
    id: 1,
    name: 'Tom Waits',
    type: 'artist',
    enid: 'ARERLPG1187FB3BB39',
    hotttnesss: '1'
  },
  {
    id: 2,
    name: 'Thomas Alan Waits',
    type: 'artist',
    enid: 'ARERLPG1187FB3BB39',
    hotttnesss: '.89'
  },
  {
    id: 3,
    name: 'Tom Waits w/ Keith Richards',
    type: 'artist',
    enid: 'ARMPVNN13CA39CF8FC',
    hotttnesss: '.79'
  }
];

// AppEmber.IndexController = Ember.Controller.extend({});

Ember.Handlebars.helper('hottnesss-badge', function  (value, options) {
  var h = parseFloat(value);
  var hottnesss_num = Math.round(h * 100);
  var hottnesss_css = Math.ceil(h * 10) - 1;
  var html = "<h4>Hotness: ";

  if (hottnesss_num > 0) {
    html += '<i class="hottnesss">';
    for (var i = 0; i < hottnesss_css; i++) {
      html += '<i class="glyphicon glyphicon-fire hottness'+i+'"></i>';
    };
    html += "</i>";
    html += '<span class="hottnesss-badge">'+hottnesss_num+'</span></h4>';
  } else{
    html += "0</h4>";
  };

  return new Handlebars.SafeString(html);
});

// var artist = AppEmber.Artist.create({
//   enid: 'ARERLPG1187FB3BB39',
//   name: 'Tom Waits',
//   hotttnesss: 100,
//   biography: 'Rain dog.',
//   image: 'http://is.gd/GeaUhC'
// });

AppEmber.ApplicationController = Ember.ObjectController.extend({
  searchTerms: '',
  // applicationName: "Ember测试",
  applicationName: function() {
    var st = this.get('searchTerms');
    if (st) {
      return st + "???"
    } else {
      return "Ember测试"
    }
  }.property('searchTerms'),
  actions: {
    submit: function() {
      this.transitionToRoute('search-results',this.get('searchTerms'));
    }
  }
});

/* Order and include as you please. */
require('scripts/controllers/*');
require('scripts/store');
require('scripts/models/*');
require('scripts/routes/*');
require('scripts/components/*');
require('scripts/views/*');
require('scripts/router');
