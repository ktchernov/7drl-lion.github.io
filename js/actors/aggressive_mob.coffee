root = exports ? this

class AggressiveMob extends Actor
  
  constructor: (entity, scheduler, @engine, state) ->
    super entity, scheduler, state
    @_is_alerted = false

  on_act: ->
    @state.get_entity
    
    @engine.lock()

    player_id = @state.player_id
    if @state.exists player_id
      [mi, mj] = @state.get_pos @id
      [ti, tj] = @state.get_pos player_id
      
      do_pathfinding = @_is_alerted
      
      unless do_pathfinding
        do_pathfinding = @_is_within_sight_range mi, mj, ti, tj
        
      unless do_pathfinding
        @_move_randomly()

      else
        pathfinder = new ROT.Path.AStar ti, tj, (i, j) =>
          if @entity.get_through_rubble
            not @state.is_wall(i, j) or @state.is_rubble(i, j)
          else
            not @state.is_wall i, j

        path = []
        [i, j] = @state.get_pos @id
        pathfinder.compute i, j, (x, y) =>
          path.push [x, y]
          
        if path.length <= @entity.sight_range and path.length != 0
          @_is_alerted = true

        if not @_is_alerted or path.length == 0
          @_move_randomly()
          
        else if path.length == 2
          @_attack path

        else
          dir = @state.general_direction @id, path[1]...
          @_move dir

    @done()
    @engine.unlock()
    
  alert_by_sound: ->
    if @_is_alerted
      @_is_alerted = true
    else
      false

  _move_randomly: ->
    dir = $(['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw']).random_element()
    @_move dir
    
  _attack: (path) ->
    dir = @state.general_direction @id, path[1]...
    if ROT.RNG.getUniform() < 0.2
      @_use_skill dir
    else
      @_move_or_attack dir
    
  _use_skill: (dir) ->
    skills = @state.get_skills @id
    skill_definition = $(skills).random_element()

    return unless skill_definition

    Skill = get_skill skill_definition.key
    skill = new Skill @entity, @state

    if skill.target == TARGET_DIR8
      skill.run dir

    else if skill.target == TARGET_NONE
      skill.run()

  _move_or_attack: (dir) ->
    @execute_action 'move_or_attack', dir

  _move: (dir) ->
    @execute_action 'move', dir
    
  _is_within_sight_range: (mi, mj, ti, tj) ->
    idiff = ti-mi
    jdiff = tj-mj
    
    if idiff <= @entity.sight_range and jdiff <= @entity.sight_range
      distance_sq = idiff*idiff + jdiff*jdiff
      sight_range_sq = @entity.sight_range * @entity.sight_range
      distance_sq <= sight_range_sq
    else
      # fewer calculations
      false


register_actor 'aggressive', AggressiveMob
