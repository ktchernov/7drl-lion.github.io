root = exports ? this

class StatusPresenter
  constructor: (@parent, @game) ->
    @level = $('<span/>', id: 'level').append '0'
    @race = $('<span/>', id: 'race').append ''
    @class = $('<span/>', id: 'class').append 'unknown'
      
    @gold = $("<span/>", id: 'gold').html 0

    @parent.append("Lvl ").append(@level).append(" ").append(@race).append(" ").append(@class).append("<br/><br/>GOLD ").append(@gold).append("<br/><br/>")

    @floor = $("<span/>", id: 'floor').html 0
    @exit_locked = $("<span/>", id: 'exit_locked').html 0
    @parent.append("FLOOR ").append(@floor).append("&nbsp;&nbsp;&nbsp;").append(@exit_locked)

  update: ->
    state = @game.state
    player = state._player

    unless player
      return

    @level.html player.level
    @race.html player.race.name
    @class.html player.class.name

    @floor.html state.floor
    @exit_locked.html if state.exit_locked then "Exit locked" else "Exit unlocked!"
    @gold.html "$#{player.gold}"

  _nbsp_pad: (str, n) ->
    _.str.rpad(str, n, "&").replace(/&/g, "&nbsp;")

  _bar: (klass, pct, length) ->
    num_bars = Math.round(pct * (length - 2))
    num_spaces = (length - 2) - num_bars

    bars = _.str.repeat "=", num_bars
    spaces = _.str.repeat "-", num_spaces

    "<span class='bar #{klass}'><span class='filled'>|#{bars}<span class='empty'>#{spaces}</span>|</span></span>"

root.StatusPresenter = StatusPresenter
