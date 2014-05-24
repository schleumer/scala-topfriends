define [
  'angular'
  'facebook'
], (angular, FB) ->
  topchat = angular.module('topfriends.topchat', ['ngRoute'])
  topchat.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
    $locationProvider.hashPrefix '!'
    $routeProvider.when('/facebook/topchat', {
      templateUrl: 'templates/facebook/topchat',
      controller: 'TopChatController'
    }).when('/facebook/topchat/share/:id', {
      templateUrl: 'templates/facebook/topchat.share',
      controller: 'TopChatShareController'
    }).otherwise({
      redirectTo: '/'
    })
  ]
  topchat.controller 'TopChatShareController',
    ['$scope', '$http', '$comet', '$location', ($scope, $http, $comet, $location) ->
      console.log('xd');
    ]
  topchat.controller 'TopChatController',
    ['$scope', '$http', '$comet', '$location', ($scope, $http, $comet, $location) ->
      $scope.threads = []
      $scope.status = null
      $scope.name_search = ""
      $scope.image = ""
      $scope.settings = {
        tag: false,
        friendsToTag: [],
        share: true,
        length: "top10"
      }
      $scope.filterIt = (it) ->
        if not $scope.name_search
          return true
        false
      $scope.generate = () =>
        $scope.status = "Preparando..."
        $comet('/topchat/generate/:cbFn', (type, message) ->
          switch type
            when "status"
              $scope.status = message
            when "error"
              $location.path("/error").search("message", message)
            when "die"
              $location.path("/")
            when "image"
              $scope.image = message
            when "complete"
              $location.path("/facebook/topchat/share/" + $scope.image)
          return
        , $scope.settings)
      $scope.init = ->
        $scope.status = "Carregando..."
        $comet('/topchat/comet/:cbFn', (type, message) ->
          switch type
            when "status"
              $scope.status = message
            when "threads"
              $scope.status = ""
              $scope.threads = JSON.parse(message)
            when "error"
              $location.path("/error").search("message", message)
            when "die"
              $location.path("/")
          return
        )
        return
      return
    ]