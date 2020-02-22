require "./test/test_helper"
require "./lib/stat_tracker"
require "./lib/game_collection"
require 'mocha/minitest'
require "CSV"

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
  end

  def test_it_can_create_games_from_csv
    game = mock('game')
    @game_collection.stubs(:games).returns(game)

    assert_equal game, @game_collection.games
  end

end
