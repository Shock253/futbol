require "CSV"
require_relative './game'

class Season
attr_reader :id, :games_in_season

  def self.from_csv(season, gt_path)
    season_ids = []
		season_storage = []
		CSV.foreach(season_path, :headers => true, header_converters: :symbol) do |row|
			season_ids.push(row[1])
		end
		season_ids.uniq.each {|id| season_storage.push(Season.new({id: id, path: season_path}, gt_path))}
		season_storage
  end

  def initialize(season_info)
    @id = season_info[:id]
    @games_in_season = games_getter(season_info[:path])
  end

  def count_of_games_by_season
		games_by_season = {}
		@seasons.each {|season| games_by_season[season.id.to_s] = season.total_games}
		games_by_season
	end

  def average_goals_by_season
    total_goals = Game.all.map {|game| game.total_score}
    return ((total_goals.sum.to_f / Game.length).round(2))
  end
end
