class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :powerPlayOpportunities,
              :powerPlayGoals,
              :faceOffWinPercentage,
              :giveaways,
              :takeaways

  def initialize(season_params)
    @game_id = season_params[:game_id].to_i
    @team_id = season_params[:team_id].to_i
    @hoa = season_params[:hoa]
    @result = season_params[:result]
    @settled_in = season_params[:settled_in]
    @head_coach = season_params[:head_coach]
    @goals = season_params[:goals].to_i
    @shots = season_params[:shots].to_i
    @tackles = season_params[:tackles].to_i
    @pim = season_params[:pim].to_i
    @powerPlayOpportunities = season_params[:powerPlayOpportunities].to_i
    @powerPlayGoals = season_params[:powerPlayGoals].to_i
    @faceOffWinPercentage = season_params[:faceOffWinPercentage].to_i
    @giveaways = season_params[:giveaways].to_i
    @takeaways = season_params[:takeaways].to_i
  end
end
