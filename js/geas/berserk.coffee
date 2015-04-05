class Berserk extends Geas
  on_start: ->
    @state.msg @id, "You descend into a berserk rage."
    if @id == @state.player_id
      SoundEffects.get().play_berserk()

  on_run: ->
    adjacent = @state.get_adjacent_positions @id

    has_enemy = []
    _.each adjacent, (pos) =>
      has_enemy.push pos if @state.is_creature pos...

    if has_enemy.length > 0
      [i, j] = $(has_enemy).random_element()
      dir = @state.general_direction @id, i, j
      @execute_action 'attack', dir, mod: 2, flavor: "obliterate"

    else
      creature_id = @state.get_closest_creature @id, range: 6
      if creature_id
        dir = @state.general_direction @id, @state.get_pos creature_id

        @execute_action 'move', dir

  on_end: ->
    @state.msg @id, "The berserk rage lapses."

register_geas 'berserk', Berserk