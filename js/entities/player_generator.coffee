root = exports ? this

class PlayerGenerator extends EntityGenerator
  generate: (gender, race, klass) ->
    skill = $(list_skill_keys()).random_element()

    new Entity
      id: @generate_id()
      x: 0, y: 0
      level: 1
      gender: gender
      race: race
      class: klass
      base_attack: gender.base_attack + race.base_attack + klass.base_attack
      base_speed: gender.base_speed + race.base_speed + klass.base_speed
      base_hp: gender.base_hp + race.base_hp + klass.base_hp
      base_mp: gender.base_mp + race.base_mp + klass.base_mp
      dead: false
      rarity: 'player'
      skills: [skill]
      sight_range: gender.base_sight_range + race.base_sight_range + klass.base_sight_range
      can_pick_up_gold: true
      can_pick_up_potions: true

root.PlayerGenerator = PlayerGenerator