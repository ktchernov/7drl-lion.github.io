class Attack extends Action
  target: TARGET_DIR8

  run: (dir, opts={}) ->
    opts.mod ?= 1
    opts.flavor ?= 'attack'

    [i, j] = @state.get_adjacent_pos @id, dir
    attack = @state.get_attack @id
    attack = Math.round(attack * opts.mod)

    target_id = @state.get_by_pos i, j
    if target_id
      actor_short = @state.get_short_description @id
      target_short = @state.get_short_description target_id

      @state.msg @id, "You #{opts.flavor} #{target_short}."
      
      #workaround "demolish" is not displayed correctl if you just tag on the 's'
      opts.flavor = "#{opts.flavor}e" if _.str.endsWith opts.flavor, "sh"
        
      @state.msg target_id, "#{_.str.capitalize(actor_short)} #{opts.flavor}s you!"

      @state.damage target_id, attack
      
      SoundEffects.get().play_hit();

      if @state.is_dead target_id
        @state.msg @id, "You killed #{target_short}!"
        @state.msg target_id, "You are dead!"

        @state.remove target_id

      true

register_action 'attack', Attack
