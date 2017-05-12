# inspired by https://github.com/brendangregg/FlameGraph
require 'base64'

class Flamegraph::Renderer
  def initialize(stacks, opts = {})
    @stacks = stacks
    @opts = opts
  end

  def graph_html(embed_resources)
    body = read('flamegraph.html')
    body.sub! "/**INCLUDES**/",
      if embed_resources
        embed(
          "semantic.min.css", "jquery.min.js", "d3.min.js", "lodash.min.js", "semantic.min.js", 
          "handlebars.min.js", "keyboard.min.js", "randomColor.min.js", "clipboard.min.js", "tinycolor.min.js"
        )
      else
        '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.10/semantic.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/1.3.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.10/semantic.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.6/handlebars.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/keyboardjs/2.3.3/keyboard.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/randomcolor/0.5.2/randomColor.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.6.0/clipboard.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tinycolor/1.4.1/tinycolor.min.js"></script>'
      end

    body.sub!("/**DATA**/", ::JSON.generate(graph_data));
    body.sub!("/**JS_INCLUDE_FILTERS**/", ::JSON.generate(@opts[:js_include_filters] || []));
    body.sub!("/**JS_EXCLUDE_FILTERS**/", ::JSON.generate(@opts[:js_exclude_filters] || []));
    body
  end

  def graph_data
    @graph_data ||=
      begin
        table = []
        prev = []
        prev_parent = []

        # a 2d array makes collapsing easy
        @stacks.each_with_index do |stack, pos|

          next unless stack

          col = []
          new_col = false

          reversed_stack = stack.reverse
          reversed_stack.map{|r| r.to_s}.each_with_index do |frame, i|
            parent_frame = i > 0 ? reversed_stack[i - 1] : nil

            if !prev[i].nil? && !new_col
              last_col = prev[i]
              frame_match = last_col[0] == frame
              parent_match = parent_frame.nil? || prev_parent[i].nil? || parent_frame == prev_parent[i]

              if frame_match && parent_match
                last_col[1] += 1
                col << nil
                next
              else
                new_col = true
              end
            end

            prev[i] = [frame, 1]
            prev_parent[i] = parent_frame
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
  end

  private

  def embed(*files)
    out = ""
    files.each do |file|
      body = read(file)
      if file =~ /\.js$/
        out << "<script src='data:text/javascript;base64," << Base64.encode64(body) << "'></script>"
      elsif file =~ /\.css$/
        out << "<link rel='stylesheet' href='data:text/css;base64," << Base64.encode64(body) << "' />"
      end
    end
    out
  end

  def read(file)
    IO.read(::File.expand_path(file, ::File.dirname(__FILE__)))
  end

end

