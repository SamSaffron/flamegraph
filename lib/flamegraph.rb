require "json"
require "fast_stack"
require "flamegraph/version"
require "flamegraph/sampler"
require "flamegraph/renderer"
require "flamegraph/fast_stack_sampler"

module Flamegraph
  def self.generate(filename=nil, opts = {})
    fidelity = opts[:fidelity]  || 0.5

    restuls = FastStack.profile(fidelity) do
      yield
    end

    renderer = Flamegraph::Renderer.new(results)
    result = renderer.graph_html

    if filename
      File.open(filename,"w") do |f|
        f.write(result)
      end
    end
    result
  end
end
