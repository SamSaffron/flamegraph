require 'test_helper'

class TestRenderer < Minitest::Test

  def test_builds_table_correctly
    stacks = [["3","2","1"],["4","1"],["4","5"]]

    g = Flamegraph::Renderer.new(stacks)
    assert_equal([
        {:x => 1, :y => 1, :frame => "1", :width => 2},
        {:x => 1, :y => 2, :frame => "2", :width => 1},
        {:x => 1, :y => 3, :frame => "3", :width => 1},
        {:x => 2, :y => 2, :frame => "4", :width => 2},
        {:x => 3, :y => 1, :frame => "5", :width => 1}
    ], g.graph_data)

  end

  def test_avoids_bridges
    stacks = [["3","2","1"],["4","1"],["4","5"]]

    g = Flamegraph::Renderer.new(stacks)

    assert_equal([
        {:x => 1, :y => 1, :frame => "1", :width => 2},
        {:x => 1, :y => 2, :frame => "2", :width => 1},
        {:x => 1, :y => 3, :frame => "3", :width => 1},
        {:x => 2, :y => 2, :frame => "4", :width => 2},
        {:x => 3, :y => 1, :frame => "5", :width => 1}
    ], g.graph_data)


  end

end

