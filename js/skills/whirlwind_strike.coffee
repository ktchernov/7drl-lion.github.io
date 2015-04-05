class WhirlwindStrike extends Skill
  target: TARGET_NONE
  key: "whirlwind_strike"
  name: "whirlwind strike"
  mp: 10
  cooldown: 5

  run: ->
    positions = @state.get_adjacent_positions @id

    attack = @state.get_attack @id
    attack = Math.ceil(attack * 0.25)

    $.each positions, (i, pos) =>
      [x, y] = pos

      target_id = @state.get_by_pos x, y
      if target_id
        actor_short = @state.get_short_description @id
        target_short = @state.get_short_description target_id

        @state.msg @id, "You hit #{target_short}."
        @state.msg target_id, "#{_.str.capitalize(actor_short)}'s whirlwind strike hits you!"

        @state.damage target_id, attack

        if @state.is_dead target_id
          @state.msg @id, "You killed #{target_short}!"
          @state.msg target_id, "You are dead!"

          @state.remove target_id
          
        if @id == @state.player_id
          SoundEffects.get().play_skill_used()
          
        true

    true

register_skill 'whirlwind_strike', WhirlwindStrike
register_monster_skill 'whirlwind_strike', WhirlwindStrike
