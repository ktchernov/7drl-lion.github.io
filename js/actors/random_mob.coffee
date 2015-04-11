root = exports ? this

class RandomMob extends Actor
  constructor: (entity, scheduler, @engine, state) ->
    super entity, scheduler, state

  on_act: ->
    @engine.lock()
    @_move_or_attack @_random_direction()
    @done()
    @engine.unlock()

  _random_direction: ->
    $(['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw']).random_element()

  _move_or_attack: (dir) ->
    @execute_action 'move_or_attack', dir

register_actor 'random', RandomMob
