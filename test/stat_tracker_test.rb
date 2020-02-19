require "./test/test_helper"
require "./lib/stat_tracker"
require "CSV"

class StatTrackerTest < Minitest::Test

  def setup
    locations = {
      games: "./test/fixtures/games_truncated.csv",
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_from_csv
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_game_collection
    assert_instance_of GameCollection, @stat_tracker.game_collection
  end

  def test_calculates_percentage_home_wins
    assert_equal 0.40, @stat_tracker.percentage_home_wins
  end

  def test_calculates_percentage_visitor_wins
    assert_equal 0.50, @stat_tracker.percentage_visitor_wins
  end

  def test_calculates_percentage_ties
    assert_equal 0.10, @stat_tracker.percentage_ties
  end

end
