'use strict';

/**
 * @ngdoc overview
 * @name t1App
 * @description
 * # t1App
 *
 * Main module of the application.
 */
angular
  .module('t1App', [
    'LocalStorageModule',
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.sortable'
  ])
  // .config(['localStorageServiceProvider', function(localStorageServiceProvider){
  //   localStorageServiceProvider.setPrefix('newPrefix');
  // }])
  .config(function ($routeProvider, localStorageServiceProvider) {
    localStorageServiceProvider.setPrefix('angular-test');

    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
