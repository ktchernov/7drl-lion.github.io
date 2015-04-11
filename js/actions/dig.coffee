class Dig extends Action
  target: TARGET_DIR8
  CRUMBLE_SUCCESS_CHANCE=75
  HARD_ROCK_SUCCESS_CHANCE=40
  CRUMBLE_SOUND_ALERT_RANGE=12
  HARD_WALL_ALERT_RANGE=18

  run: (dir) ->
    [i, j] = @state.get_adjacent_pos @id, dir

    unless @state.is_wall i, j
      @state.msg @id, "You dig at the thin air, that'll show 'em!"
    else if @state.is_crumbly i, j
      @_dig_crumble i,j
    else 
      @_dig_hard_rock i,j
    
    true
    
  _dig_crumble: (i, j) ->
    @_alert_enemies i, j, CRUMBLE_SOUND_ALERT_RANGE
    if ROT.RNG.getPercentage() < CRUMBLE_SUCCESS_CHANCE
      @state.msg @id, "You have dug throug the rubble!"
      @state.remove_crumble i, j
      SoundEffects.get().play_dig_crumble()
    else
      @state.msg @id, "You chip away at the rubble. Need to put more muscle into it."
      
      
  _dig_hard_rock: (i, j) ->
    @_alert_enemies i, j, HARD_WALL_ALERT_RANGE
    if ROT.RNG.getPercentage() < HARD_ROCK_SUCCESS_CHANCE
      @state.msg @id, "You chip away at the hard rock wall, cracks are beginning to show!"
      @state.make_crumble i, j
      SoundEffects.get().play_dig_crumble()
    else
      @state.msg @id, "You slowly chip away at the hard rock wall, you may need to do this for a while..." 
      SoundEffects.get().play_dig()
  
  _alert_enemies: (i, j, range) ->
    nearby_creatures = @state.get_nearby_creatures @id, {range: range}
    for creature in nearby_creatures
      creature.alert_by_sound()
    @state.msg @id, "Alerted #{nearby_creatures.length} creatures"

register_action 'dig', Dig