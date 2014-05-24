window.__ = (str) ->
  return str

window.coolNumber = (number) ->
  return number if number < 1000
  return Math.round(number / 1000) + __('mil') if number < 1000000
  return Math.round(number / 1000000) + __('mi') if number < 1000000000
  return Math.round(number / 1000000000) + __('bi') if number < 1000000000000
  return Math.round(number / 1000000000000) + __('tri') if number < 1000000000000000
  return number