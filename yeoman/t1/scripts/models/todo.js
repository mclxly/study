/*global Test2, Backbone*/

Test2.Models = Test2.Models || {};

(function () {
    'use strict';

    Test2.Models.Todo = Backbone.Model.extend({

        url: '',

        initialize: function() {
        },

        defaults: {
          title: '',
          order: 0,
          done: false
        },

        validate: function(attrs, options) {
        },

        parse: function(response, options)  {
            return response;
        },

        toggle: function() {
          this.save({done: !this.get("done")});
        }
    });

})();
