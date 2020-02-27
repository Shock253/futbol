require "./test/test_helper"
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
    game_team = @game_team_collection.game_teams.first
    assert_instance_of GameTeam, game_team
    game_team = @game_team_collection.game_teams.last
    assert_instance_of GameTeam, game_team
    assert_equal 14882, @game_team_collection.game_teams.size
  end

  def test_it_can_get_game_by_id
    expected = @game_collection.games.first
    assert_equal expected, @game_team_collection.get_game_by_id(2012030221)
  end

  def test_it_can_calculate_tackles
    season_info = @game_team_collection.game_team_stats["20132014"[0..3]]
    assert_equal 2441, @game_team_collection.tackles_per_team(season_info, 6)
  end

  def test_it_can_calculate_season_stats
    season_stats = @game_team_collection.season_stats("20132014")
    expected = {:tackles=>2441, :accuracy_ratio=>0.3064066852367688}
    assert_equal expected, season_stats[6]
  end

  def test_it_can_find_winningest_coach
    assert_equal "Claude Julien", @game_team_collection.winningest_coach("20132014")
  end

  def test_it_can_find_worst_coach
    assert_equal "Peter Laviolette", @game_team_collection.worst_coach("20132014")
  end

  def test_it_can_get_goals_by_season
    season_info = @game_team_collection.game_team_stats["20132014"[0..3]]
    assert_equal 220, @game_team_collection.goals_by_season(season_info, 6)
  end

end
