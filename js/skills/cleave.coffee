class Cleave extends Skill
  target: TARGET_DIR8
  key: "cleave"
  name: "cleave"
  mp: 4
  cooldown: 4

  run: (dir) ->
    dirs = [dir, @state.rotate_right(dir), @state.rotate_left(dir)]

    positions = []
    $.each dirs, (i, dir) =>
      positions.push @state.get_adjacent_pos @id, dir

    attack = @state.get_attack @id
    attack = Math.ceil(attack * 0.50)

    success = false
    $.each positions, (i, pos) =>
      [x, y] = pos

      target_id = @state.get_by_pos x, y
      if target_id
        actor_short = @state.get_short_description @id
        target_short = @state.get_short_description target_id

        @state.msg @id, "You cleave #{target_short}."
        @state.msg target_id, "#{_.str.capitalize(actor_short)}'s cleaves you!"

        @state.damage target_id, attack

        if @state.is_dead target_id
          @state.msg @id, "You killed #{target_short}!"
          @state.msg target_id, "You are dead!"

          @state.remove target_id

        success = true
        
    if success && @id == @state.player_id
      SoundEffects.get().play_skill_used()

    success

register_skill 'cleave', Cleave
register_monster_skill 'cleave', Cleave
