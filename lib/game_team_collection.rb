require_relative './game_team'
require_relative './game_collection'
require 'CSV'

class GameTeamCollection

  attr_reader :game_teams, :game_team_stats

  def initialize(csv_file_path, games)
    @games = games
    @game_team_stats = {}
    @game_teams = create_game_teams(csv_file_path)
  end

  def create_game_teams(csv_file_path)
     csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
     csv.map do |row|
       if !@game_team_stats.key? GameTeam.new(row).game_id.to_s[0..3]
         @game_team_stats[GameTeam.new(row).game_id.to_s[0..3]] = [GameTeam.new(row)]
       else
         @game_team_stats[GameTeam.new(row).game_id.to_s[0..3]] << GameTeam.new(row)
       end
       GameTeam.new(row)
     end
  end

  def get_game_by_id(game_id)
    @games.find { |game| game.game_id == game_id }
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

  def games_by_coach(season)
    games_by_coach = @game_team_stats[season[0..3]].group_by {|game| game.head_coach}
    games_by_coach
  end

  def win_percentage_by_coach(season)
    wins = games_by_coach(season)
    wins.each do | coach, games |
      wins[coach] = games.count {|game|game.result == "WIN"} / games.size.to_f
    end
  end

  def winningest_coach(season)
    win_percentage_by_coach(season).max_by { |coach, win_percentage| win_percentage}.first
  end

  def worst_coach(season)
    win_percentage_by_coach(season).min_by { |coach, win_percentage| win_percentage}.first
  end

  def shots(season_info, team_id)
    games = season_info.find_all { | game | game.team_id == team_id}
    games.sum { | game | game.shots}
  end

  def goals_by_season(season_info, team_id)
    games = season_info.find_all { | game | game.team_id == team_id}

    games.sum { | game | game.goals}
  end

  def accuracy_ratio(season_info, team_id)
    goals_by_season(season_info, team_id) / shots(season_info, team_id).to_f
  end

  def season_stats(season)
    season_info = @game_team_stats[season[0..3]]
      season_info.reduce({}) do | season_stats, game |
      season_stats[game.team_id] = {
        tackles: tackles_per_team(season_info, game.team_id),
        accuracy_ratio: accuracy_ratio(season_info, game.team_id),
      }
      season_stats
    end
  end

end
