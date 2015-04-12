root = exports ? this

class Game
  
  constructor: () ->
    @state = new GameState 80, 24

    @update_callbacks = []

    @scheduler = new ROT.Scheduler.Action()
    @engine = new ROT.Engine @scheduler

  on_key: (args...) ->
    if @menu
      @menu.on_key args...

    else if @player_actor
      @player_actor.on_key args...

  start: ->
    @prompt_character()

  prompt_character: ->
    @prompt_gender (gender) =>
      @prompt_race (race) =>
        @prompt_class race, (klass) =>
          @create_player gender, race, klass
          @new_floor()

  prompt_gender: (cb) ->
    @show_menu new Menu "Choose your gender: ", list_genders(), (gender) =>
      @show_menu null
      cb gender

  prompt_race: (cb) ->
    @show_menu new Menu "Choose your race: ", list_races({player: true}), (race) =>
      @show_menu null
      cb race

  prompt_class: (race, cb) ->
    @show_menu new Menu "Choose your class: ", list_classes_for_race(race.key), (klass) =>
      @show_menu null
      cb klass

  show_menu: (menu) ->
    @menu = menu
    @update()

  create_player: (gender, race, klass) ->
    player_entity = @state.generate_player gender, race, klass
    @player_id = player_entity.id

    Player = get_actor 'player'
    @player_actor = new Player player_entity, @scheduler, @engine, @state, => @update()
    @scheduler.add @player_actor, true, 0
    @state.register_actor @player_id, @player_actor

    @player_actor.on_remove =>
      @state.msg @player_id, 'GAME OVER!'
      @update()

      @scheduler.clear()
      @state.unregister_actor @player_id
      @player_actor = null

    @engine.start()

  on_update: (fn) ->
    @update_callbacks.push fn
    fn()

  update: ->
    $.each @update_callbacks, -> @()

  new_floor: ->
    @state.next_floor()
    @state.generate_cave()

    [i, j] = @state.random_empty_space()
    @state.add_entrance i, j
    @state.set_pos @player_id, i, j

    @_generate_enemies()
    @_generate_gold()
    @_generate_potions()

    [i, j] = @state.random_empty_space()
    @state.add_exit i, j
    @state.add_trigger i, j, (id) =>
      if id == @state.player_id
        if @state.exit_locked
          @state.msg @player_id, 'The exit is locked. You must find and defeat the boss of this level to proceed.'
        else
          SoundEffects.get().play_descend()
          @new_floor()

    @map_ready = true
    @update()
    
  _generate_gold: ->
    NUM_PILES_MEAN = 4
    NUM_PILES_STDDEV = 1.5
    GOLD_AMOUNT_BASE_MEAN = 50
    
    num_gold = RNG.clampedNormal NUM_PILES_MEAN, NUM_PILES_STDDEV
    
    gold_amount_mean = GOLD_AMOUNT_BASE_MEAN
    gold_amount_mean += gold_amount_mean * (@state.floor - 1) * 0.2
    gold_amount_stddev = gold_amount_mean / 3
    
    $(num_gold).times =>
      [i, j] = @state.random_empty_space()
      gold_amount = RNG.clampedNormal gold_amount_mean, gold_amount_stddev
      @state.put_gold i, j, gold_amount
      
  _generate_potions: ->
    NUM_POTIONS_MEAN = 3
    NUM_POTIONS_STDDEV = 0.75
    HP_POTION_CHANCE = 70
    
    num_potions = RNG.clampedNormal NUM_POTIONS_MEAN, NUM_POTIONS_STDDEV
    
    $(num_potions).times =>
      [i, j] = @state.random_empty_space()
      type  = if ROT.RNG.getPercentage() <= 70 then 'hp' else 'mp'
      @state.put_potion i, j, type

  _generate_enemies: ->
    num_trash = RNG.clampedNormal 15, 1
    num_uncommon = RNG.clampedNormal 5, 1
    
    $(num_trash).times => @_generate_trash()
    $(num_uncommon).times => @_generate_uncommon()
    @_generate_boss()
    
  _generate_trash: ->
    monster_entity = @state.generate_monster 'trash'
    @_make_actor monster_entity, =>
      @_grant_kill_bonuses(monster_entity)
      @update()

    [x, y] = @state.random_empty_space()
    @state.set_pos monster_entity.id, x, y

  _generate_uncommon: ->
    monster_entity = @state.generate_monster 'uncommon'
    @_make_actor monster_entity, =>
      @_grant_kill_bonuses(monster_entity)
      @update()

    [x, y] = @state.random_empty_space()
    @state.set_pos monster_entity.id, x, y

  _generate_boss: ->
    monster_entity = @state.generate_monster 'rare'
    @_make_actor monster_entity, =>
      @_grant_kill_bonuses(monster_entity)
      @_grant_skill()

      @state.unlock_exit()
      @state.msg @player_id, 'You hear a loud CLANK in the distance. (Do you dare delve deeper?)'
      SoundEffects.get().play_clank()

      @update()

    [x, y] = @state.random_empty_space()
    @state.set_pos monster_entity.id, x, y
    
  _grant_kill_bonuses: (monster_entity) ->
      @_surge monster_entity.surge_grant_chance
      @_grant_gold monster_entity.gold
      @_grant_xp monster_entity.kill_xp
      @_check_full_surge()

  _grant_skill: ->
    skills = @state.get_skills @player_id
    all_skills = list_skill_keys()

    skill_set = {}
    _.each skills, (skill) -> skill_set[skill.key] = true

    new_skills = []
    _.each all_skills, (skill) ->
      new_skills.push skill unless skill_set[skill]

    return if new_skills.length == 0

    new_skill = $(new_skills).random_element()

    @state.msg @player_id, "You learn #{new_skill}!"
    @state.give_skill @player_id, new_skill

  _surge: (chance) ->
    return unless Math.random() < chance

    r = Math.random()
    if r < 0.4 then @_health_surge()
    else if r < 0.8 then @_magic_surge()
    else
      @_health_surge()
      @_magic_surge()

  _check_full_surge: ->
    @_full_surge() if @state.monster_count() == 0

  _full_surge: ->
    @state.restore_hp @player_id, @state.get_max_hp @player_id
    @state.restore_mp @player_id, @state.get_max_mp @player_id
    @state.msg @player_id, 'With all the enemies vanquished, you are able to rest. Health and magic restored.'

  _health_surge: ->
    @state.restore_hp @player_id, 10
    @state.msg @player_id, 'You feel a surge of healing energy.'

  _magic_surge: ->
    @state.restore_mp @player_id, 10
    @state.msg @player_id, 'You feel a surge of magic energy.'

  _grant_xp: (xp) ->
    @state.grant_xp @player_id, xp
    
  _grant_gold: (gold) ->
    @state.grant_gold @player_id, gold

  _make_actor: (entity, kill_callback) ->
    kill_callback ?= ->

    AggressiveMob = get_actor 'aggressive'
    monster_actor = new AggressiveMob entity, @scheduler, @engine, @state
    @scheduler.add monster_actor, true, 0
    @state.register_actor entity.id, monster_actor

    monster_actor.on_remove =>    
      @scheduler.remove monster_actor
      @state.unregister_actor entity.id
      
      kill_callback()


root.Game = Game
