class Berserk extends Skill
  target: TARGET_NONE
  key: 'berserk'
  name: 'berserk'
  mp: 15
  cooldown: 10

  run: (dir) ->
    @add_geas @entity, 5, 'berserk'

register_skill 'berserk', Berserk
register_monster_skill 'berserk', Berserk
