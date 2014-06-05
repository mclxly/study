/*global Test2, Backbone, JST*/

Test2.Views = Test2.Views || {};

(function () {
    'use strict';

    Test2.Views.AppView = Backbone.View.extend({

      el: $("#todoapp"),

      template: JST['app/scripts/templates/todo-stats.ejs'],

      events: {
        "keypress #new-todo":  "createOnEnter",
        "click #clear-completed": "clearCompleted",
        "click #toggle-all": "toggleAllComplete"
      },

      initialize: function (options) {
        this.input = this.$("#new-todo");
        this.allCheckbox = this.$("#toggle-all")[0];

        console.log(options.Todos);
        this.listenTo(options.Todos, 'add', this.addOne);
        this.listenTo(options.Todos, 'reset', this.addAll);
        this.listenTo(options.Todos, 'all', this.render);

        this.footer = this.$('footer');
        this.main = $('#main');

        options.Todos.fetch();

        //this.listenTo(this.model, 'change', this.render);
      },

      render: function () {
        var done = Todos.done().length;
        var remaining = Todos.remaining().length;

        if (Todos.length) {
          this.main.show();
          this.footer.show();
          this.footer.html(this.template({done: done, remaining: remaining}));
        } else {
          this.main.hide();
          this.footer.hide();
        }

        this.allCheckbox.checked = !remaining;
        //this.$el.html(this.template(this.model.toJSON()));
      },

      addOne: function(todo) {
        var view = new window.Test2.Todo({model: todo});
        this.$("#todo-list").append(view.render().el);
      },

      addAll: function() {
        Todos.each(this.addOne, this);
      },

      createOnEnter: function(e) {
        if (e.keyCode != 13) return;
        if (!this.input.val()) return;

        Todos.create({title: this.input.val(), order: Todos.nextOrder()});
        this.input.val('');
      },

      clearCompleted: function() {
        _.invoke(Todos.done(), 'destroy');
        return false;
      },

      toggleAllComplete: function () {
        var done = this.allCheckbox.checked;
        Todos.each(function (todo) { todo.save({'done': done}); });
      }

    });

})();
