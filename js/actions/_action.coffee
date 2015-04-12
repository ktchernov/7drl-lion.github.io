root = exports ? this

TARGET_NONE =  0
TARGET_DIR8 = 1
TARGET_DIR4 = 2
TARGET_FOV = 3
TARGET_RANGE = 4
TARGET_MENU = 5

class Action
  target: TARGET_NONE
  constructor: (@entity, @state) ->
    if @entity
      @id = @entity.id

  add_geas: (@entity, duration, name) ->
    id = @entity.id
    Geas = get_geas name
    geas = new Geas duration, @entity, @state
    actor = @state.get_actor id
    actor.add_geas geas

  execute_action: (name, args...) ->
    Action = get_action name
    action = new Action @entity, @state
    action.run args...

actions = []
actions_by_key = {}

register_action = (key, action) ->
  r = action

  actions.push r
  actions_by_key[key] = r

list_actions = ->
  actions

get_action = (key) ->
  actions_by_key[key]

root.Action = Action
root.register_action = register_action
root.list_actions = list_actions
root.get_action = get_action

root.TARGET_NONE = TARGET_NONE
root.TARGET_DIR8 = TARGET_DIR8
root.TARGET_DIR4 = TARGET_DIR4
root.TARGET_FOV = TARGET_FOV
root.TARGET_RANGE = TARGET_RANGE
root.TARGET_MENU = TARGET_MENU
