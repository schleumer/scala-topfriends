require [
  'angular'
  'facebook'
  'underscore'
  'jquery'
  'comet'
  'ngRoute'
  'ngAnimate'
  'topfriends.utils'
  'topfriends.facebook'
  'topfriends.topchat'
  'topfriends.error'
  'pnotify'
  'bootstrap'
  'bootstrap.tooltip'
], (angular, FB, _, $) ->
  $.pnotify.defaults.history = false

  FB.init appId : '242235712573248'

  app = angular.module 'Topfriends', [
    'topfriends.utils'
    'topfriends.facebook'
    'topfriends.error'
    'topfriends.topchat'
    'comet'
    'ngRoute'
    'ngAnimate'
  ]

  app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
    $locationProvider.hashPrefix '!'
    $routeProvider.when('/index', {
      templateUrl: 'templates/index',
      controller: 'IndexController'
    }).when('/error', {
        templateUrl: 'templates/error',
        controller: 'ErrorController'
    }).otherwise({
      redirectTo: '/index'
    })
  ]

  app.run ['$rootScope', '$http', 'facebook', '$location', ($rootScope, $http, facebook, $location) ->
    $rootScope.loginStatus = -1
    $rootScope.user = null
    $rootScope.authenticated = false
    if authenticatedUser?
      session = authenticatedUser
      if session
        $rootScope.user = session
        $rootScope.authenticated = true

    $rootScope.coolNumber = coolNumber

    $rootScope.p = (count, sing, plur, none) ->
      return __(none).replace(/:i:/g, count) if !count || count < 1
      return __(sing).replace(/:i:/g, count) if count < 2
      return __(plur).replace(/:i:/g, count) if count > 1

    $rootScope.pf = (count, sing, plur, none) ->
      return __(none).replace(/:i:/g, $rootScope.coolNumber(count)) if !count || count < 1
      return __(sing).replace(/:i:/g, $rootScope.coolNumber(count)) if count < 2
      return __(plur).replace(/:i:/g, $rootScope.coolNumber(count)) if count > 1

    return
  ]

  app.controller 'MainController', ['$scope', ($scope) ->

  ]

  app.controller 'IndexController', ['$scope', ($scope) ->

  ]

  $(() ->
    angular.bootstrap(document, ['Topfriends'])
  )
  return
