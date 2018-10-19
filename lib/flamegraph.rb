require "json"

if RUBY_VERSION >= "2.1.0".freeze
  begin
    require "stackprof"
  rescue LoadError
    STDERR.puts "Please require the stackprof gem falling back to fast_stack"
    require "fast_stack"
  end
else
  begin
    require "fast_stack"
  rescue LoadError
    unless RUBY_PLATFORM == 'java'
      STDERR.puts "Please require the fast_stack gem, note flamegraph is only supported on Ruby 2.0 and above"
    end
  end
end

require "flamegraph/version"
require "flamegraph/renderer"
require "flamegraph/sampler"

begin
  require "flamegraph/active_record_sql_recorder"
rescue
end

module Flamegraph
  def self.generate(filename=nil, opts = {})
    Thread.current[:sql_flame] = true

    fidelity = opts[:fidelity]  || 0.33

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

    renderer = Flamegraph::Renderer.new(backtraces, opts)
    rendered = renderer.graph_html(embed_resources)

    if filename
      File.open(filename,"w") do |f|
        f.write(rendered)
      end
    end
    rendered
  ensure
    Thread.current[:sql_flame] = nil
  end
end
