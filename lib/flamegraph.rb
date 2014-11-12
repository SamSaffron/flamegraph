require "json"

if RUBY_VERSION >= "2.1.0".freeze
  begin
    require "flamegraph/stackprof_sampler"
    require "stackprof"
  rescue
    STDERR.puts "Please require the fast_stack gem"
  end
else
  begin
    require "fast_stack"
  rescue
    STDERR.puts "Please require the stackprof gem, note flamegraph is only supported on Ruby 2.0 and above"
  end
end

require "flamegraph/version"
require "flamegraph/renderer"

module Flamegraph
  def self.generate(filename=nil, opts = {})
    fidelity = opts[:fidelity]  || 0.5

    backtraces =
      if defined? StackProf
        StackProfSampler.collect(fidelity) do
          yield
        end
      else
        FastStack.profile(fidelity) do # , opts[:mode] || :ruby) do
          yield
        end
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
