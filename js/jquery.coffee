$.fn.times = (fn) ->
  n = $(@)[0]
  fn(i) for i in [0...n]

$.fn.random_element = (fn) ->
  ary = $(@)
  idx = ROT.RNG.getUniformInt(0, ary.length - 1)
  @[idx]

$.fn.all = (cb) ->
  all = true

  @each ->
    unless cb(@, @)
      all = false
      return false

  all

$.fn.any = (cb) ->
  any = false

  @each ->
    if !!cb(@, @)
      any = true
      return false

  any
