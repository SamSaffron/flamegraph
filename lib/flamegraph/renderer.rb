# inspired by https://github.com/brendangregg/FlameGraph
require 'base64'

class Flamegraph::Renderer
  def initialize(stacks)
    @stacks = stacks
  end

  def graph_html(embed_resources)
    body = read('flamegraph.html')
    body.sub! "/**INCLUDES**/",
      if embed_resources
        embed("jquery.min.js","d3.min.js","lodash.min.js")
      else
        '<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/1.3.1/lodash.min.js"></script>'
      end

    body.sub!("/**DATA**/", ::JSON.generate(graph_data));
    body
  end

  def graph_data
    table = []
    prev = []

    # a 2d array makes collapsing easy
    @stacks.each_with_index do |stack, pos|

      next unless stack

      col = []

      stack.reverse.map{|r| r.to_s}.each_with_index do |frame, i|

        if !prev[i].nil?
          last_col = prev[i]
          if last_col[0] == frame
            last_col[1] += 1
            col << nil
            next
          end
        end

        prev[i] = [frame, 1]
        col << prev[i]
      end
      prev = prev[0..col.length-1].to_a
      table << col
    end

    data = []

    # a 1d array makes rendering easy
    table.each_with_index do |col, col_num|
      col.each_with_index do |row, row_num|
        next unless row && row.length == 2
        data << {
          :x => col_num + 1,
          :y => row_num + 1,
          :width => row[1],
          :frame => row[0]
        }
      end
    end

    data
  end

  private

  def embed(*files)
    out = ""
    files.each do |file|
      body = read(file)
      out << "<script src='data:text/javascript;base64," << Base64.encode64(body) << "'></script>"
    end
    out
  end

  def read(file)
    IO.read(::File.expand_path(file, ::File.dirname(__FILE__)))
  end

end

