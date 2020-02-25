require_relative './team'
require 'CSV'

class TeamCollection

  attr_reader :teams, :games

  def initialize(csv_file_path, games)
    @teams = create_teams(csv_file_path)
    @games = games
    @team_stats = {}
  end

  def create_teams(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
       Team.new(row)
    end
  end

  def find_team_by_id(id)
    @teams.find { |team| team.team_id == id }
  end

  def all_games_by_team(team_id)
    @games.find_all do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end
  end

  def home_games_by_team(team_id)
    @games.find_all do |game|
      game.home_team_id == team_id
    end
  end

  def away_games_by_team(team_id)
    @games.find_all do |game|
      game.away_team_id == team_id
    end
  end

  def num_of_home_wins(team_id)
    home_games = home_games_by_team(team_id)
    home_games.count { |game| game.home_win? }
  end

  def num_of_away_wins(team_id)
    away_games = away_games_by_team(team_id)
    away_games.count { |game| game.away_win? }
  end

  def num_of_all_games(team_id)
    all_games_by_team(team_id).length
  end

  def num_of_all_wins(team_id)
    num_of_home_wins(team_id) + num_of_away_wins(team_id)
  end

  def num_of_home_games(team_id)
    home_games_by_team(team_id).length
  end

  def num_of_away_games(team_id)
    away_games_by_team(team_id).length
  end

  def average_goals_per_team(team_id)
    home_wins = num_of_home_wins(team_id)
    away_wins = num_of_away_wins(team_id)
    (home_wins + away_wins) / num_of_all_games(team_id).to_f
  end

  def average_goals_allowed_by_team
    @games.reduce(Hash.new(0)) do |acc, game|
      acc[game.away_team_id] += (game.home_goals.to_f / num_of_all_games(game.away_team_id))
      acc[game.home_team_id] += (game.away_goals.to_f / num_of_all_games(game.home_team_id))
      acc
    end
  end

  def team_ids
    @teams.uniq { |game_team| game_team.team_id}.map { |game_team| game_team.team_id }
  end

  def best_offense
    highest_goals_team = team_ids.max_by { |team_id| average_goals_per_team(team_id) }
    find_team_by_id(highest_goals_team).team_name
  end

  def worst_offense
    least_goals_team = team_ids.min_by { |team_id| average_goals_per_team(team_id) }
    find_team_by_id(least_goals_team).team_name
  end

  def best_defense
    least_goals_against = average_goals_allowed_by_team.min_by do |team_id, average_goals|
      average_goals
    end.first
    find_team_by_id(least_goals_against).team_name
  end

  def worst_defense
    most_goals_against = average_goals_allowed_by_team.max_by do |team_id, average_goals|
      average_goals
    end.first
    find_team_by_id(most_goals_against).team_name
  end

  def winning_percentage(team_id)
    winning_percentage = (num_of_all_wins(team_id).to_f) / num_of_all_games(team_id)
    winning_percentage = 0.0 if winning_percentage.nan?
    winning_percentage * 100
  end

  def total_win_difference_home_and_away(team_id)
    home_wins = num_of_home_wins(team_id)
    away_wins = num_of_away_wins(team_id)

    home_percentage = home_wins.to_f / num_of_home_games(team_id)
    away_percentage = away_wins.to_f / num_of_away_games(team_id)

    total_win_difference = (away_percentage - home_percentage).abs

    total_win_difference = 0.0 if total_win_difference.nan?
    total_win_difference
  end

  def more_away_wins?(team_id)
    home_wins = num_of_home_wins(team_id)
    away_wins = num_of_away_wins(team_id)

    away_wins.to_f > home_wins.to_f
  end

  def average_away_goals(team_id)
    total_goals = away_games_by_team(team_id).sum do | game |
      game.away_goals
    end
    away_games = num_of_away_games(team_id)
    average = 0.0
    average = total_goals.to_f / away_games if away_games != 0
    average
  end

  def average_home_goals(team_id)
    total_goals = home_games_by_team(team_id).sum do | game |
      game.home_goals
    end
    home_games = num_of_home_games(team_id)
    average = 0.0
    average = total_goals.to_f / home_games if home_games != 0
    average
  end

  def highest_scoring_visitor
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        average_away_goals: average_away_goals(team.team_id),
      }
      team_stats
    end
    team_stats.max_by do |team, stats|
      stats[:average_away_goals]
    end.first
  end

  def highest_scoring_home_team
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        average_home_goals: average_home_goals(team.team_id),
      }
      team_stats
    end
    team_stats.max_by do |team, stats|
      stats[:average_home_goals]
    end.first
  end

  def lowest_scoring_home_team
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        average_home_goals: average_home_goals(team.team_id),
      }
      team_stats
    end
    team_stats.min_by do |team, stats|
      stats[:average_home_goals]
    end.first
  end

  def lowest_scoring_visitor
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        average_away_goals: average_away_goals(team.team_id),
      }
      team_stats
    end
    team_stats.min_by do |team, stats|
      stats[:average_away_goals]
    end.first
  end

  def winningest_team
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        winning_percentage: winning_percentage(team.team_id),
      }
      team_stats
    end
    team_stats.max_by do |team, stats|
      stats[:winning_percentage]
    end.first
  end

  def best_fans
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        winning_difference_percentage: total_win_difference_home_and_away(team.team_id),
      }
      team_stats
    end
    team_stats.max_by do |team, stats|
      stats[:winning_difference_percentage]
    end.first
  end

  def worst_fans
    team_stats = @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        more_away_wins: more_away_wins?(team.team_id)
      }
      team_stats
    end
    team_stats.find_all do |team, stats|
      stats[:more_away_wins] == true
    end.flat_map { |team| team[0] }
  end
end
