require "./test/test_helper"
require_relative "../lib/team"

class TeamTest < Minitest::Test

  def setup
    @team = Team.new({
      team_id:        1,
      teamname:       "Atlanta United"
    })
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_attributes
    assert_equal 1, @team.team_id
    assert_equal "Atlanta United", @team.team_name
  end

end
