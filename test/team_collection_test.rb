require "./test/test_helper"
require "mocha/minitest"
require "./lib/team_collection"
require "./lib/game_collection"

class TeamCollectionTest < Minitest::Test

  def setup
    @game_collection = GameCollection.new("./test/fixtures/games_truncated.csv")
    @team_collection = TeamCollection.new("./test/fixtures/teams_truncated.csv")
    # Chicago Team ID = 25
    # game_id,season,type,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link
    # 2016020251,20162017,Regular Season,11/18/16,21,25,2,3,SeatGeek Stadium,/api/v1/venues/null
    @chicago = @team_collection.teams[0]
    @dallas = @team_collection.teams[2]
    @game1 = @game_collection.games[7]
  end

  def test_it_exists
    TeamCollection.stubs(:create_teams).returns(Array.new(32, mock('team')))
    stubbed_team_collection = TeamCollection.new("./data/teams.csv")
    assert_instance_of TeamCollection, stubbed_team_collection
  end

  def test_it_has_attributes
    TeamCollection.stubs(:create_teams).returns(Array.new(32, mock('team')))
    stubbed_team_collection = TeamCollection.new("./data/teams.csv")

    assert_instance_of Array, stubbed_team_collection.teams
    assert_equal 32, stubbed_team_collection.teams.length
  end

  def test_csv_loads
    team_collection = TeamCollection.new("./data/teams.csv")

    team_a = team_collection.teams.first
    team_z = team_collection.teams.last

    assert_equal 1,                       team_a.team_id
    assert_equal 23,                      team_a.franchiseId
    assert_equal "Atlanta United",        team_a.teamName
    assert_equal "ATL",                   team_a.abbreviation
    assert_equal "Mercedes-Benz Stadium", team_a.stadium
    assert_equal "/api/v1/teams/1",       team_a.link

    assert_equal 53,                      team_z.team_id
    assert_equal 28,                      team_z.franchiseId
    assert_equal "Columbus Crew SC",      team_z.teamName
    assert_equal "CCS",                   team_z.abbreviation
    assert_equal "Mapfre Stadium",        team_z.stadium
    assert_equal "/api/v1/teams/53",      team_z.link
  end

  def test_can_find_team_by_id
    skip
    generic_team = mock('team')
    generic_team.stubs(:team_id).returns(2)
    specific_team = mock('specific')
    specific_team.stubs(:team_id).returns(1)
    teams = Array.new(32, generic_team)
    teams[10] = specific_team
    TeamCollection.stubs(:create_teams).returns(teams)
    stubbed_team_collection = TeamCollection.new("./data/teams.csv")

    assert_equal specific_team, stubbed_team_collection.find_team_by_id(1)
  end

  def test_it_can_get_all_games_by_team
    assert_equal [@game1], @team_collection.all_games_by_team(@game_collection, @chicago.team_id)
  end

  def test_it_can_get_home_games_by_team
    assert_equal [@game1], @team_collection.home_games_by_team(@game_collection, @chicago.team_id)
  end

  def test_it_can_get_away_games_by_team
    assert_equal [], @team_collection.away_games_by_team(@game_collection, @chicago.team_id)
  end

  def test_it_calculate_num_of_home_wins
    assert_equal 1, @team_collection.num_of_home_wins(@game_collection, @chicago.team_id)
    assert_equal 3, @team_collection.num_of_home_wins(@game_collection, @dallas.team_id)
  end

  def test_it_calculate_num_of_away_wins
    assert_equal 0, @team_collection.num_of_away_wins(@game_collection, @chicago.team_id)
    assert_equal 2, @team_collection.num_of_away_wins(@game_collection, @dallas.team_id)
  end

  def test_it_can_calculate_num_of_all_games
    assert_equal 1, @team_collection.num_of_all_games(@game_collection, @chicago.team_id)
    assert_equal 5, @team_collection.num_of_all_games(@game_collection, @dallas.team_id)
  end

  def test_it_can_calculate_num_of_all_wins
    assert_equal 1, @team_collection.num_of_all_wins(@game_collection, @chicago.team_id)
    assert_equal 5, @team_collection.num_of_all_wins(@game_collection, @dallas.team_id)
  end

  def test_it_can_calculate_num_of_home_games
    assert_equal 1, @team_collection.num_of_home_games(@game_collection, @chicago.team_id)
    assert_equal 3, @team_collection.num_of_home_games(@game_collection, @dallas.team_id)
  end

  def test_it_can_calculate_num_of_away_games
    assert_equal 0, @team_collection.num_of_away_games(@game_collection, @chicago.team_id)
    assert_equal 2, @team_collection.num_of_away_games(@game_collection, @dallas.team_id)
  end

  def test_it_can_calculate_winning_percentage
    assert_equal 100, @team_collection.winning_percentage(@game_collection, @chicago.team_id)
    assert_equal 100, @team_collection.winning_percentage(@game_collection, @dallas.team_id)
  end

  def test_it_can_calculate_total_win_difference_home_and_away
    assert_equal 0.0, @team_collection.total_win_difference_home_and_away(@game_collection, @chicago.team_id)
    assert_equal 0.0, @team_collection.total_win_difference_home_and_away(@game_collection, @dallas.team_id)
  end

end
