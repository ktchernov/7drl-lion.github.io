root = exports ? this

FLOOR_REPS =
  empty: { rep:' ', color:[0,0,0] }
  floor: { rep:'.', color:[51, 51, 51] }
  entrance: { rep:'<', color:[80, 80, 80] }
  exit: { rep:'>', color:[0, 255, 255] }

WALL_REPS =
  wall: { rep:'#', color:[102, 102, 102] }

CREATURE_REPS =
  player: '@'
  angel: 'a'
  catfolk: 'c'
  centaur: 'C'
  demon: 'd'
  dragon: 'D'
  dragonkin: 'k'
  dwarf: 'w'
  elf: 'e'
  gnome: 'g'
  giant: 'G'
  hobbit: 'i'
  human: 'h'
  shapeshifter: 's'
  werewolf: 'w'

CREATURE_COLORS =
  player: [255, 255, 255]
  trash: [80, 80, 50]
  uncommon: [80, 50, 255]
  rare: [255, 0, 0]
  
DISPLAY_ALL = false # debug flag to show full map

class MapPresenter
  constructor: (@parent, @data_parent) ->
   
    @state = @data_parent.state
    
    font_family = @parent.css "font-family"
    font_family ?= "monospace"
    
    @display = new ROT.Display {
      width: @state.map_width,
      height: @state.map_height,
      fontSize: 14,
      fontFamily: font_family,
      bg: "#000000",
      layout: 'rect'
    }
    @parent.append @display.getContainer()
    
    @_prev_seen = {}
    @_prev_seen_floor = @state.floor
    
  
  _light_passes: (y, x) =>
    not @state.is_wall y, x
    
  _reflectivity: (y, x) =>
    if @state.is_wall(y, x) then 0.0 else 1.0

  update: ->
    unless @data_parent.map_ready
      @parent.hide()
      return

    state = @data_parent.state

    @parent.show()

    @display.clear()

    light_map = {}
    fov_map = {}
    
    player = state.player_id
    return unless @state.exists player

    [pi,pj] = state.get_pos player
    
    height = state.map_height
    width = state.map_width
    
        
    _fov = new ROT.FOV.PreciseShadowcasting @_light_passes, topology: 8
    _lighting = new ROT.Lighting @_reflectivity, range: 4, passes: 1

    _fov.compute pi, pj, 8, (y, x, r, visibility) ->
      fov_map[y*width + x] = visibility

          
    _light_fov = new ROT.FOV.PreciseShadowcasting @_light_passes, topology: 4
    _lighting.setFOV _light_fov

    _lighting.setLight pi, pj, [255, 255, 255]

    _lighting.compute (y, x, color) ->
      light_map[y*width + x] = color

    ambient_light = [200, 200, 200]
    prev_seen_light = [100, 100, 100]
    
    if @_prev_seen_floor != @state.floor
      @_prev_seen = {}
      @_prev_seen_floor = @state.floor
      
    if DISPLAY_ALL
      for y in [0..height-1] by 1
        for x in [0..width-1] by 1
          r = @convert @state.get_data(y, x)
          base_color = r.color
          light = ambient_light

          posIx = y * width + x
          
          if light_map[posIx]
            light = ROT.Color.add light, light_map[posIx]

          final_color = ROT.Color.multiply base_color, light

          @display.draw x,  y, r.rep, ROT.Color.toRGB final_color
          
      return
    
    $.each @_prev_seen, (posIx) =>
      unless posIx of fov_map
        x = posIx % width
        y = (posIx - x) / width

        r = @convert @state.get_data(y, x), true
        base_color = r.color
        final_color = ROT.Color.multiply base_color, prev_seen_light
        @display.draw x,  y, r.rep, ROT.Color.toRGB final_color
          
    
    $.each fov_map, (posIx) =>
      @_prev_seen[posIx] = 1

      x = posIx % width
      y = (posIx - x) / width
      
      r = @convert @state.get_data(y, x)
      base_color = r.color
      light = ambient_light

      if light_map[posIx]
        light = ROT.Color.add light, light_map[posIx]

      final_color = ROT.Color.multiply base_color, light

      @display.draw x,  y, r.rep, ROT.Color.toRGB final_color
        

        
  convert: (stack, no_creatures) ->
    rep = FLOOR_REPS['empty']

    if stack[FLOORS]
      rep = FLOOR_REPS[stack[FLOORS]]
      throw new Error("Could not find rep for '#{stack[FLOORS]}'") unless rep

    if stack[WALLS]
      rep = WALL_REPS[stack[WALLS]]
      throw new Error("Could not find rep for '#{stack[WALLS]}'") unless rep

    unless no_creatures
      if stack[CREATURES]
        entity = stack[CREATURES]
        is_player = entity.id == @state.player_id
        key = if is_player then 'player' else entity.race.key
        rep = { rep: CREATURE_REPS[key], color: CREATURE_COLORS[entity.rarity] }
        throw new Error("Could not find rep for '#{key}'") unless rep.rep and rep.color

    rep

root.MapPresenter = MapPresenter
