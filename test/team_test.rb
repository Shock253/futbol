require "./test/test_helper"
require_relative "../lib/team"

class TeamTest < Minitest::Test

  def setup
    @team = Team.new({
      team_id:        1,
      franchiseid:    23,
      teamname:       "Atlanta United",
      abbreviation:   "ATL",
      stadium:        "Mercedes-Benz Stadium",
      link:           "/api/v1/teams/1"
      })
  end

  game1 = mock("Game1")
    game1.stubs(:away_goals => 2,
                :winner => 1,
                :home_goals => 1,
                :home_team_id => 2,
                :away_team_id => 3)
    game2 = mock("Game2")
    game2.stubs(:away_goals => 1,
                :winner => 3,
                :home_goals => 2,
                :home_team_id => 2,
                :away_team_id => 3)
    game3 = mock("Game3")
    game3.stubs(:home_goals => 4,
                :winner => 1,
                :away_goals => 1,
                :home_team_id => 3,
                :away_team_id => 2)
    game4 = mock("Game4")
    game4.stubs(:home_goals => 3,
                :winner => 3,
                :away_goals => 2,
                :home_team_id => 3,
                :away_team_id => 2)

    fake_away_games = [game1, game2]
    fake_home_games = [game3, game4]

    @team.stubs(:away_games => fake_away_games, :home_games => fake_home_games)

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_attributes
    assert_equal @team.team_id,        1
    assert_equal @team.franchiseId,    23
    assert_equal @team.teamName,       "Atlanta United"
    assert_equal @team.abbreviation,   "ATL"
    assert_equal @team.stadium,        "Mercedes-Benz Stadium"
    assert_equal @team.link,           "/api/v1/teams/1"

  end

  def test_can_return_total_games_played
    assert_equal 4, @team.total_games_played
  end

  def test_can_return_total_games_played
    assert_equal 4, @team.total_games_played
  end

  def test_can_find_total_scores_against
    assert_equal 1.5, @team.total_scores_against
  end
end
