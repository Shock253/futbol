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

  def games_by_season(game_collection, season)
    @games.find_all do | game |
      game_info = get_game_by_id(game_collection, game.game_id)
      game_info.season == season
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

  def biggest_bust(season)
    games_by_season = @games.find_all do | game |
      game.season == season
    end

    season_games_by_type = games_by_season.group_by do |game|
      game.type
    end

    post_games_by_team = season_games_by_type["Postseason"].reduce(Hash.new) do |acc, game|
      acc[game.away_team_id] ||= []
      acc[game.home_team_id] ||= []

      acc[game.away_team_id] << game
      acc[game.home_team_id] << game


      acc
    end

    reg_games_by_team = season_games_by_type["Regular Season"].reduce(Hash.new) do |acc, game|
      acc[game.away_team_id] ||= []
      acc[game.home_team_id] ||= []

      acc[game.away_team_id] << game
      acc[game.home_team_id] << game


      acc
    end
    require "pry"; binding.pry
    # sum of their wins / length of the games arr
    #
    #   team_total_wins = team_games.reduce(0) do |sum, game|
    #     if game.team_win?(team_id)
    #       sum += 1
    #     end
    #
    #     sum
    #   end
    #
    #   team_total_wins.to_f / games.length


    # season_games_by_type["Regular Season"].reduce(Hash.new) do |acc, type, games|
    #   acc[team_id] = [that teams games]
    # end
    require "pry"; binding.pry
  end

end
