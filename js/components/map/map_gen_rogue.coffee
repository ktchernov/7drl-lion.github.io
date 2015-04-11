root = exports ? this

class RoguelikeMapGenerator
  RUBBLE_CHANCE = 30
  RUBBLE_WEAK_CHANCE = 10

  constructor: (@width, @height) ->
    @_digger = new ROT.Map.Rogue @width, @height

  build: (cb) ->
    map = []

    @_digger.create (x, y, value) =>
      map[y * @width + x] = value
    
    @_build_rubble_walls map
    
    for y in [0..@height-1] by 1
      for x in [0..@width-1] by 1
        value = map[y * @width + x]
        if(value == 1)
          cb y, x, WALLS, 'wall'
        else if (value == 2)
          cb y, x, WALLS, 'rubble'
        else
          cb y, x, FLOORS, 'floor'
    
  _build_rubble_walls: (map) ->
    for y in [1..@height-2] by 1
      for x in [1..@width-2] by 1
        if @_good_to_rubble map, x, y
          map[y * @width + x] = 2
      
    true


  _good_to_rubble: (map, x, y) =>

    check_map = (x, y) =>
      map[y * @width + x]

    return false if check_map x, y


#        // NOTE:
#        // rect-neighbours just denotes neighbours that are either N/W/S/E


#      /*
#       * 1. check for rect-neighbouring doors, if exist => do not place door
#       * 2. check for pairs rect-opposite blanks, if more than 2 => do not place
#       * 3. check for diagonal neighbours, if none exist => do not place
#       * 4. then a random chance of placing a door
#       * 
#       * STRONG satisfaction has NO diagonal door neighbours
#       */

    neighbourBlanks=0 # number of neighbous that are blanks
    pairsOpps = 0 # pairs of rect-opposite blanks
    hasDiagonals=false # blank neighbours on diagonals
    strong=true

  # check west amd east squares square
    sqr1 = check_map(x-1,y)
    sqr2 = check_map(x+1, y)
    if(sqr2 == 2 || sqr1 == 2)
      return false

#          // check for blanks on either side
    if( !sqr1 && !sqr2)
      pairsOpps++
      neighbourBlanks+=2
    else if( !sqr1 || !sqr2 )
      neighbourBlanks++


#        // check north amd spitj squares
    sqr1 = check_map(x,y-1)
    sqr2 = check_map(x, y+1)
    if(sqr2 == 2 || sqr1 == 2)
      return false

#        // check for blanks on either side
    if( !sqr1 && !sqr2 )
      pairsOpps++
      neighbourBlanks+=2
    else if( !sqr1 || !sqr2 )
      neighbourBlanks++

#          // more than one rect-opposite pair or more than 2 rect-neighbours
    if( pairsOpps!=1 || neighbourBlanks!=2 )
      return false

#        // now check diagonals

    sqr1 = check_map(x-1,y-1)  # NW
    if( sqr1 == 2)
      strong=false
    
    if( sqr1 != 1 )
      hasDiagonals=true

    sqr1 = check_map(x+1,y-1)  # NE
    if( sqr1 != 1 )
      hasDiagonals=true
    if( sqr1 == 2)
      strong=false

    sqr1 = check_map(x+1,y+1)  # SE
    if( sqr1 != 1 )
      hasDiagonals=true
    if( sqr1 == 2)
      strong=false

    sqr1 = check_map(x-1,y+1)  # SW
    if( sqr1 != 1 )
      hasDiagonals=true
    if( sqr1 == 2)
      strong=false

    # all conditions met for door to be built
    if(hasDiagonals)
      rand = ROT.RNG.getPercentage()

      if strong
        if rand <= RUBBLE_CHANCE
          return true
      if rand <= RUBBLE_WEAK_CHANCE
        return true

    return false


root.RoguelikeMapGenerator = RoguelikeMapGenerator
