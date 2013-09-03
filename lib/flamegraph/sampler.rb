class Flamegraph::Sampler
  def self.collect(fidelity=0.5)
    backtraces = []
    done = false

    t = Thread.current
    thread = Thread.new do
      until done
        backtraces << t.backtrace_locations

        # On my machine using Ruby 2.0 this give me excellent fidelity of stack trace per 1.2ms
        #   with this fidelity analysis becomes very powerful
        sleep (fidelity / 1000.0)
      end
    end

    begin
      yield
    ensure
      done = true
      thread.join
    end

    backtraces
  end
end
