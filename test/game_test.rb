require 'CSV'
require './lib/game_collection'
require "./test/test_helper"
require "./lib/game"

class GameTest < Minitest::Test

  def setup
    game_data_template = {
      id:           2012030221,
      season:       20122013,
      type:         "Postseason",
      date_time:    "5/16/13",
      away_team_id: 3,
      home_team_id: 6,
      away_goals:   2,
      home_goals:   3,
      venue:        "Toyota Stadium",
      venue_link:   "/api/v1/venues/null"
    }

    game_data1 = game_data_template.clone
    game_data1[:away_goals] = 3
    game_data1[:home_goals] = 2

    game_data2 = game_data_template.clone
    game_data2[:away_goals] = 1
    game_data2[:home_goals] = 4

    game_data3 = game_data_template.clone
    game_data3[:away_goals] = 2
    game_data3[:home_goals] = 2


    @game1 = Game.new(game_data1)
    @game2 = Game.new(game_data2)
    @game3 = Game.new(game_data3)
  end

  def test_it_exists
    assert_instance_of Game, @game1
  end

  def test_it_has_attributes

    assert_equal 2012030221,            @game1.id
    assert_equal 20122013,              @game1.season
    assert_equal "Postseason",          @game1.type
    assert_equal "5/16/13",             @game1.date_time
    assert_equal 3,                     @game1.away_team_id
    assert_equal 6,                     @game1.home_team_id
    assert_equal 3,                     @game1.away_goals
    assert_equal 2,                     @game1.home_goals
    assert_equal "Toyota Stadium",      @game1.venue
    assert_equal "/api/v1/venues/null", @game1.venue_link

  end

  def test_it_can_return_total_goals
    assert_equal 5, @game1.total_goals
  end

  def test_home_win
    assert_equal false, @game1.home_win?
    assert_equal true, @game2.home_win?
    assert_equal false, @game3.home_win?
  end

  def test_away_win
    assert_equal true, @game1.away_win?
    assert_equal false, @game2.away_win?
    assert_equal false, @game3.away_win?
  end

  def test_it_checks_tie
    assert_equal false, @game1.tie?
    assert_equal false, @game2.tie?
    assert_equal true, @game3.tie?
  end
end
