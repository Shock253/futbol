class Game
  attr_reader :game_id,
              :season,
              :type,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals

  def initialize(game_params)
    @game_id        = game_params[:game_id].to_i
    @season         = game_params[:season]
    @type           = game_params[:type]
    @away_team_id   = game_params[:away_team_id].to_i
    @home_team_id   = game_params[:home_team_id].to_i
    @away_goals     = game_params[:away_goals].to_i
    @home_goals     = game_params[:home_goals].to_i
  end

  def total_goals
    @home_goals + @away_goals
  end

  def home_win?
    @home_goals > @away_goals
  end

  def away_win?
    @home_goals < @away_goals
  end

  def tie?
    @home_goals == @away_goals
  end
end
