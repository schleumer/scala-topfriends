define [
  'angular'
  'bootstrap'
  'bootstrap.selectize'
], (angular) ->
  utils = angular.module('topfriends.utils', [])
  utils.directive 'schDropdown', () ->
    return link: (scope, element) ->
      unless element.hasClass('has-dropdown')
        $(element).dropdown().addClass('has-dropdown')

  utils.directive 'coolSelect', () ->
    return (
      require: 'ngModel',
      scope: 
        ngModel: '='
      link: (scope, element) ->
        scope.$watch 'ngModel', (val) ->
          element.selectize({
              create: true
          });
          return
        return
    )

  utils.directive 'schAccountCreation', () ->
    return (
      restrict: 'E',
      templateUrl: '/templates/utils/account_creation',
      replace: true,
      scope:
        type: '@',
        label: '@'
      link: (scope, element) ->
        element.find(".modal-trigger").click () ->
          element.find(".modal").modal({
            keyboard: true,
            backdrop: true
          })

        scope.hide = () ->
          console.log(element.find(".modal.in"))
          element.find(".modal.in").modal('hide')
          return
        return    
    )

  utils.directive 'schAccountLogin', () ->
    return (
      restrict: 'E',
      templateUrl: '/templates/utils/account_login',
      replace: true,
      scope:
        type: '@',
        label: '@'
      link: (scope, element) ->
        element.find(".modal-trigger").click () ->
          element.find(".modal").modal({
            keyboard: true,
            backdrop: true
          })

        scope.hide = () ->
          console.log(element.find(".modal"))
          element.find(".modal").modal('hide')
          return
        return    
    )

  utils.directive 'schTooltip', () ->
    return (
      scope:
        schTooltip: '='
        schTooltipPlacement: '@'
      link: (scope, element) ->
        scope.$watchCollection("[schTooltipPlacement, schTooltip]", () ->
          console.log scope.schTooltipPlacement
          $(element).tooltip('destroy')
          $(element).tooltip({
            container:'body',
            placement: scope.schTooltipPlacement
          })
        )

    )