root = exports ? this

class MapGenerator
  constructor: (@width, @height) ->

  run: (cb) ->
    percentile = ROT.RNG.getPercentage()
    if percentile < 50
      @digger = new RoguelikeMapGenerator @width, @height
    else if percentile < 70
      @digger = new MazeMapGenerator @width, @height
    else
      @digger = new CavernMapGenerator @width, @height
  
    @digger.build cb

root.MapGenerator = MapGenerator
