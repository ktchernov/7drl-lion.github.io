root = exports ? this

class IntroPresenter
  
  constructor: (@parent, @overlay, @game) ->

  update: ->
    unless @game.should_show_intro
      @parent.hide()
      @overlay.hide()
      return
    
    @parent.show()
    @overlay.show()

    status = "<div class='title'>DIG DEEP</div>" +
    "<div class='content'>" +
    "<p>You stumble upon a dark cave full of monsters...</p>" +
    "<p>There is nothing else to do, except...</p>" +
    "<p><b>Dig</b> as deep as you can,</p>" +
    "<p>Collect as much <b class='gold'>gold</b> as you can,</p>" +
    "<p><b>BASH THE MONSTERS TO A PULP AS YOU GO!</b></p>" +
    "<br/><br/><a href='#' id='continue_link'>BEGIN</a>"
    "</div>"

    @parent.html status
    $("#continue_link").click =>
      @game.hide_intro()

root.IntroPresenter = IntroPresenter
