root = exports ? this

class AggressiveMob extends Actor
  MAX_RANGE = 12
  
  constructor: (id, scheduler, @engine, state) ->
    super id, scheduler, state
    @alerted_by_sound = false
    @sight_range_sq = 6 * 6

  on_act: ->
    @engine.lock()

    player_id = @state.player_id
    if @state.exists player_id
      [mi, mj] = @state.get_pos @id
      [ti, tj] = @state.get_pos player_id

      alerted = @alerted_by_sound
      
      if (!alerted)
        idiff = Math.abs(ti-mi)
        jdiff = Math.abs(tj-mj)
        distance_sq = idiff*idiff + jdiff*jdiff
        alerted = distance_sq <= @sight_range_sq

      unless alerted
        @_move_randomly()

      else
        pathfinder = new ROT.Path.AStar ti, tj, (i, j) =>
          not @state.is_wall i, j

        path = []
        [i, j] = @state.get_pos @id
        pathfinder.compute i, j, (x, y) =>
          path.push [x, y]

        if path.length == 0
          @_move_randomly()
          
        else if path.length == 2
          dir = @state.general_direction @id, path[1]...
          if ROT.RNG.getUniform() < 0.2
            @_use_skill dir
          else
            @_move_or_attack dir

        else if not @alerted_by_sound and path.length > MAX_RANGE
          @_move_randomly()
          
        else
          dir = @state.general_direction @id, path[1]...
          @_move dir

    @done()
    @engine.unlock()
    
  alert_by_sound: ->
    @alerted_by_sound = true
    SoundEffects.get().play_alerted()

  _move_randomly: ->
    dir = $(['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw']).random_element()
    @_move dir

  _use_skill: (dir) ->
    skills = @state.get_skills @id
    skill_definition = $(skills).random_element()

    return unless skill_definition

    Skill = get_skill skill_definition.key
    skill = new Skill @id, @state

    if skill.target == TARGET_DIR8
      skill.run dir

    else if skill.target == TARGET_NONE
      skill.run()

  _move_or_attack: (dir) ->
    @execute_action 'move_or_attack', dir

  _move: (dir) ->
    @execute_action 'move', dir

register_actor 'aggressive', AggressiveMob
