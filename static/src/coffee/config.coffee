'use strict'
require.config
  baseUrl: 'assets/js'
  optimize: 'none'
  paths:
    'index': 'index'
    'socket': 'socket'
    'json3': '../components/json3/lib/json3.min'
    'jquery': '../components/jquery/dist/jquery.min'
    'underscore': '../components/lodash/dist/lodash.compat.min'
    'angular': '../components/angular/angular.min'
    'ngRoute': '../components/angular-route/angular-route.min'
    'ngAnimate': '../components/angular-animate/angular-animate.min'
    'topfriends.utils': 'topfriends/utils'
    'topfriends.error': 'topfriends/error'
    'comet': 'comet'
    'topfriends.facebook': 'topfriends/facebook'
    'topfriends.topchat': 'topfriends/topchat'
    'bootstrap': '../components/bootstrap/dist/js/bootstrap'
    'bootstrap.dropdown': '../components/bootstrap/js/dropdown'
    'bootstrap.tooltip': '../components/bootstrap/js/tooltip'
    'sifter': '../libs/selectize/sifter.min'
    'microplugin': '../libs/selectize/microplugin.min'
    'bootstrap.selectize': '../libs/selectize/selectize.min'
    'facebook': 'https://connect.facebook.net/en_US/all'
    'pnotify': '../libs/pnotify/jquery.pnotify.min'
    'translate': 'translate'
  shim:
    'underscore':
      deps: []
      exports: '_'
    'facebook':
      exports: 'FB'
    'pnotify':
      deps: [
        'jquery'
      ]
    'angular':
      deps: [
        'jquery',
        'underscore'
      ]
      exports: 'angular'
    'ngRoute':
      deps: [
        'angular'
      ]
    'ngAnimate':
      deps: [
        'angular'
      ]
    'bootstrap':
      deps: ['jquery']
    'bootstrap.dropdown':
      deps: ['jquery', 'bootstrap']
    'bootstrap.tooltip':
      deps: ['jquery', 'bootstrap']
    'bootstrap.selectize':
      deps: ['jquery', 'bootstrap']
  deps: [
    'translate'
    'index'
  ]
