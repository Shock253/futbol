require_relative './game_team'
require_relative './game_collection'
require 'CSV'

class GameTeamCollection

  attr_reader :game_teams, :game_stats

  def initialize(csv_file_path)
    @game_teams = create_game_teams(csv_file_path)
    @game_team_stats = {}
  end

  def create_game_teams(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
       GameTeam.new(row)
    end
  end

  def get_game_by_id(game_collection, game_id)
    game_collection.find { |game| game.id == game_id }
  end

  def games_by_season(game_collection, season)
    @game_teams.find_all do | game |
      game.game_id.to_s[0..3] == season[0..3]
    end
  end

  def winningest_coach(game_collection, season)
    wins_by_coach = games_by_season(game_collection, season).reduce(Hash.new(0)) do |acc, game|
      acc[game.head_coach] += 1 if game.result == "WIN"
      acc
    end
    wins_by_coach.max_by do |coach, wins|
      wins
    end.first
  end

  def worst_coach(game_collection, season)
    losses_by_coach = games_by_season(game_collection, season).reduce(Hash.new(0)) do |acc, game|
      acc[game.head_coach] += 1 if game.result == "LOSS"
      acc
    end
    losses_by_coach.max_by do |coach, losses|
      losses
    end.first
  end

  def tackles(season_info, team_id)
    games = season_info.find_all { | game | game.team_id == team_id}
    games.sum { | game | game.tackles}
  end

  def shots(season_info, team_id)
    games = season_info.find_all { | game | game.team_id == team_id}
    games.sum { | game | game.shots}
  end

  def goals_by_season(season_info, team_id)
    games = season_info.find_all { | game | game.team_id == team_id}
    games.sum { | game | game.goals}
  end

  def wins_by_season(season_info, team_id)
    games_by_season(game_collection, season)
  end



  def accuracy_ratio(season_info, team_id)
    goals_by_season(season_info, team_id) / shots(season_info, team_id).to_f
  end

  def season_stats(game_collection, season)
    season_info = games_by_season(game_collection, season)
    season_info.reduce({}) do | season_stats, game |
      season_stats[game.team_id] = {
        tackles: tackles(season_info, game.team_id),
        accuracy_ratio: accuracy_ratio(season_info, game.team_id),
      }
      season_stats
    end
  end

end
