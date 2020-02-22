require_relative './team'
require 'CSV'

class TeamCollection

  attr_reader :teams

  def initialize(csv_file_path)
    @teams = create_teams(csv_file_path)
  end

  def create_teams(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
       Team.new(row)
    end
  end

  def find_team_by_id(id)
    @teams.find do |team|
      team.team_id == id
    end
  end
end
