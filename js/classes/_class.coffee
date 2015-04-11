root = exports ? this

class Class
  constructor: ->

classes = []
classes_by_key = {}

register_class = (klass) ->
  c = new klass

  classes.push c
  classes_by_key[c.key] = c

list_classes = ->
  classes

list_classes_for_race = (race) ->
  _.filter classes, (klass) ->
    _.contains(klass.races, race)

list_classes_for_alignment_and_race = (alignment, race) ->
  _.filter classes, (klass) ->
    _.contains(klass.alignments, alignment) and _.contains(klass.races, race)

get_class = (key) ->
  classes_by_key[key]

root.Class = Class
root.register_class = register_class
root.list_classes = list_classes
root.list_classes_for_race = list_classes_for_race
root.list_classes_for_alignment_and_race = list_classes_for_alignment_and_race
root.get_class = get_class
