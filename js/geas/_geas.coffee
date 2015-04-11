root = exports ? this

class Geas
  constructor: (@duration, @entity, @state) ->
    if @entity
      @id = @entity.id

  active: ->
    @duration > 0

  start: ->
    @on_start()

  end: ->
    @on_end()

  run: ->
    @duration -= 1
    if @state.exists @id
      @on_run()
    else
      @duration = 0
      
    if @duration <= 0
      @on_end()

  on_start: ->
  on_end: ->
  on_run: ->

  execute_action: (name, args...) ->
    Action = get_action name
    action = new Action @entity, @state
    action.run args...

geass = []
geass_by_key = {}

register_geas = (key, geas) ->
  r = geas

  geass.push r
  geass_by_key[key] = r

list_geass = ->
  geass

get_geas = (key) ->
  geass_by_key[key]

root.Geas = Geas
root.register_geas = register_geas
root.list_geass = list_geass
root.get_geas = get_geas
