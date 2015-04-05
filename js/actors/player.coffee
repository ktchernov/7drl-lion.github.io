root = exports ? this

class Player extends Actor
  constructor: (id, scheduler, @engine, state, @on_update) ->
    super id, scheduler, state
    @turn_count = 0

  on_act: ->
    @engine.lock()
    @on_update()
    @turn_count++

    @accept_input = true

  on_key: (key, mods) ->
    return unless @acting
    success = false

    if key == 'escape'
      if @target_mode
        @state.msg @id, "Nevermind."

      @_clear_target()

      return false

    if not @target_mode or @target_mode == TARGET_NONE
      success = @_determine_action key, mods
    else if @target_mode == TARGET_DIR8
      success = @_choose_dir8_and_run key, mods
    else if @target_mode == TARGET_DIR4
      success = @_choose_dir4_and_run key, mods
    else if @target_mode == TARGET_FOV
      success = @_choose_fov_and_run key, mods
    else if @target_mode == TARGET_RANGE
      success = @_choose_range_and_run key, mods
    else if @target_mode == TARGET_MENU
      success = @_choose_menu_and_run key, mods

    @on_update()
    @_end() if success

  _determine_action: (key, mods) ->
    dir = @_get_direction key, mods
    if dir
      Action = get_action 'move_or_attack'
      action = new Action @id, @state
      return action.run dir

    else
      Action = switch key
        when 'space' then get_action 'wait'
        when '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'
          index = parseInt(key) - 1
          skills = @state.get_skills @id
          skill_definition = skills[index]
          if skill_definition
            Action = get_skill skill_definition.key
          else
            @state.msg @id, "You don't have that skill yet."

      return false unless Action

      action = new Action @id, @state

      if action.target == TARGET_NONE
        cost = action.mp ? 0
        if cost > @state.get_mp(@id)
          @state.msg @id, "You don't have enough mp."
          return false

        success = action.run()
        if success
          @state.remove_mp @id, cost

        return success

      else
        @_send_target_message action.target

        @target_mode = action.target
        @target_action = action
        @target_cost = (action.mp ? 0)

        return false

    false

  on_geas_done: ->
    @on_update()

  after_geas_run: ->
    @on_update()

  _choose_dir8_and_run: (key, mods) ->
    dir = @_get_direction key, mods
    if dir
      if @target_cost > @state.get_mp(@id)
        @state.msg @id, "You don't have enough mp."

        if @target_mode
          @_clear_target()

        false

      else
        success = @target_action.run dir
        if success
          @state.remove_mp @id, @target_cost

        else if @target_mode
          @state.msg @id, "Nevermind."

        @_clear_target()
        success

  _choose_dir4_and_run: (key, mods) ->
    dir = @_get_direction key, mods
    if dir and dir.length == 1
      @_choose_dir8_and_run key, mods

  _choose_fov_and_run: (key, mods) ->
  _choose_range_and_run: (key, mods) ->
  _choose_menu_and_run: (key, mods) ->

  _send_target_message: (target) ->
    switch target
      when TARGET_DIR8
        @state.msg @id, "Use movement keys to choose any direction."
      when TARGET_DIR4
        @state.msg @id, "Use movement keys to choose one of the four main directions."
      when TARGET_FOV
        @state.msg @id, "Use movement keys to highlight an empty, visible square and press ENTER to confirm."
      when TARGET_RANGE
        @state.msg @id, "Use movement keys to any square in range."

  _clear_target: ->
    @target_mode = null
    @target_action = null
    @target_cost = null

  _start: ->
    @engine.lock()

  _end: (val) ->
    @done val
    @engine.unlock()
    @accept_input = false

  _get_direction: (key, mods) ->
    switch key
      when 'up', 'k', 'num8' then dir = 'n'
      when 'u', 'num9' then dir = 'ne'
      when 'right', 'l', 'num6' then dir = 'e'
      when 'n', 'num3' then dir = 'se'
      when 'down', 'j', 'num2' then dir = 's'
      when 'b', 'num1' then dir = 'sw'
      when 'left', 'h', 'num4' then dir = 'w'
      when 'y', 'num7' then dir = 'nw'

register_actor 'player', Player
