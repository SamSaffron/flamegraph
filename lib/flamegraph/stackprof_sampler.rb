class Flamegraph::StackProfSampler
  def self.collect(fidelity=0.5)

    result = StackProf.run(mode: :wall,
                           raw: true,
                           aggregate: false,
                           interval: (fidelity * 1000).to_i) do
      yield
    end


    stacks = []
    stack = []

    return [] unless result && result[:raw]

    length = nil
    result[:raw].each do |i|
      if length.nil?
        length = i
        next
      end

      if length > 0
        frame = result[:frames][i]
        frame = "#{frame[:file]}:#{frame[:line]}:in `#{frame[:name]}'"
        stack << frame.to_s
        length -= 1
        next
      end

      i.times do
        stacks << stack.reverse
      end

      stack = []
      length = nil
    end

    stacks
  end
end
