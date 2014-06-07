'use strict';

/**
 * @ngdoc function
 * @name t1App.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the t1App
 */
angular.module('t1App')
  .controller('AboutCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
