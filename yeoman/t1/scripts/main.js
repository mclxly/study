/*global Test2, $*/


window.Test2 = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function () {
      'use strict';
      console.log('Hello from Backbone!');

      var Todos = new this.Collections.TodoList;

      var myTodo = new this.Models.Todo({
        title: 'Check attributes property of the logged models in the console.'
      });

      // create a view for a todo
      var todoView = new this.Views.Todo({model: myTodo});

      var App = new this.Views.AppView({Todos: Todos});
    }
};

$(document).ready(function () {
    'use strict';
    Test2.init();
});
