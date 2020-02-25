require "./test/test_helper"
require "./lib/stat_tracker"
require "./lib/game_collection"
require 'mocha/minitest'
require './lib/game'

class GameCollectionTest < Minitest::Test

  def setup
    @game_collection = GameCollection.new("./test/fixtures/games_truncated.csv")
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end
  
  def test_it_has_attributes
    assert_instance_of Array, @game_collection.games
    assert_equal 10, @game_collection.games.length
    assert_instance_of Game, @game_collection.games.first
    assert_instance_of Game, @game_collection.games.first
  end

  def test_it_can_create_games_from_csv
    game1 = @game_collection.games.first
    game2 = @game_collection.games.last

    assert_instance_of Game, game1
    assert_equal 2, game1.away_goals
    assert_equal 3, game1.away_team_id
    assert_equal "5/16/13", game1.date_time
    assert_equal 3, game1.home_goals
    assert_equal 6, game1.home_team_id
    assert_equal 0, game1.id
    assert_equal "20122013", game1.season
    assert_equal "Postseason", game1.type

    assert_instance_of Game, game2
    assert_equal 3, game2.away_goals
    assert_equal 16, game2.away_team_id
    assert_equal "4/18/14", game2.date_time
    assert_equal 2, game2.home_goals
    assert_equal 19, game2.home_team_id
    assert_equal 0, game2.id
    assert_equal "20132014", game2.season
    assert_equal "Postseason", game2.type
  end

end
