root = exports ? this

class GamePresenter
  constructor: (@game) ->
    @map_presenter = new MapPresenter $('#map'), @game
    @help_presenter = new HelpPresenter $('#help'), @game
    @skills_presenter = new SkillsPresenter $('#skills'), @game
    @points_presenter = new PointsPresenter $('#points'), @game
    @output_presenter = new OutputPresenter $('#output'), @game
    @status_presenter = new StatusPresenter $('#status'), @game
    @intro_presenter = new IntroPresenter $('#intro'), $('#intro_overlay'), @game
    @menu_presenter = new MenuPresenter $('#menu'), $('#menu_title'), $('#menu_content'), $('#menu_overlay'), @game
    @game_over_presenter = new GameOverPresenter $('#game_over'), $('#game_over_overlay'), @game

  update: ->
    @map_presenter.update()
    @skills_presenter.update()
    @points_presenter.update()
    @output_presenter.update()
    @status_presenter.update()
    @intro_presenter.update()
    @menu_presenter.update()
    @game_over_presenter.update()

root.GamePresenter = GamePresenter