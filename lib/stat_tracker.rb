require_relative './game_collection'
require_relative './team_collection'
require 'CSV'

class StatTracker

  attr_reader :game_path, :team_path, :game_team_path

  def initialize(game_path, team_path, game_team_path)
    @game_path = game_path
    @team_path = team_path
    @game_team_path = game_team_path
    @games = game_collection.games
  end

  def self.from_csv(locations)
    StatTracker.new(locations[:games], locations[:teams], locations[:game_teams])
  end

  def game_collection
    GameCollection.new(@game_path)
  end

  def team_collection
    TeamCollection.new(@team_path)
  end

  def highest_total_score
    @games.max_by { |game| game.total_goals }.total_goals
  end

  def lowest_total_score
    @games.min_by { |game| game.total_goals }.total_goals
  end

  def biggest_blowout
    game_goals_ranges = []
    game_collection.games.each do |game|
      game_goals_ranges << (game.home_goals - game.away_goals).abs
    end
    game_goals_ranges.max
  end

  def percentage_home_wins
    home_wins = @games.count { |game| game.home_win? }
    (home_wins.to_f / game_collection.games.length).round(2)
  end

  def percentage_visitor_wins
    away_wins = @games.count { |game| game.away_win? }
    (away_wins.to_f / game_collection.games.length).round(2)
  end

  def percentage_ties
    ties = @games.count { |game| game.tie? }
    (ties.to_f / @games.length).round(2)
  end

  def count_of_games_by_season(season)
    @games.length == season
  end

  def average_goals_per_game
    total_goals = @games.map { |game| game.total_score }
    (total_goals.sum.to_f / @games.length).round(2)
  end

  def average_goals_by_season(season)
    game_count = @games.length == season
    (game_count.to_f / @games.length).round(2)
  end

  #count_of_teams
  #best_offense
  #worst_offense
  #best_defense
  #worst_defense

  def highest_scoring_visitor
    team_collection.team_stats(@games).max_by do |team, stats|
      stats[:average_away_goals]
    end.first
  end

  def highest_scoring_home_team
    team_collection.team_stats(@games).max_by do |team, stats|
      stats[:average_home_goals]
    end.first
  end

  def lowest_scoring_visitor
    team_collection.team_stats(@games).min_by do |team, stats|
      stats[:average_away_goals]
    end.first
  end

  def lowest_scoring_home_team
    team_collection.team_stats(@games).min_by do |team, stats|
      stats[:average_home_goals]
    end.first
  end

  def winningest_team
   team_collection.team_stats(@games).max_by do |team, stats|
     stats[:winning_percentage]
   end.first
  end

  def best_fans
   team_collection.team_stats(@games).max_by do |team, stats|
     stats[:winning_difference_percentage]
   end.first
  end

  def worst_fans
   team_collection.team_stats(@games).find_all do |team, stats|
     stats[:more_away_wins] == true
   end.flat_map { |team| team[0] }
  end

end
