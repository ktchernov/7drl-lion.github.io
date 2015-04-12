root = exports ? this

class MenuPresenter
  KEY_STRINGS = {
    'base_hp': "Hit Points (HP)",
    'base_mp':  "Magic Points (MP)",
    'base_speed':  "Speed",
    'base_attack': "Attack",
    'base_sight_range': "Sight Range"
  }
  
  constructor: (@parent, @title, @content, @overlay, @menu_parent) ->

  update: ->
    menu = @menu_parent.menu

    if menu
      @show_menu true

      @title.html menu.title
      @content.html @make_choices menu, menu.choices

    else
      @show_menu false

  show_menu: (val=true) ->
    if val
      $(@parent).show()
      $(@overlay).show()
    else
      $(@parent).hide()
      $(@overlay).hide()

  make_choices: (menu, choices) ->
    content = []

    $.each choices, (i, data) =>
      content.push @make_choice menu, data...

    content

  make_choice: (menu, key, option) ->
    opt = $ '<div/>', class: 'menu_option', id: "option_#{key}"
    opt.html "#{key}: "

    link = $('<a/>', href: "#").html option.name
    link.click -> menu.choose key

    opt.append link
    
    tip_content = @_get_tip_content option
    
    opt.miniTip({
      title: _.str.capitalize(option.name),
      content: tip_content,
      anchor: 'w',
      maxW: '350px'
    });
    
  _get_tip_content: (option) ->
    content = ""
    for key, value of option
      if KEY_STRINGS.hasOwnProperty key
        key_str = KEY_STRINGS[key]
        prefix = if value >= 0 then '+' else ''
        content += "#{key_str}:&nbsp;&nbsp;#{prefix}#{value}<br/>"
    content
    

root.MenuPresenter = MenuPresenter
