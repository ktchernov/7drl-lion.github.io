root = exports ? this

class OutputPresenter
  constructor: (@parent, @game) ->

  update: ->
    state = @game.state
    output = state.output

    @parent.html ""

    for i in [output.length-1..0] by -1
      entry = output[i]
      clazz = if i == (output.length - 1) then 'entry' else 'oldEntry'
      @parent.append $('<div/>', class: clazz).html entry

root.OutputPresenter = OutputPresenter
