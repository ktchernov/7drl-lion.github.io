root = exports ? this

class MazeMapGenerator
  CRUMBLE_CHANCE = 10

  constructor: (@width, @height) ->
    @_digger = new ROT.Map.IceyMaze @width, @height, ROT.RNG.getUniformInt(3,8)

  build: (cb) ->
    map = []

    @_digger.create (x, y, value) =>
      map[y * @width + x] = value
    
    @_build_crumbly_walls map
    
    for y in [0..@height-1] by 1
      for x in [0..@width-1] by 1
        value = map[y * @width + x]
        if(value == 1)
          cb y, x, WALLS, 'wall'
        else if (value == 2)
          cb y, x, WALLS, 'crumble'
        else
          cb y, x, FLOORS, 'floor'
    
  _build_crumbly_walls: (map) ->
    for y in [1..@height-2] by 1
      for x in [1..@width-2] by 1
        if @_good_to_crumble map, x, y
          map[y * @width + x] = 2
      
    true
    
  _good_to_crumble: (map, x, y) ->
    return false unless map[y * @width + x]
    
    conditions_met = () =>
      num_empty = 0
      for i in [x-1..x+1] by 1
        for j in [y-1..y+1] by 1
          num_empty++ unless map[j * @width + i]
          return true if num_empty >= 4
    
    if conditions_met()
      rand = ROT.RNG.getPercentage()
      return true if rand <= CRUMBLE_CHANCE
    
    false
    
    
root.MazeMapGenerator = MazeMapGenerator