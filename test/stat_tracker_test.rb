require "./test/test_helper"
require "./lib/stat_tracker"
require "CSV"

class StatTrackerTest < Minitest::Test

  def setup
    locations = {
      games: "./test/fixtures/games_truncated.csv",
      teams: "./test/fixtures/teams_truncated.csv",
      game_teams: './data/game_teams.csv'
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_from_csv
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_game_collection
    assert_instance_of GameCollection, @stat_tracker.game_stats
  end

  def test_it_show_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_show_lowest_total_score
    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_it_show_biggest_blowout
    assert_equal 2, @stat_tracker.biggest_blowout
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

  def test_can_get_biggest_bust


    assert_equal "Montreal Impact", @stat_tracker.biggest_bust("20132014")
    assert_equal "Sporting Kansas City", @stat_tracker.biggest_bust("20142015")

    # for each team
    # get win percentage of season
      # sum and average wins by season
    # get win percentage of postseason
      # sum and average wins by postseason

    # compare season win percentage > postseason win percentage



  end

  def test_can_get_biggest_bust
    # for each team
    # get win percentage of season
      # sum and average wins by season
    # get win percentage of postseason
      # sum and average wins by postseason

    # compare season win percentage > postseason win percentage

  end

  # test count_of_games_by_season
  # test average_goals_per_game
  # test average_goals_by_season
  def test_count_of_games_by_season
    expected_hash = {
      "20122013" => 5,
      "20172018" => 2,
      "20162017" => 1,
      "20152016" => 1,
      "20132014" => 1
    }
    assert_equal expected_hash, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 4.7, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    expected_hash = {
      "20122013" => 4.4,
      "20172018" => 4,
      "20162017" => 5,
      "20152016" => 7,
      "20132014" => 5
    }
    assert_equal expected_hash, @stat_tracker.average_goals_by_season
  end

  # biggest_bust	Name of the team with the biggest decrease between
  # regular season and postseason win percentage.	String

  # biggest_surprise	Name of the team with the biggest increase between
  # regular season and postseason win percentage.	String


  def test_it_can_calculate_winningest_team
    assert_equal "Chicago Red Stars", @stat_tracker.winningest_team
  end

  def test_it_can_calculate_best_fans
    assert_equal "Chicago Red Stars", @stat_tracker.best_fans
  end

  def test_it_can_calculate_worst_fans
    assert_equal ["Los Angeles FC", "New England Revolution", "Sporting Kansas City"], @stat_tracker.worst_fans
  end

end
