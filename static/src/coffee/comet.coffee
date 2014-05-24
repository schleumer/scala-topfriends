define [
  'angular'
], (angular, io) ->
  socket = angular.module('comet', [])
  socket.factory "$comet",
    ['$rootScope', '$location', ($rootScope, $location) ->
      (address, cb, data) ->
        fnName = _.uniqueId("cb_fn_krl_")
        id = _.uniqueId("krl-")

        if not window.cb
          window.cb = {}
        window.cb[fnName] = (xd) ->
          xd = JSON.parse(xd)
          $rootScope.$apply(() ->
            cb(xd.type, xd.message)
          )
          return
        
        if data
          iframe = angular.element('<iframe/>', {
            'id': id
            'name': id
          }).hide()

          form = angular.element('<form/>', {
            'id': "form-#{id}"
            'method': 'POST'
            'target': id
            'action': address.replace(":cbFn", fnName)
          })

          form.append(angular.element('<input/>', {
            'type': 'hidden'
            'name': 'data'
            'value': JSON.stringify(data)
          }))

          angular.element('body').append(iframe)
          angular.element('body').append(form)
          form.submit()

        else
          iframe = angular.element('<iframe/>', {
            'id': id
            'src': address.replace(":cbFn", fnName)
          }).hide()
          angular.element('body').append(iframe)

        return {
          dispose: ()->
            iframe.remove()
            return
        }
    ]
  return