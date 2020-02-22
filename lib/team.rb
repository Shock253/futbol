class Team
  attr_reader :team_id,
              :franchiseId,
              :teamName,
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
end
