root = exports ? this

create_map = ->
  content = $('<div/>', id: 'map', class: 'map_content')
  $('<div/>', class: 'map').append(content)

create_status = ->
  content = $('<div/>', id: 'status', class: 'content')
  $('<div/>', class: 'status').append(content)

create_help = ->
  title = $('<div/>', class: 'title').html 'Help'
  content = $('<div/>', id: 'help', class: 'content')
  $('<div/>', class: 'help').append(title).append(content)

create_skills = ->
  title = $('<div/>', class: 'title').html 'Skills'
  content = $('<div/>', id: 'skills', class: 'content')
  $('<div/>', class: 'skills').append(title).append(content)

create_output = ->
  content = $('<div/>', id: 'output', class: 'content')
  $('<div/>', class: 'output').append(content)

create_output = ->
  content = $('<div/>', id: 'output', class: 'content')
  $('<div/>', class: 'output').append(content)

create_points = ->
  content = $('<div/>', id: 'points', class: 'content')
  $('<div/>', class: 'points').append(content)
  
create_intro = ->
  $('<div/>', id: 'intro')

create_intro_overlay = ->
  $('<div/>', id: 'intro_overlay', class: 'overlay')

create_menu = ->
  title = $('<div/>', id: 'menu_title', class: 'title').html ''
  content = $('<div/>', id: 'menu_content', class: 'content')
  $('<div/>', id: 'menu', class: 'menu').append(title).append(content)

create_menu_overlay = ->
  $('<div/>', id: 'menu_overlay', class: 'overlay')

create_game_over = ->
  $('<div/>', id: 'game_over')

create_game_over_overlay = ->
  $('<div/>', id: 'game_over_overlay', class: 'overlay')

create_layout = ->
  game = $('#game')

  $(game).append create_map()
  $(game).append create_status()
  $(game).append create_help()
  $(game).append create_skills()
  $(game).append create_output()
  $(game).append create_points()
  $(game).append create_intro_overlay()
  $(game).append create_intro()
  $(game).append create_menu_overlay()
  $(game).append create_menu()
  $(game).append create_game_over()
  $(game).append create_game_over_overlay()

root.create_layout = create_layout
