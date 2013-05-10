class Flamegraph::Sampler

  def initialize
    @backtraces = []
    @done_samplint = false
  end

  def start
    @backtraces = []
    @done_samplint = false

    t = Thread.current
    @thread = Thread.new do
      begin
        while !@done_sampling
          @backtraces << t.backtrace_locations

          # On my machine using Ruby 2.0 this give me excellent fidelity of stack trace per 1.2ms
          #   with this fidelity analysis becomes very powerful
          sleep 0.0005
        end
      end
    end
  end

  def finish
    @done_sampling = true
    @thread.join
    @backtraces
  end

end
