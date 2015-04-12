root = exports ? this

class HelpPresenter
  constructor: (@parent, @game) ->
    @one_time = false

    @parent.html "Move: <br />" +
      "&nbsp;&nbsp;* <b>arrow keys, num pad, or</b><br />" +
      "&nbsp;&nbsp;* <b>hjkl</b> and <b>yubn</b><br />" +
      "<br />" +
      "Dig (walls or rubble): <b>D</b><br />" +
      "<br />" +
      "Wait: <b>space</b><br />" +
      "<br />" +
      "Skills: <b>1-9</b> and <b>0</b><br />" +
      "<br />" +
      "GOALS:<br />" +
      "&nbsp;&nbsp;* collect <b>gold</b><br />" +
      "&nbsp;&nbsp;* <b>kill the boss</b> to go down<br />" +
      "&nbsp;&nbsp;* use your <b>skills</b><br />" +
      "&nbsp;&nbsp;* enemies may grant <b>healing</b><br />" +
      "&nbsp;&nbsp;* kill all enemies for a <b>full heal</b><br />"

root.HelpPresenter = HelpPresenter
