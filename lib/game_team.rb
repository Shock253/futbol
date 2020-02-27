class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :head_coach,
              :goals,
              :shots,
              :tackles

  def initialize(season_params)
    @game_id = season_params[:game_id].to_i
    @team_id = season_params[:team_id].to_i
    @hoa = season_params[:hoa]
    @result = season_params[:result]
    @head_coach = season_params[:head_coach]
    @goals = season_params[:goals].to_i
    @shots = season_params[:shots].to_i
    @tackles = season_params[:tackles].to_i
  end
end
