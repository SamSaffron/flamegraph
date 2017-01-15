require "json"

require "flamegraph/version"
require "flamegraph/renderer"
require "flamegraph/sampler"

module Flamegraph
  def self.generate(filename=nil, opts = {})
    fidelity = opts[:fidelity]  || 0.5

    backtraces =
      if defined? StackProf
        require "flamegraph/stackprof_sampler" unless defined? StackProfSampler
        stack_prof_opt = {}
        if opts[:filter_path]
          stack_prof_opt[:filter] = /^#{Array(opts[:filter_path]).map{|p| Regexp.escape(p.to_s) }.join('|')}/
        end
        StackProfSampler.collect(fidelity, stack_prof_opt) do
          yield
        end
      elsif defined? FastStack
        FastStack.profile(fidelity) do # , opts[:mode] || :ruby) do
          yield
        end
      else
        Sampler.collect(fidelity) do
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
