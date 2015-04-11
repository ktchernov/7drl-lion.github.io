class Move extends Action
  target: TARGET_DIR8

  run: (dir) ->
    [i, j] = @state.get_adjacent_pos @id, dir

    if @_can_move_to i, j 
      @state.set_pos @id, i, j
      @state.set_off_triggers @id
      
      if @id != @state.player_id and @state.is_rubble(i,j) and @state.is_visible_to_player(i,j)
        actor_short = @state.get_short_description @id
        @state.msg @state.player_id, "#{_.str.capitalize(actor_short)} glides through the rubble!"

      true

    else if @state.is_rubble i, j
      @state.msg @id, "Pile of rocks blocks your way, digging might help."
      false
    else
      @state.msg @id, "You can't go that way."
      false
      
  _can_move_to: (i,j) ->
    if @entity.get_through_rubble
      !@state.is_creature(i, j) and ( @state.is_rubble(i,j) or not @state.is_wall(i, j) )
    else
      !@state.is_blocked i, j

register_action 'move', Move
