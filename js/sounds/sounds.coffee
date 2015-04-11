root = exports ? this

class SoundEffects
  
  instance = null
  
  @get: () ->
    instance ?= new SoundEffectsPImpl
    
  class SoundEffectsPImpl
    constructor: () ->
      volume = 0.3
      deathVolume = volume + 0.15
      audioLibParams = {
        hit1 : ["noise",0.0000,volume,0.0000,0.0040,0.0000,0.1660,20.0000,936.0000,2400.0000,-0.3080,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0390,0.0000],
        hit2:  ["noise",0.0000,volume,0.0000,0.0040,0.0000,0.2700,20.0000,467.0000,2400.0000,-0.5300,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000],
        hit3:      ["noise",0.0000,volume,0.0000,0.0120,0.0000,0.1400,20.0000,948.0000,2400.0000,-0.5780,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.2360,0.0000]
        hit4: ["noise",0.0000,volume,0.0000,0.0300,0.0000,0.2520,20.0000,835.0000,2400.0000,-0.4200,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.1200,0.0000],
        death:        ["noise",0.0000,deathVolume,0.0000,0.3000,0.7380,1.1040,20.0000,1534.0000,2400.0000,-0.2580,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000]
        skill_gained: ["synth",0.0000,volume,0.0000,0.4000,0.0000,0.1520,20.0000,585.0000,2400.0000,0.1920,0.0000,0.3270,29.6678,0.0003,0.0000,0.0000,0.0000,0.5000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000],
        level_up: ["synth",0.0000,volume,0.0000,0.6240,0.0000,0.5360,20.0000,197.0000,2400.0000,0.3720,-0.3040,0.1980,18.7261,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000],
        alerted: ["square",0.0000,0.4000,0.0000,0.0800,0.4620,0.1260,20.0000,770.0000,2400.0000,0.0000,0.0000,0.0000,0.0100,0.0003,0.0000,0.3340,0.2380,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000]
      };
      @effects = jsfxlib.createWaves audioLibParams
      @effects["berserk"] = @load "media/effect_scream.mp3"
      @effects["restore1"] = @load "media/effect_restore1.mp3"
      @effects["restore2"] = @load "media/effect_restore2.mp3"
      @effects["clank"] = @load "media/effect_clank.mp3"
      @effects["cleave"] = @load "media/effect_cleave.mp3"
      @effects["use_skill"] = @load "media/effect_grunt.mp3"
      @effects["descend"] = @load "media/effect_jump_down.mp3"
      @effects["dig"] = @load "media/effect_dig.mp3"
      @effects["dig_rubble"] = @load "media/effect_dig_rubble.mp3"
      
    load: (url) ->
      new Howl {urls: [url]}

    play_berserk: ->
      @effects.berserk.play()
      
    play_skill_used: ->
      @effects.cleave.play()
      
    play_skill_gained: ->
      @effects.skill_gained.play()
      
    play_level_up: ->
      @effects.level_up.play()
            
    play_clank: ->
      # play after a delay, otherwise there are too many things happening
      delayedClank = setInterval =>
        @effects.clank.play()
        clearInterval delayedClank
      , 1000
      
    play_descend: ->
      @effects.descend.play()
        
    play_restore_hp: ->
      @effects.restore2.play()
      
    play_restore_mp: ->
      @effects.restore1.play()
    
    play_dig_rubble: ->
      @effects.dig_rubble.play()
    
    play_dig: ->
      @effects.dig.play()
      
    play_hit: ->  
      percentile = ROT.RNG.getPercentage()
      if percentile < 25
        @effects.hit1.play()
      else if percentile < 50
        @effects.hit2.play()
      else if percentile < 75
        @effects.hit3.play()
      else
        @effects.hit4.play()
        
    play_death: () ->
      @effects.death.play()
      
      
      
    
    
root.SoundEffects = SoundEffects