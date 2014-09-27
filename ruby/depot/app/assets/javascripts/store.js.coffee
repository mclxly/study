# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready", ->
  $('.store .entry > img').click ->
    console.log('a')
    $(this).parent().find(':submit').click()