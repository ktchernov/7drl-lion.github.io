root = exports ? this

class OutputPresenter
  constructor: (@parent, @game) ->

  update: ->
    state = @game.state
    output = state.output

    @parent.html ""
    
    player = @game.player_actor;
    if !player
      return
    
    cur_turn = player.turn_count

    for i in [output.length-1..0] by -1
      entry = output[i]
      clazz = if cur_turn == entry.turn_count then 'entry' else 'oldEntry'
      @parent.append $('<div/>', class: clazz).html entry.message

root.OutputPresenter = OutputPresenter
