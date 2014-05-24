define [
  'angular'
  'facebook'
  'pnotify'
], (angular, FB) ->
  utils = angular.module('topfriends.facebook', [])
  utils.service('facebook', ['$http', '$rootScope', ($http, $rootScope) ->
    return (
      login: (response, cb) ->
        data = {}
        if response.status is 'connected'
          $http(
            url: '/status'
            method: 'GET'
            params:
              from: 'facebook'
              token: response.authResponse.accessToken
          ).success((res) ->
            console.log(res)
            if res.data
              data.user = res.data
              data.authenticated = true
            $rootScope.user = data
            cb(data)
            return
          )
    )
  ])

  utils.directive 'topfriendsLogout', ['$http', ($http)->
    return (
      link: (scope, element) ->
        element.click ->
          $http.delete('/user').success () ->
            location.href = '/'
          return
        return
    )
  ]

  utils.directive 'topfriendsQuitFacebook', ['$http', ($http)->
    return (
      link: (scope, element) ->
        element.click ->
          $http.get('/user/logout').success () ->
            FB.api "/me/permissions", "DELETE", (response) ->
              location.href = '/'
              return
            return
          return
        return
    )
  ]

  utils.directive 'topfriendsFacebook',
    ['$rootScope', 'facebook', ($rootScope, facebook) ->
      return (
        require: 'ngModel'
        scope:
          ngModel: '='
          fbScope: '='
          complete: '&'
        link: (scope, element) ->
          element.click () ->
            FB.login(((response) ->

              if not response.authResponse?
                $.pnotify {
                  type: 'alert'
                  text: __('Você precisa autorizar o aplicativo')
                }
                scope.complete()
              else
                facebook.login(response, (data) ->
                  scope.ngModel.user = data.user
                  scope.ngModel.authenticated = data.authenticated
                  $rootScope.user = data.user
                  scope.complete()
                  return
                )
              return
            ), scope: 'email')
      )
    ]

  utils.directive 'topfriendsFacebookAuthorize',
    ['facebook', '$compile', '$http', '$templateCache', '$rootScope'
      (facebook, $compile, $http, $templateCache, $rootScope) ->
        return (
          scope:
            topfriendsFacebookAuthorize: '@'
          link: (scope, element) ->
            $rootScope.$watch('user', () ->
              element.hide()
              if $rootScope.user && $rootScope.user.permissions
                hasPermissions = true
                permissionsToCheck =
                  scope.topfriendsFacebookAuthorize.split(/,/g)

                for p in permissionsToCheck
                  if not $rootScope.user.permissions[p]?
                    hasPermissions &= false

                if not hasPermissions
                  bindAuth = (el) ->
                    el.find('.auth-button').click ->
                      FB.login(((response) ->
                        facebook.login(response, (data) ->
                          console.log data
                          $rootScope.user = data.user

                          return
                        )
                        return
                      ), scope: scope.topfriendsFacebookAuthorize)
                    return
                  if not element.hasClass('topfriends-facebook-authorize-ready')
                    element.addClass('topfriends-facebook-authorize-ready')
                    $http.get('/templates/facebook/authorize', {
                      cache: $templateCache
                    }).success((res) ->
                      el = $compile(res)(scope);
                      bindAuth(el)
                      el.insertAfter(element);
                    )
                else
                  if element.hasClass('topfriends-facebook-authorize-ready')
                    element.parent()
                    .find('.topfriends-facebook-authorize')
                    .remove()
                    element.removeClass('topfriends-facebook-authorize-ready')
                  element.show()
            )
        )
    ]