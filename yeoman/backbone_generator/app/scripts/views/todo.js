/*global Test2, Backbone, JST*/

Test2.Views = Test2.Views || {};

(function () {
    'use strict';

    Test2.Views.Todo = Backbone.View.extend({

        template: JST['app/scripts/templates/todo-item.ejs'],

        tagName: 'li',

        id: '',

        className: '',

        events: {
          "click .toggle"   : "toggleDone",
          "dblclick .view"  : "edit",
          "click a.destroy" : "clear",
          "keypress .edit"  : "updateOnEnter",
          "blur .edit"      : "close"
        },

        initialize: function () {
          //this.$el = $('#todo');
          this.listenTo(this.model, 'change', this.render);
          this.listenTo(this.model, 'destroy', this.remove);
        },

        render: function () {
          //this.$el.html(this.template(this.model.toJSON()));
          //return this;

          this.$el.html(this.template(this.model.toJSON()));
          this.$el.toggleClass('done', this.model.get('done'));
          this.input = this.$('.edit');
          return this;
        },

        toggleDone: function() {
          this.model.toggle();
        },

        edit: function() {
          console.log('executed when todo label is double-clicked');
          this.$el.addClass("editing");
          this.input.focus();
        },

        close: function() {
          console.log('executed when todo loses focus');
          var value = this.input.val();
          if (!value) {
            this.clear();
          } else {
            this.model.save({title: value});
            this.$el.removeClass("editing");
          }
        },

        updateOnEnter: function( e ) {
          // executed on each keypress when in todo edit mode,
          // but we'll wait for enter to get in action
          console.log('updateOnEnter');
          if (e.keyCode == 13) this.close();
        },

        clear: function() {
          this.model.destroy();
        }
    });

})();
