require_relative './game_team'
require 'CSV'

class GameTeamCollection

  attr_reader :game_teams, :game_stats

  def initialize(csv_file_path, games)
    @game_teams = create_game_teams(csv_file_path)
    @games = games
    @game_team_stats = {}
  end

  def create_game_teams(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
       GameTeam.new(row)
    end
  end

  def get_game_by_id(game_id)
    @games.find { |game| game.game_id == game_id }
  end

  def game_teams_by_season(season)
    @game_teams.find_all { | game | game.game_id.to_s[0..3] == season[0..3] }
  end

  def tackles_per_team(season_info, team_id)
    games = season_info.find_all { | game | game.team_id == team_id}
    games.sum { | game | game.tackles}
  end

  def most_tackles(season)
    season_stats(season).max_by {|team,stats| stats[:tackles]}.first
  end

  def fewest_tackles(season)
    season_stats(season).min_by {|team,stats| stats[:tackles]}.first
  end

  def season_stats(season)
    season_info = game_teams_by_season(season)
    season_info.reduce({}) do | season_stats, game |
      season_stats[game.team_id] = {
        tackles: tackles_per_team(season_info, game.team_id)
      }
      season_stats
    end
  end

end
