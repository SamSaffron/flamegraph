class Flamegraph::FastStackSampler
  def self.collect(fidelity=0.5)
    FastStack.profile(fidelity) do
      yield
    end
  end
end
