require_relative './game_collection'
require_relative './team_collection'
require 'CSV'

class StatTracker

  attr_reader :game_path, :team_path, :game_team_path

  def initialize(game_path, team_path, game_team_path)
    @game_path = game_path
    @team_path = team_path
    @game_team_path = game_team_path
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
    highest_score_game = game_collection.games.max_by do |game|
      game.total_goals
    end
    highest_score_game.total_goals
  end

  def lowest_total_score
    lowest_score_game = game_collection.games.min_by do |game|
      game.total_goals
    end
    lowest_score_game.total_goals
  end

  def biggest_blowout
    game_goals_ranges = []
    game_collection.games.each do |game|
      game_goals_ranges << (game.home_goals - game.away_goals).abs
    end
    game_goals_ranges.max
  end

  def percentage_home_wins
    count = game_collection.games.count { |game| game.home_win? }
    (count.to_f / game_collection.games.length).round(2)
  end

  def percentage_visitor_wins
    count = game_collection.games.count { |game| game.away_win? }
    (count.to_f / game_collection.games.length).round(2)
  end

  def percentage_ties
    count = game_collection.games.count { |game| game.tie? }
    (count.to_f / game_collection.games.length).round(2)
  end

  def unique_away_team_ids
    game_collection.games.map do |game|
      game.away_team_id
    end.uniq
  end

  def away_games_by_id
    unique_away_team_ids.reduce({}) do |sorted_by_id, id|
        sorted_by_id[id] = game_collection.games.find_all do |game|
          game.away_team_id == id
        end
        sorted_by_id
      end
  end

  def away_team_scores_by_id
    away_games_by_id.transform_values! do |games|
      games.map do |game|
        game.away_goals
      end
    end
  end

  def average_away_team_scores_by_id
    away_team_scores_by_id.transform_values! do |value|
      value.sum.to_f / value.length
    end
  end

  def away_team_id_with_highest_average_score
    average_away_team_scores_by_id.key(average_away_team_scores_by_id.values.max)
  end

  def highest_scoring_visitor
    team_collection.teams.find do |team|
      team.team_id == away_team_id_with_highest_average_score
    end.teamName
  end

end
