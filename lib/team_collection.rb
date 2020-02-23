require_relative './team'
require 'CSV'

class TeamCollection

  attr_reader :teams

  def initialize(csv_file_path)
    @teams = create_teams(csv_file_path)
    @team_stats = {}
  end

  def create_teams(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
       Team.new(row)
    end
  end

  def find_team_by_id(id)
    @teams.find do |team|
      team.team_id == id
    end
  end

  def all_games_by_team(game_collection, team_id)
    game_collection.games.find_all do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end
  end

  def home_games_by_team(game_collection, team_id)
    game_collection.games.find_all do |game|
      game.home_team_id == team_id
    end
  end

  def away_games_by_team(game_collection, team_id)
    game_collection.games.find_all do |game|
      game.away_team_id == team_id
    end
  end

  def num_of_home_wins(game_collection, team_id)
    home_games = home_games_by_team(game_collection, team_id)
    home_games.count { |game| game.home_win? }
  end

  def num_of_away_wins(game_collection, team_id)
    away_games = away_games_by_team(game_collection, team_id)
    away_games.count { |game| game.away_win? }
  end

  def num_of_all_games(game_collection, team_id)
    all_games_by_team(game_collection, team_id).length
  end

  def num_of_all_wins(game_collection, team_id)
    num_of_home_wins(game_collection, team_id) + num_of_away_wins(game_collection, team_id)
  end

  def num_of_home_games(game_collection, team_id)
    home_games_by_team(game_collection, team_id).length
  end

  def num_of_away_games(game_collection, team_id)
    away_games_by_team(game_collection, team_id).length
  end

  def winning_percentage(game_collection, team_id)
    winning_percentage = (num_of_all_wins(game_collection, team_id).to_f) / num_of_all_games(game_collection, team_id)
    winning_percentage = 0.0 if winning_percentage.nan?
    winning_percentage * 100
  end

  def total_win_difference_home_and_away(game_collection, team_id)
    home_wins = num_of_home_wins(game_collection, team_id)
    away_wins = num_of_away_wins(game_collection, team_id)

    home_percentage = home_wins.to_f / num_of_home_games(game_collection, team_id)
    away_percentage = away_wins.to_f / num_of_away_games(game_collection, team_id)

    total_win_difference = (away_percentage - home_percentage).abs

    total_win_difference = 0.0 if total_win_difference.nan?
    total_win_difference
  end

  def more_away_wins?(game_collection, team_id)
    home_wins = num_of_home_wins(game_collection, team_id)
    away_wins = num_of_away_wins(game_collection, team_id)

    away_wins.to_f > home_wins.to_f
  end

  def average_away_goals(game_collection, team_id)
    total_goals = away_games_by_team(game_collection, team_id).sum do | game |
      game.away_goals
    end
    away_games = num_of_away_games(game_collection, team_id)
    average = 0.0
    average = total_goals.to_f / away_games if away_games != 0
    average
  end

  def average_home_goals(game_collection, team_id)
    total_goals = home_games_by_team(game_collection, team_id).sum do | game |
      game.home_goals
    end
    home_games = num_of_home_games(game_collection, team_id)
    average = 0.0
    average = total_goals.to_f / home_games if home_games != 0
    average
  end

  def team_stats(game_collection)
    @teams.reduce({}) do | team_stats, team |
      team_stats[team.teamName] = {
        total_games: num_of_all_games(game_collection, team.team_id),
        games_won: num_of_all_wins(game_collection, team.team_id),
        home_games_won: num_of_home_wins(game_collection, team.team_id),
        average_away_goals: average_away_goals(game_collection, team.team_id),
        average_home_goals: average_home_goals(game_collection, team.team_id),
        away_games_won: num_of_away_wins(game_collection, team.team_id),
        winning_percentage: winning_percentage(game_collection, team.team_id),
        winning_difference_percentage: total_win_difference_home_and_away(game_collection, team.team_id),
        more_away_wins: more_away_wins?(game_collection, team.team_id)
      }
      team_stats
    end
  end

end
