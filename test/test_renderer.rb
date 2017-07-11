require 'test_helper'

class TestRenderer < Minitest::Test

  def test_builds_table_correctly
    stacks = [["3","2","1"],["4","1"],["4","5"]]

    g = Flamegraph::Renderer.new(stacks)
    data = g.graph_data

    assert_equal([ "1", "2", "3", "4", "5" ], data[:frames])
    assert_equal([
        {:x => 1, :y => 1, :frame_id => 0, :width => 2},
        {:x => 1, :y => 2, :frame_id => 1, :width => 1},
        {:x => 1, :y => 3, :frame_id => 2, :width => 1},
        {:x => 2, :y => 2, :frame_id => 3, :width => 1},
        {:x => 3, :y => 1, :frame_id => 4, :width => 1},
        {:x => 3, :y => 2, :frame_id => 3, :width => 1}
    ], data[:data])
  end

  def test_builds_table_correctly_for_different_grandparents
    stacks = [["method4","method3","method1"],["method4","method3","method1"],["method4","method3","method2"]]

    g = Flamegraph::Renderer.new(stacks)
    data = g.graph_data

    assert_equal(["method1", "method3", "method4", "method2"], data[:frames])
    assert_equal([
        {:x => 1, :y => 1, :frame_id => 0, :width => 2},
        {:x => 1, :y => 2, :frame_id => 1, :width => 2},
        {:x => 1, :y => 3, :frame_id => 2, :width => 2},
        {:x => 3, :y => 1, :frame_id => 3, :width => 1},
        {:x => 3, :y => 2, :frame_id => 1, :width => 1},
        {:x => 3, :y => 3, :frame_id => 2, :width => 1}
    ], data[:data])

  end

  def test_avoids_bridges
    stacks = [["3","2","1"],["4","1"],["4","5"]]

    g = Flamegraph::Renderer.new(stacks)
    data = g.graph_data

    assert_equal([ "1", "2", "3", "4", "5" ], data[:frames])
    assert_equal([
        {:x => 1, :y => 1, :frame_id => 0, :width => 2},
        {:x => 1, :y => 2, :frame_id => 1, :width => 1},
        {:x => 1, :y => 3, :frame_id => 2, :width => 1},
        {:x => 2, :y => 2, :frame_id => 3, :width => 1},
        {:x => 3, :y => 1, :frame_id => 4, :width => 1},
        {:x => 3, :y => 2, :frame_id => 3, :width => 1}
    ], data[:data])
  end

end

