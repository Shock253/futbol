class Team
  attr_reader :team_id,
              :franchiseId,
              :team_name,
              :abbreviation,
              :stadium,
              :link

  def initialize (team_params)
    @team_id        = team_params[:team_id].to_i
    @franchiseId    = team_params[:franchiseid].to_i
    @teamName       = team_params[:teamname]
    @abbreviation   = team_params[:abbreviation]
    @stadium        = team_params[:stadium]
    @link           = team_params[:link]
  end

  def all_games_played
    home_games + away_games
  end

  def total_games_played
    home_games.length + away_games.length
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

  def average_away_goals(game_collection, team_id)
    total_goals = away_games_by_team(game_collection, team_id).sum do | game |
      game.away_goals
    end
    away_games = num_of_away_games(game_collection, team_id)
    average = 0.0
    average = total_goals.to_f / away_games if away_games != 0
    average
  end

  def goals_against(collection)
    return 0.0 if collection.length == 0
    away_goals_against = collection.find_all {|game| game.home_team_id == team_id}
    home_goals_against = collection.find_all {|game| game.away_team_id == team_id}
    ((away_goals_against.sum(away_goals).to_f + home_goals_against.sum(home_goals)))
  end

  def average_total_goals
    average_away_goals + average_home_goals
  end

  def average_total_goals_against
    average_away_goals + average_home_goals
  end

  def best_offense
		teams.max_by(average_total_goals).team_name
  end

	def worst_offense
		teams.min_by(average_total_goals).team_name
	end

  def best_defense
		teams.min_by(goals_against).team_name
	end

	def worst_defense
		teams.max_by(goals_against).team_name
  end
end
