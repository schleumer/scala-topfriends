define [
  'angular'
  'socket.io'
], (angular, io) ->
  socket = angular.module('socket', [])
  socket.factory "socket",
    ['$rootScope', '$location', ($rootScope, $location) ->
      (address) ->
        socket = io.connect(address)
        if socket.socket.connected
          socket.socket.disconnect()
          socket.socket.reconnect()
        #socket.socket.connect(address)

        socket.on('error', (info) ->
          $location.path("/error")
            .search(info)
            .replace()
          $rootScope.$apply();
          return
        )

        on: (eventName, callback) ->
          socket.on eventName, ->
            args = arguments
            $rootScope.$apply ->
              callback.apply socket, args

        emit: (eventName, data, callback) ->
          socket.emit eventName, data, ->
            args = arguments
            $rootScope.$apply ->
              callback.apply socket, args  if callback
    ]
  return