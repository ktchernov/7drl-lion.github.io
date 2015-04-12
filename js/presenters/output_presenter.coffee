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
      clazz = 'entry'
      if cur_turn == entry.turn_count
        if i == output.length-1
          clazz = 'newestEntry'
      else
        clazz = 'oldEntry'
      
      @parent.append $('<div/>', class: clazz).html entry.message

root.OutputPresenter = OutputPresenter
