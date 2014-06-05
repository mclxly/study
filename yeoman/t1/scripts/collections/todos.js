/*global Test2, Backbone*/

Test2.Collections = Test2.Collections || {};

(function () {
    'use strict';

    Test2.Collections.TodoList = Backbone.Collection.extend({

        model: Test2.Models.Todo,

        localStorage: new Backbone.LocalStorage("todos-backbone"),

        done: function() {
          return this.where({done: true});
        },

        remaining: function() {
          return this.where({done: false});
        },

        nextOrder: function() {
          if (!this.length) return 1;
          return this.last().get('order') + 1;
        },

        comparator: 'order'
    });

})();
