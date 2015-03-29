root = exports ? this

class MapGenerator
  WALL_CHANCE = 0.1

  constructor: (@width, @height) ->

  run: (cb) ->
    @digger = new ROT.Map.Rogue @width, @height
    @build_floor cb

  build_floor: (cb) ->

    @digger.create (x, y, value) ->
      if (!value)
        cb y, x, FLOORS, 'floor'
      else
        cb y, x, WALLS, 'wall'


root.MapGenerator = MapGenerator
