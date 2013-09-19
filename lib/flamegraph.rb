require "json"
require "fast_stack"
require "flamegraph/version"
require "flamegraph/renderer"

module Flamegraph
  def self.generate(filename=nil, opts = {})
    fidelity = opts[:fidelity]  || 0.5

    backtraces = FastStack.profile(fidelity) do
      yield
    end

    embed_resources = (filename && !opts.key?(:embed_resources)) || opts[:embed_resources]

    renderer = Flamegraph::Renderer.new(backtraces)
    rendered = renderer.graph_html(embed_resources)

    if filename
      File.open(filename,"w") do |f|
        f.write(rendered)
      end
    end
    rendered
  end
end
