jQuery(function($) {
  var index = 0,
  PAUSE_COOKIE = 'paused',
  VOLUME_COOKIE = 'volume',
  COOKIE_EXPIRY_DAYS = 30,
  mediaPath = 'media/',
  tracks = [
    {file:"Rah Rah Rah.mp3", track: "Rah Rah Rah", artist: "RPG-H8R", link: "http://freemusicarchive.org/music/rpg-h8r/" },
    {file:"Bonus Life.mp3", track: "Bonus Life", artist: "Radarsat-1", link: "http://freemusicarchive.org/music/Radarsat-1/"},
    {file:"Ragnarock.mp3", track: "Ragnarock", artist: "Fengir", link: "http://freemusicarchive.org/music/Fengir/"},
    {file:"Rouge.mp3", track: "Rouge", artist: "Raw Stiles", link: "http://freemusicarchive.org/music/Raw_Stiles/"},
    {file:"Them Never Love No Bans.mp3", track:"Them Never Love No Bans - DnB Mix (Germany)", artist: "Hot Fire", link: "http://freemusicarchive.org/music/Hot_Fire/"}

  ],
  trackCount = tracks.length,
  audio = $('#musicAudio').bind('play', function() {
    playing = true;
    $.removeCookie(PAUSE_COOKIE);
  }).bind('pause', function() {
    playing = false;
    $.cookie(PAUSE_COOKIE, 'true', {expiry: COOKIE_EXPIRY_DAYS} );
  }).bind('ended', function() {
    var prevIndex = 0;
    index = ROT.RNG.getUniformInt(0, tracks.length - 1);
    if (index == prevIndex) {
      index = (index + 1) % trackCount;
    }
    loadTrack(index);
    audio.play();
  }).bind('volumechange ', function() {
    $.cookie(VOLUME_COOKIE, audio.volume, {expiry: COOKIE_EXPIRY_DAYS});
  }).get(0),
  currentTrack = $('#currentTrack'),
  currentArtist = $('#currentArtist'),
  loadTrack = function(id) {
    index = id;
    audio.src = mediaPath + tracks[id].file;
    currentTrack.html(0).html(tracks[id].track);
    currentArtist.html(0).html(tracks[id].artist);
    currentArtist.attr('href', tracks[id].link);
  };
  loadTrack(index);
  volume = $.cookie(VOLUME_COOKIE);
  if (volume === undefined) {
    volume = 0.6;
  }
  audio.volume = volume;
  
  if ( ! $.cookie(PAUSE_COOKIE)) {
    audio.play();
  }
});