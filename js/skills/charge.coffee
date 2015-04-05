class Charge extends Skill
  target: TARGET_DIR8
  key: 'charge'
  name: 'charge'
  mp: 8
  cooldown: 5

  run: (dir) ->
    [i, j] = @state.get_pos @id

    [x, y] = @state.find_in_direction i, j, dir, (x, y, n) =>
      @state.is_blocked_in_dir(x, y, dir) or n >= 6

    return false if x == i and y == j

    actor_short = @state.get_short_description @id

    @state.msg @id, "You shout wildly and charge!"
    @state.shout_by @id, "#{_.str.capitalize(actor_short)} shouts wildly and charges!"

    @state.set_pos @id, x, y
    @execute_action 'attack', dir
    
    if @id == @state.player_id
      SoundEffects.get().play_skill_used()

    true

register_skill 'charge', Charge
