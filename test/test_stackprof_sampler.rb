if RUBY_VERSION >= "2.1.0"

  require 'stackprof'
  require 'test_helper'
  require 'flamegraph/stackprof_sampler'

  class TestStackprofSampler < Minitest::Test

    def idle(duration)
      r, w = IO.pipe
      IO.select([r], nil, nil, duration)
    ensure
      r.close
      w.close
    end

    def test_sample_collection

      samples = Flamegraph::StackProfSampler.collect do
        idle 0.005
      end

      assert(samples.count > 3, "Should get more than 3 samples in 5 millisecs")
    end

    def test_fidelity
      samples = Flamegraph::StackProfSampler.collect(10) do
        idle 0.005
      end

      assert(samples.count <= 1, "Should get a max of 1 sample got #{samples.count}")
    end

  end

end
