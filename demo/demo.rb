$LOAD_PATH.unshift File.expand_path '../lib'
require File.expand_path('../../lib/flamegraph', __FILE__)

def ack(m, n)
  if (m == 0)
    n + 1
  elsif (n == 0)
    ack(m - 1, 1)
  else
    ack(m - 1, ack(m, n - 1))
  end
end

# graph = Flamegraph.generate do
#   ack(3,7)
# end

Flamegraph.generate("graph.html") do
  ack(3,7)
end

