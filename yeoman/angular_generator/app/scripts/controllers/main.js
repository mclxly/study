'use strict';

/**
 * @ngdoc function
 * @name t1App.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the t1App
 */
angular.module('t1App')
  .controller('MainCtrl', function ($scope, localStorageService) {
    var todosInStore = localStorageService.get('todos');
    $scope.todos = todosInStore && todosInStore.split('\n') || [];

    $scope.$watch('todos', function () {
      localStorageService.add('todos', $scope.todos.join('\n'));
    }, true);

    $scope.addTodo = function () {
      console.log($scope.todo);
      if ($scope.todo) {
        $scope.todos.push($scope.todo);
      };
      $scope.todo = '';
    };
    $scope.removeTodo = function (index) {
      $scope.todos.splice(index, 1);
    };
  });
