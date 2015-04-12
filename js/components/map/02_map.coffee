root = exports ? this

class Map
  constructor: (@width, @height, @num_layers) ->
    @layers = []
    @items = {}

    $(@num_layers).times (n) =>
      @layers[n] = []

      $(@height).times (i) =>
        @layers[n][i] = Array(@width)

        $(@width).times (j) =>
          @layers[n][i][j] = null

  each: (fn) ->
    $(@height).times (i) =>
      $(@width).times (j) =>
        fn i, j

  at: (i, j, n, val) ->
    @get_tile(i, j, n) == val

  exists: (i, j, n) ->
    @get_tile(i, j, n) != null

  get_stack: (i, j) ->
    return [] if @out_of_bounds i, j

    stack = Array(@num_layers)
    for l in [0..@num_layers-1] by 1
      stack[l] = @get_tile i, j, l
    stack

  get_tile: (i, j, n) ->
    return if @out_of_bounds i, j, n
    @layers[n][i][j]

  set_tile: (i, j, n, val) ->
    return if @out_of_bounds i, j, n
    @layers[n][i][j] = val

  swap_tile: (oi, oj, i, j, n) ->
    tile = @get_tile oi, oj, n
    tile2 = @get_tile i, j, n

    @set_tile i, j, n, tile
    @set_tile oi, oj, n, tile2

  clear_tile: (i, j, n) ->
    @set_tile i, j, n, null

  clear: ->
    $(@num_layers).times (n) =>
      @clear_layer n

  clear_layer: (n) ->
    $(@height).times (i) =>
      $(@width).times (j) =>
        @layers[n][i][j] = null
        
  set_item: (i, j, val) ->
    items[i * @width + j] = val

  out_of_bounds: (i, j, n) ->
    bad_i = (i and i < 0 or i >= @height)
    bad_j = (j and j < 0 or j >= @width)
    bad_n = (n and n < 0 or n >= @num_layers)

    bad_i or bad_j or bad_n

root.Map = Map
