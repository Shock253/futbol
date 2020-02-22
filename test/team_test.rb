require "./test/test_helper"
require_relative "../lib/team"

class TeamTest < Minitest::Test

  def setup
    @team = Team.new({
      team_id:        1,
      franchiseid:    23,
      teamname:       "Atlanta United",
      abbreviation:   "ATL",
      stadium:        "Mercedes-Benz Stadium",
      link:           "/api/v1/teams/1"
      })
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_attributes
    assert_equal @team.team_id,        1
    assert_equal @team.franchiseId,    23
    assert_equal @team.teamName,       "Atlanta United"
    assert_equal @team.abbreviation,   "ATL"
    assert_equal @team.stadium,        "Mercedes-Benz Stadium"
    assert_equal @team.link,           "/api/v1/teams/1"

  end
end
