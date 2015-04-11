class Human extends Race
  key: 'human'
  name: 'human'

  alignments: ['good', 'neutral', 'evil']
  base_hp: 20
  base_mp: 20
  base_speed: 100
  base_attack: 10
  base_sight_range: 8
  for_player: true

  skills: []

register_race Human
