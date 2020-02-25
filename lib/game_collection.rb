require_relative './game'
require "CSV"

class GameCollection
  attr_reader :games

  def initialize(csv_file_path)
    @games = create_games(csv_file_path)
  end

  def create_games(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
       Game.new(row)
    end
  end

  def highest_total_score
    @games.max_by { |game| game.total_goals }.total_goals
  end

  def lowest_total_score
    @games.min_by { |game| game.total_goals }.total_goals
  end

  def biggest_blowout
    @games.reduce([]) do | game_goals_ranges, game |
      game_goals_ranges << (game.home_goals - game.away_goals).abs
      game_goals_ranges
    end.max
  end

  def percentage_home_wins
    home_wins = @games.count { |game| game.home_win? }
    (home_wins.to_f / @games.length).round(2)
  end

  def percentage_visitor_wins
    away_wins = @games.count { |game| game.away_win? }
    (away_wins.to_f / @games.length).round(2)
  end

  def percentage_ties
    ties = @games.count { |game| game.tie? }
    (ties.to_f / @games.length).round(2)
  end

  def count_of_games_by_season
    @games.reduce(Hash.new(0)) do |acc, game|
      acc[game.season] += 1
      acc
    end
  end

  def average_goals_per_game
    goals = @games.sum { |game| game.total_goals }
    (goals.to_f / @games.count).round(2)
  end

  def average_goals_by_season
    games_by_season = count_of_games_by_season
    average_goals = @games.reduce(Hash.new(0)) do |acc, game|
      acc[game.season] += game.total_goals / (games_by_season[game.season].to_f)
      acc
    end
    average_goals.each do |season, goals|
      average_goals[season] = goals.round(2)
    end
    average_goals
  end

end
