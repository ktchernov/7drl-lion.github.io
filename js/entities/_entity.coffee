root = exports ? this

class Entity
  constructor: (opts={}) ->
    @id = opts.id

    @x = opts.x
    @y = opts.y

    @level = opts.level
    @xp = 0
    @rarity = opts.rarity

    @alignment = opts.alignment
    @gender = opts.gender
    @race = opts.race
    @class = opts.class

    @base_attack = opts.base_attack
    @attack = @base_attack

    @base_speed = opts.base_speed
    @speed = @base_speed

    @base_hp = opts.base_hp
    @max_hp = @base_hp
    @hp = @max_hp

    @base_mp = opts.base_mp
    @max_mp = @base_mp
    @mp = @max_mp

    @short_description = "a #{@race.name} #{@class.name}"

    @dead = opts.dead

    @skills = []
    @_add_skills opts.skills
    
    @surge_grant_chance = opts.surge_grant_chance
    @kill_score = opts.kill_score
    @kill_xp = opts.kill_xp
    
    @score = 0


  pos: -> [@x, @y]
  set_pos: (@x, @y) ->

  level_up: ->
    @level += 1
    @xp = 0

    gained = @_level_up_stat 'max_hp', 'base_hp'
    @hp += gained

    gained = @_level_up_stat 'max_mp', 'base_hp'
    @mp += gained

    @_level_up_stat 'attack', 'base_attack'
    @_level_up_speed()

  add_skill: (key) ->
    Skill = get_skill key

    unless Skill
      throw new Error "Could not find skill with key: #{key}"

    skill = new Skill null, null

    @skills.push
      key: key
      name: skill.name
      mp: skill.mp
      base_cooldown: skill.cooldown
      cooldown_timer: 0

  _level_up_stat: (name, base_name) ->
    gained = Math.ceil(@[base_name] * 0.03333)
    @[name] += gained

    gained

  _level_up_speed: ->
    @speed = Math.ceil(@speed * 0.96667)

  _add_skills: (skills) ->
    _.each skills, (key) =>
      @add_skill key

root.Entity = Entity
