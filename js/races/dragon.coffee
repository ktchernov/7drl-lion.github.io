class Dragon extends Race
  key: 'dragon'
  name: 'dragon'

  alignments: ['good', 'neutral', 'evil']
  rarity: ['uncommon', 'rare']
  base_hp: 30
  base_mp: 20
  base_speed: 130
  base_attack: 15
  base_sight_range: 10
  
  for_player: false

  skills: []

register_race Dragon
