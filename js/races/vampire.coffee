class Vampire extends Race
  key: 'vampire'
  name: 'vampire'

  alignments: ['evil']
  base_hp: 15
  base_mp: 15
  base_speed: 100
  base_attack: 15
  base_sight_range: 10
  for_player: false
  
  can_get_through_rubble: true

  skills: []

register_race Vampire
