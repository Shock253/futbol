require_relative './game_collection'
require_relative './team_collection'
require_relative './game_team_collection'
require 'CSV'

class StatTracker

  def self.from_csv(locations)
    StatTracker.new(locations[:games], locations[:teams], locations[:game_teams])
  end

  attr_reader :game_stats, :team_stats, :season_stats

  def initialize(game_path, team_path, game_team_path)
    @game_stats = GameCollection.new(game_path)
    @team_stats = TeamCollection.new(team_path, @game_stats.games)
    @season_stats = GameTeamCollection.new(game_team_path, @game_stats.games)
  end

  def game_team_collection
     GameTeamCollection.new(@game_team_path)
  end

  def highest_total_score
    @game_stats.highest_total_score
  end

  def lowest_total_score
    @game_stats.lowest_total_score
  end

  def biggest_blowout
    @game_stats.biggest_blowout
  end

  def percentage_home_wins
    @game_stats.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_stats.percentage_visitor_wins
  end

  def percentage_ties
    @game_stats.percentage_ties
  end

  def count_of_games_by_season
    @game_stats.count_of_games_by_season
  end

  def average_goals_per_game
    @game_stats.average_goals_per_game
  end

  def average_goals_by_season
    @game_stats.average_goals_by_season
  end

  def count_of_teams
    @team_stats.teams.length
  end

  def best_offense
    @team_stats.best_offense
  end

  def worst_offense
    @team_stats.worst_offense
  end

  def best_defense
    @team_stats.best_defense
  end

  def worst_defense
    @team_stats.worst_defense
  end

  def highest_scoring_visitor
    @team_stats.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @team_stats.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @team_stats.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @team_stats.lowest_scoring_home_team
  end

  def winningest_team
    @team_stats.winningest_team
  end

  def best_fans
    @team_stats.best_fans
  end

  def worst_fans
    @team_stats.worst_fans
  end

  def most_tackles(season)
    team_id = @season_stats.most_tackles(season)
    @team_stats.find_team_by_id(team_id).team_name
  end

  def fewest_tackles(season)
    team_id = @season_stats.fewest_tackles(season)
    @team_stats.find_team_by_id(team_id).team_name
  end

  def most_accurate_team(season)
    team_id = @season_stats.season_stats(season).max_by do |team,stats|
      stats[:accuracy_ratio]
    end.first
    @team_stats.find_team_by_id(team_id).team_name
  end

  def least_accurate_team(season)
    team_id = @season_stats.season_stats(season).min_by do |team,stats|
      stats[:accuracy_ratio]
    end.first
    @team_stats.find_team_by_id(team_id).team_name
  end

  def winningest_coach(season)
    team_id = @season_stats.season_stats(season).min_by do |team,stats|
      stats[:accuracy_ratio]
    end.first
    @team_stats.find_team_by_id(team_id).team_name
  end

  def most_goals_scored(team_id)
    game_teams = @season_stats.game_teams.find_all do |game_team|
      game_team.team_id == team_id.to_i
    end
    game_teams.max_by do |game_team|
      game_team.goals
    end.goals
  end

  def fewest_goals_scored(team_id)
    game_teams = @season_stats.game_teams.find_all do |game_team|
      game_team.team_id == team_id.to_i
    end
    game_teams.min_by do |game_team|
      game_team.goals
    end.goals
  end

  def winningest_coach(season)
    @season_stats.winningest_coach(season)
  end

  def worst_coach(season)
    @season_stats.worst_coach(season)
  end

end
