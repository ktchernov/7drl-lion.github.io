root = exports ? this

class GameOverPresenter
  @HIGH_SCORE_COOKIE = "high_score"
  
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
    
    prev_high_score = $.cookie GameOverPresenter.HIGH_SCORE_COOKIE
    prev_high_score ?= 0
    new_score = player.score
    
    if (prev_high_score < new_score)
      prev_high_score = new_score
      $.cookie(GameOverPresenter.HIGH_SCORE_COOKIE, new_score, {expires: 365 } )

    status = "<div class='title'>REST IN PIECES</div>" +
    "<div class='content'>" +
    "SCORE: <b>" + new_score + "</b><br/><br/>" +
    "HIGHSCORE: <b>" + prev_high_score + "</b><br/><br/>" +
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
