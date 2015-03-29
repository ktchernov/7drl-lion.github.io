root = exports ? this

class SoundEffects
  
  instance = null
  
  @get: () ->
    instance ?= new SoundEffectsPImpl;
    
  class SoundEffectsPImpl
    constructor: () ->
      volume = 0.35;
      deathVolume = volume + 0.15;
      audioLibParams = {
        hit1 : ["noise",0.0000,volume,0.0000,0.0040,0.0000,0.1660,20.0000,936.0000,2400.0000,-0.3080,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0390,0.0000],
        hit2:  ["saw",0.0000,volume,0.0000,0.0600,0.0000,0.2040,20.0000,371.0000,2400.0000,-0.5180,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000],
        hit3:      ["square",0.0000,volume,0.0000,0.0620,0.0000,0.2240,20.0000,520.0000,2400.0000,-0.5580,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.5000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.1840,0.0000]
        hit4: ["noise",0.0000,volume,0.0000,0.0300,0.0000,0.2520,20.0000,835.0000,2400.0000,-0.4200,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.1200,0.0000],
        death:        ["noise",0.0000,deathVolume,0.0000,0.3000,0.7380,1.1040,20.0000,1534.0000,2400.0000,-0.2580,0.0000,0.0000,0.0100,0.0003,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1.0000,0.0000,0.0000,0.0000,0.0000]
      };
      @effects = jsfxlib.createWaves audioLibParams;

    play_hit: () ->
      percentile = Math.floor(Math.random() * 100)
      if percentile < 25
        @effects.hit1.play();
      else if percentile < 50
        @effects.hit2.play();
      else if percentile < 75
        @effects.hit3.play();
      else
        @effects.hit4.play();
        
    play_death: () ->
      @effects.death.play();
    
root.SoundEffects = SoundEffects