root = exports ? this

class GameOverPresenter
  HIGH_SCORE_COOKIE = "high_score"
  COOKIE_EXPIRY_DAYS = 365 * 2
  
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
    
    prev_high_gold = $.cookie HIGH_SCORE_COOKIE
    prev_high_gold ?= 0
    new_gold = player.gold
    
    if (prev_high_gold < new_gold)
      prev_high_gold = new_gold
      $.cookie HIGH_SCORE_COOKIE, new_gold, {expires: COOKIE_EXPIRY_DAYS }

    status = "<div class='title'>REST IN PIECES</div>" +
    "<div class='content'>" +
    "GOLD: <b>$#{new_gold}</b><br/><br/>" +
    "HIGHSCORE: <b>$#{prev_high_gold}</b><br/><br/>" +
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
