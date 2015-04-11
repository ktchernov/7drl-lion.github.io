class Dragon extends Race
  key: 'dragon'
  name: 'dragon'

  alignments: ['good', 'neutral', 'evil']
  base_hp: 40
  base_mp: 20
  base_speed: 175
  base_attack: 15
  base_sight_range: 10
  
  for_player: true

  skills: []

register_race Dragon
