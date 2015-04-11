root = exports ? this

class Race  
  constructor: ->

races = []
races_by_key = {}

register_race = (race) ->
  r = new race

  races.push r
  races_by_key[r.key] = r

list_races = (options) ->
  if options.player
    _.filter races, (race) ->
      race.for_player
  else
    races

list_races_for_alignment = (alignment) ->
  _.filter races, (race) ->
    _.contains race.alignments, alignment

get_race = (key) ->
  races_by_key[key]

root.Race = Race
root.register_race = register_race
root.list_races = list_races
root.list_races_for_alignment = list_races_for_alignment
root.get_race = get_race
