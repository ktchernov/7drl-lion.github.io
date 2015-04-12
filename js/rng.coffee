root = exports ? this

class RNG
  constructor: ->
    
  # Normal distribution (bell-curve), rounded to nearest whole number
  # and clamped at a max of 4 * stddev away from the mean, and a min of 0
  @clampedNormal: (mean, stddev) ->
    rand = ROT.RNG.getNormal  mean, stddev
    rand = Math.round rand
    rand = Math.min rand, Math.round mean + 4 * stddev
    rand = Math.max rand, Math.round mean - 4 * stddev
    rand = Math.max rand, 0
    rand

root.RNG = RNG