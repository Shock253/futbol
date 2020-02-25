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

  def test_it_can_calculate_highest_total_score
    assert_equal 7, @game_collection.highest_total_score
  end

  def test_it_can_calculate_lowest_total_score
    assert_equal 3, @game_collection.lowest_total_score
  end

  def test_it_can_calculate_biggest_blowout
    assert_equal 2, @game_collection.biggest_blowout
  end

  def test_it_can_calculate_percentage_home_wins
    assert_equal 0.4, @game_collection.percentage_home_wins
  end

  def test_it_can_calculate_percentage_visitor_wins
    assert_equal 0.5, @game_collection.percentage_visitor_wins
  end

  def test_it_can_calculate_percentage_ties
    assert_equal 0.1, @game_collection.percentage_ties
  end

  def test_it_calculate_count_of_games_by_season
    expected = {
      "20122013"=>5,
      "20172018"=>2,
      "20162017"=>1,
      "20152016"=>1,
      "20132014"=>1
    }
    assert_equal expected, @game_collection.count_of_games_by_season
  end

  def test_it_calculate_average_goals_per_game
    assert_equal 4.7, @game_collection.average_goals_per_game
  end

  def test_it_calculate_average_goals_by_season
    expected = {
      "20122013"=>4.4,
      "20172018"=>4.0,
      "20162017"=>5.0,
      "20152016"=>7.0,
      "20132014"=>5.0
    }
    assert_equal expected, @game_collection.average_goals_by_season
  end

end
