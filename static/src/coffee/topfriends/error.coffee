define [
  'angular'
  'facebook'
], (angular, FB) ->
  topchat = angular.module('topfriends.error', [])
  topchat.controller 'ErrorController',
    ['$scope', '$http', '$location', ($scope, $http, $location) ->
      $scope.init = ->
        $scope.message = $location.search().message
        return
      return
    ]