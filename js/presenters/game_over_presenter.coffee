root = exports ? this

class GameOverPresenter
  constructor: (@parent, @overlay, @game) ->

  update: ->
    state = @game.state
    player = state._player

    if not player or state.exists player.id
      @parent.html ""
      @parent.hide()
      @overlay.hide()
      return

    @parent.show()
    @overlay.show()

    status = "<div class='title'>REST IN PEACE</div>" +
    "<div class='content'>" +
    "You were a <b>#{player.race.name} #{player.class.name}</b>.<br /><br />" +
    "Your corpse decorates Floor <b>#{state.floor}</b>.<br /><br />" +
    "You were level <b>#{player.level}</b>.<br />" +
    "You knew <b>#{player.skills.length}</b> skills.<br />" +
    "<br />" +
    "<br />" +
    "<br />" +
    "<a href='#' id='restart_link'>RESTART</a>"
    "</div>"

    @parent.html status
    $("#restart_link").click =>
      location.reload()
    
    
    SoundEffects.get().play_death();

root.GameOverPresenter = GameOverPresenter
