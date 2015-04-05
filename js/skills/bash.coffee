class Bash extends Skill
  target: TARGET_DIR8
  key: 'bash'
  name: 'bash'
  mp: 3
  cooldown: 2

  run: (dir) ->
    [i, j] = @state.get_adjacent_pos @id, dir
    target_id = @state.get_by_pos i, j

    return unless target_id

    [ni, nj] = @state.get_adjacent i, j, dir
    if @state.is_blocked ni, nj
      @execute_action 'attack', dir, mod: 1.4, flavor: 'bash'

      target2_id = @state.get_by_pos ni, nj
      if target2_id
        @state.damage target2_id, (@state.get_attack(@id) * 0.2)
        @state.msg target2_id, "Something bashes into you."

    else
      @execute_action 'attack', dir, mod: 0.8, flavor: 'push'

      if @state.exists target_id
        @state.set_pos target_id, ni, nj

      @state.set_pos @id, i, j

    if @id == @state.player_id
      SoundEffects.get().play_skill_used()

    true

register_skill 'bash', Bash
register_monster_skill 'bash', Bash
