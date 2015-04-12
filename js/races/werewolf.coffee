class Werewolf extends Race
  key: 'werewolf'
  name: 'werewolf'

  alignments: ['neutral', 'evil']
  rarity: ['uncommon', 'rare']
  base_hp: 20
  base_mp: 20
  base_speed: 100
  base_attack: 10
  base_sight_range: 10
  for_player: false

  skills: [
    "berserk"
  ]

register_race Werewolf
