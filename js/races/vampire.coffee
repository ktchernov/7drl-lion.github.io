class Vampire extends Race
  key: 'vampire'
  name: 'vampire'

  alignments: ['evil']
  rarity: ['uncommon', 'rare']
  base_hp: 15
  base_mp: 15
  base_speed: 120
  base_attack: 15
  base_sight_range: 10
  for_player: false
  
  can_get_through_rubble: true

  skills: []

register_race Vampire
