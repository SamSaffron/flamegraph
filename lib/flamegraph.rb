require "json"
require "flamegraph/version"
require "flamegraph/sampler"
require "flamegraph/renderer"

module Flamegraph
  def self.generate(filename=nil)
    sampler = Flamegraph::Sampler.new
    sampler.start
    yield
    results = sampler.finish

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
