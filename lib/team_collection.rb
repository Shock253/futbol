require_relative './team'
require 'CSV'

class TeamCollection

  attr_reader :teams, :games

  def initialize(csv_file_path, games)
    @teams = create_teams(csv_file_path)
    @games = games
    @team_stats = generate_team_stats
  end

  def create_teams(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map { |row| Team.new(row) }
  end

  def find_team_by_id(id)
    @teams.find { |team| team.team_id == id }
  end

  def all_games_by_team(team_id)
    @games.find_all { |game| game.home_team_id == team_id || game.away_team_id == team_id }
  end

  def home_games_by_team(team_id)
    @games.find_all { |game| game.home_team_id == team_id }
  end

  def away_games_by_team(team_id)
    @games.find_all { |game| game.away_team_id == team_id }
  end

  def num_of_home_wins(team_id)
    home_games_by_team(team_id).count { |game| game.home_win? }
  end

  def num_of_away_wins(team_id)
    away_games_by_team(team_id).count { |game| game.away_win? }
  end

  def num_of_all_wins(team_id)
    num_of_home_wins(team_id) + num_of_away_wins(team_id)
  end

  def average_away_goals(team_id)
    total_goals = away_games_by_team(team_id).sum { | game | game.away_goals }
    away_games = away_games_by_team(team_id).size
    average = 0.0
    average = total_goals.to_f / away_games if away_games != 0
    average
  end

  def average_home_goals(team_id)
    total_goals = home_games_by_team(team_id).sum { | game | game.home_goals }
    home_games = home_games_by_team(team_id).size
    average = 0.0
    average = total_goals.to_f / home_games if home_games != 0
    average
  end

  def avearge_goals_allowed(team_id)
    all_games_by_team(team_id).reduce(Hash.new(0)) do |acc, game|
      acc[game.away_team_id] += (game.home_goals.to_f / all_games_by_team(game.away_team_id).size)
      acc[game.home_team_id] += (game.away_goals.to_f / all_games_by_team(game.home_team_id).size)
      acc
    end[team_id]
  end

  def winning_percentage(team_id)
    winning_percentage = (num_of_all_wins(team_id).to_f) / all_games_by_team(team_id).size
    winning_percentage = 0.0 if winning_percentage.nan?
    winning_percentage * 100
  end

  def total_win_difference_home_and_away(team_id)
    home_percentage = num_of_home_wins(team_id).to_f / home_games_by_team(team_id).size
    away_percentage = num_of_away_wins(team_id).to_f / away_games_by_team(team_id).size
    total_win_difference = (away_percentage - home_percentage).abs
    total_win_difference = 0.0 if total_win_difference.nan?
    total_win_difference
  end

  def more_away_wins?(team_id)
    num_of_away_wins(team_id).to_f > num_of_home_wins(team_id).to_f
  end

  def best_offense
    @team_stats.max_by { |team, stats| stats[:average_total_goals]}.first
  end

  def worst_offense
    @team_stats.min_by { |team, stats| stats[:average_total_goals]}.first
  end

  def best_defense
    @team_stats.min_by { |team, stats| stats[:average_goals_allowed]}.first
  end

  def worst_defense
    @team_stats.max_by { |team, stats| stats[:average_goals_allowed]}.first
  end

  def highest_scoring_visitor
    @team_stats.max_by { |team, stats| stats[:average_away_goals]}.first
  end

  def highest_scoring_home_team
    @team_stats.max_by { |team, stats| stats[:average_home_goals]}.first
  end

  def lowest_scoring_home_team
    @team_stats.min_by { |team, stats| stats[:average_home_goals]}.first
  end

  def lowest_scoring_visitor
    @team_stats.min_by { |team, stats| stats[:average_away_goals]}.first
  end

  def winningest_team
    @team_stats.max_by { |team, stats| stats[:winning_percentage]}.first
  end

  def best_fans
    @team_stats.max_by { |team, stats| stats[:winning_diff_percentage]}.first
  end

  def worst_fans
    worst_fans = @team_stats.find_all { |team, stats| stats[:more_away_wins] == true }
    worst_fans.flat_map { |team| team[0] }
  end

  def generate_team_stats
    @teams.reduce({}) do | team_stats, team |
      team_stats[team.team_name] = {
        average_total_goals: average_home_goals(team.team_id) + average_away_goals(team.team_id),
        average_goals_allowed: avearge_goals_allowed(team.team_id),
        average_home_goals: average_home_goals(team.team_id),
        average_away_goals: average_away_goals(team.team_id),
        more_away_wins: more_away_wins?(team.team_id),
        winning_percentage: winning_percentage(team.team_id),
        winning_diff_percentage: total_win_difference_home_and_away(team.team_id)
      }
      team_stats
    end
  end

end
