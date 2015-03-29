root = exports ? this

class SkillsPresenter
  constructor: (@parent, @game) ->
    @skills = []
    @skill_costs = []
    @lastNewSkill = 0
    @lastNewSkillTime = 0

    $(10).times (i) =>
      cost = $('<span/>', class: 'cost')
      cost.append " ("
      skill_cost = $('<span/>', id: "skill_#{i}_cost").html "0 mp"
      cost.append skill_cost
      cost.append ")"

      skill = $('<div />', class: 'skill')
      skill.append "#{(i + 1) % 10}: "
      skill_name = $('<span/>', id: "skill_#{i}", class: 'disabled').html 'none'
      skill.append skill_name
      skill.append cost

      @parent.append skill

      @skills.push skill_name
      @skill_costs.push skill_cost

  update: ->
    state = @game.state
    player = state._player

    unless player
      return

    skills = player.skills
    
    newSkillCount = skills.length

    $(10).times (i) =>
      skill = skills[i]

      if skill
        @skills[i].removeClass 'disabled'
        if (i > @lastNewSkill)
          @skills[i].addClass 'new'
          nowTime = (new Date).getTime()
          if (@lastNewSkillTime == 0)
            @lastNewSkillTime = nowTime
          
          if (nowTime - @lastNewSkillTime > 1000 * 10)
            @skills[i].removeClass 'new'
            @lastNewSkillTime = 0
            @lastNewSkill = skills.length
            

        @skills[i].html skill.name

        if skill.mp > player.mp
          @skill_costs[i].addClass 'invalid'
        else
          @skill_costs[i].removeClass 'invalid'

        @skill_costs[i].html "#{skill.mp} mp"

      else
        @skills[i].addClass 'disabled'
        @skills[i].html 'none'
        @skill_costs[i].removeClass 'invalid'
        @skill_costs[i].html "0 mp"
        


root.SkillsPresenter = SkillsPresenter
