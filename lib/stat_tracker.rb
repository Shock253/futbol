require_relative './game_collection'
require_relative './team_collection'
require 'CSV'

class StatTracker

  def self.from_csv(locations)
    StatTracker.new(locations[:games], locations[:teams], locations[:game_teams])
  end

  attr_reader :game_stats, :team_stats, :game_team_path

  def initialize(game_path, team_path, game_team_path)
    @game_stats = GameCollection.new(game_path)
    @team_stats = TeamCollection.new(team_path, @game_stats.games)
    @game_team_path = game_team_path
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

  #best_offense
  #worst_offense
  #best_defense
  #worst_defense

  def highest_scoring_visitor
    @team_stats.team_stats.max_by do |team, stats|
      stats[:average_away_goals]
    end.first
  end

  def highest_scoring_home_team
    @team_stats.team_stats.max_by do |team, stats|
      stats[:average_home_goals]
    end.first
  end

  def lowest_scoring_visitor
    @team_stats.team_stats.min_by do |team, stats|
      stats[:average_away_goals]
    end.first
  end

  def lowest_scoring_home_team
    @team_stats.team_stats.min_by do |team, stats|
      stats[:average_home_goals]
    end.first
  end

  def winningest_team
   @team_stats.team_stats.max_by do |team, stats|
     stats[:winning_percentage]
   end.first
  end

  def best_fans
   @team_stats.team_stats.max_by do |team, stats|
     stats[:winning_difference_percentage]
   end.first
  end

  def worst_fans
   @team_stats.team_stats.find_all do |team, stats|
     stats[:more_away_wins] == true
   end.flat_map { |team| team[0] }
  end

end
