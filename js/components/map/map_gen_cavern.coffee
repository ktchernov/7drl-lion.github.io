root = exports ? this

class CavernMapGenerator

  constructor: (@width, @height) ->
    @_digger = new ROT.Map.Cellular @width-2, @height-2,
      {
        connected:true
      }
    @_digger.randomize 0.4

  build: (cb) ->
    #walls around edges first - Cellular gen does not generate them
    for x in [0..@width-1] by 1
      for y in [0, @height-1]
        cb y, x, WALLS, 'wall'
        
    for x in [0, @width-1]
      for y in [1 .. @height-2] by 1
        cb y, x, WALLS, 'wall'
    
    
    @_digger.create (x, y, value) =>
      if(value == 1)
        cb y+1, x+1, WALLS, 'wall'
      else
        cb y+1, x+1, FLOORS, 'floor'
    
    
    
root.CavernMapGenerator = CavernMapGenerator