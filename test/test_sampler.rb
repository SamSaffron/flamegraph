require 'test_helper'
require 'flamegraph/sampler'

class TestSampler < Minitest::Test

  def test_sample_collection
    samples = Flamegraph::Sampler.collect do
      sleep 0.005
    end

    assert(samples.count > 3, "Should get more than 3 samples in 5 millisecs")
  end

  def test_fidelity
    samples = Flamegraph::Sampler.collect(10) do
      sleep 0.005
    end

    assert(samples.count <= 1, "Should get a max of 1 sample got #{samples.count}")
  end

end

