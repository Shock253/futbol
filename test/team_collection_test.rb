require "./test/test_helper"
require "mocha/minitest"
require "./lib/team_collection"
require "./lib/game_collection"

class TeamCollectionTest < Minitest::Test

  def setup
    @game_collection = GameCollection.new("./test/fixtures/games_truncated.csv")
    @team_collection = TeamCollection.new("./test/fixtures/teams_truncated.csv", @game_collection.games)
    # Chicago Team ID = 25
    # game_id,season,type,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link
    # 2016020251,20162017,Regular Season,11/18/16,21,25,2,3,SeatGeek Stadium,/api/v1/venues/null
    @chicago = @team_collection.teams[0]
    @dallas = @team_collection.teams[2]
    @los_angeles = @team_collection.teams[4]
    @game1 = @game_collection.games[7]
  end

  def test_it_exists
    TeamCollection.stubs(:create_teams).returns(Array.new(32, mock('team')))
    stubbed_team_collection = TeamCollection.new("./data/teams.csv", @game_collection)
    assert_instance_of TeamCollection, stubbed_team_collection
  end

  def test_it_has_attributes
    TeamCollection.stubs(:create_teams).returns(Array.new(32, mock('team')))
    stubbed_team_collection = TeamCollection.new("./data/teams.csv", @game_collection)

    assert_instance_of Array, stubbed_team_collection.teams
    assert_equal 32, stubbed_team_collection.teams.length
  end

  def test_csv_loads
    team_collection = TeamCollection.new("./data/teams.csv", @game_collection)

    atlanta = team_collection.teams.first
    columbus = team_collection.teams.last

    assert_equal 1, atlanta.team_id
    assert_equal 23, atlanta.franchise_id
    assert_equal "Atlanta United", atlanta.team_name
    assert_equal "ATL", atlanta.abbreviation
    assert_equal "Mercedes-Benz Stadium", atlanta.stadium
    assert_equal "/api/v1/teams/1", atlanta.link

    assert_equal 53, columbus.team_id
    assert_equal 28, columbus.franchise_id
    assert_equal "Columbus Crew SC", columbus.team_name
    assert_equal "CCS", columbus.abbreviation
    assert_equal "Mapfre Stadium", columbus.stadium
    assert_equal "/api/v1/teams/53", columbus.link
  end

  def test_can_find_team_by_id
    stubbed_team_collection = TeamCollection.new("./data/teams.csv", @game_collection)
    columbus = stubbed_team_collection.find_team_by_id(53)

    assert_equal 53, columbus.team_id
    assert_equal 28, columbus.franchise_id
    assert_equal "Columbus Crew SC", columbus.team_name
    assert_equal "CCS", columbus.abbreviation
    assert_equal "Mapfre Stadium", columbus.stadium
    assert_equal "/api/v1/teams/53", columbus.link
  end

  def test_it_can_get_all_games_by_team
    assert_equal [@game1], @team_collection.all_games_by_team(@chicago.team_id)
  end

  def test_it_can_get_home_games_by_team
    assert_equal [@game1], @team_collection.home_games_by_team(@chicago.team_id)
  end

  def test_it_can_get_away_games_by_team
    assert_equal [], @team_collection.away_games_by_team(@chicago.team_id)
  end

  def test_it_calculate_num_of_home_wins
    assert_equal 1, @team_collection.num_of_home_wins(@chicago.team_id)
    assert_equal 3, @team_collection.num_of_home_wins(@dallas.team_id)
  end

  def test_it_calculate_num_of_away_wins
    assert_equal 0, @team_collection.num_of_away_wins(@chicago.team_id)
    assert_equal 2, @team_collection.num_of_away_wins(@dallas.team_id)
  end

  def test_it_can_calculate_num_of_all_games
    assert_equal 1, @team_collection.num_of_all_games(@chicago.team_id)
    assert_equal 5, @team_collection.num_of_all_games(@dallas.team_id)
  end

  def test_it_can_calculate_num_of_all_wins
    assert_equal 1, @team_collection.num_of_all_wins(@chicago.team_id)
    assert_equal 5, @team_collection.num_of_all_wins(@dallas.team_id)
  end

  def test_it_can_calculate_num_of_home_games
    assert_equal 1, @team_collection.num_of_home_games(@chicago.team_id)
    assert_equal 3, @team_collection.num_of_home_games(@dallas.team_id)
  end

  def test_it_can_calculate_num_of_away_games
    assert_equal 0, @team_collection.num_of_away_games(@chicago.team_id)
    assert_equal 2, @team_collection.num_of_away_games(@dallas.team_id)
  end

  def test_it_can_calculate_winning_percentage
    assert_equal 100, @team_collection.winning_percentage(@chicago.team_id)
    assert_equal 100, @team_collection.winning_percentage(@dallas.team_id)
  end

  def test_it_can_calculate_total_win_difference_home_and_away
    assert_equal 0.0, @team_collection.total_win_difference_home_and_away(@chicago.team_id)
    assert_equal 0.0, @team_collection.total_win_difference_home_and_away(@dallas.team_id)
  end

  def test_it_can_calculate_winning_away_percentage
    assert_equal false, @team_collection.more_away_wins?(@chicago.team_id)
    assert_equal false, @team_collection.more_away_wins?(@dallas.team_id)
    assert_equal true, @team_collection.more_away_wins?(@los_angeles.team_id)
  end

  def test_it_can_average_away_goals
    assert_equal 4, @team_collection.average_away_goals(@los_angeles.team_id)
  end

  def test_it_can_average_home_goals
    assert_equal 3, @team_collection.average_home_goals(@dallas.team_id)
  end

end
