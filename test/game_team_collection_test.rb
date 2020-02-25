require "./test/test_helper"
require "mocha/minitest"
require "./lib/team_collection"
require "./lib/game_collection"
require "./lib/game_team_collection"


class GameTeamCollectionTest < Minitest::Test

  def setup
    @game_collection = GameCollection.new("./test/fixtures/games_truncated.csv")
    @team_collection = TeamCollection.new("./test/fixtures/teams_truncated.csv", @game_collection.games)
    @game_team_collection = GameTeamCollection.new("./data/game_teams.csv", @game_collection.games)
  end

  def test_it_exists
    assert_instance_of GameTeamCollection, @game_team_collection
  end

  def test_it_has_attributes
    assert_instance_of Array, @game_team_collection.game_teams
    assert_equal 14882, @game_team_collection.game_teams.length
  end

  def test_it_can_create_game_teams
    skip
  end

  def test_it_can_get_game_by_id
    expected = @game_collection.games[0]
    assert_equal expected, @game_team_collection.get_game_by_id(2012030221)
  end

  def test_it_can_get_games_by_season
    skip
  end

  def test_it_can_calculate_tackles
    skip
  end

  def test_it_can_calculate_season_stats
    skip
  end

end
