# Flamegraph

Flamegraph support for arbitrary Ruby apps.

Note, flamegraph support is built in to rack-mini-profiler, just require this gem and you should be good to go. 
Type ?pp=flamegraph to create one for the current page.

## Installation

Add this line to your application's Gemfile:

    gem 'flamegraph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flamegraph

NOTE: For ruby 2.1+ you'll need to install a [stackprof](https://github.com/tmm1/stackprof) gem:

    $ gem install stackprof
    
## Usage

Note: Only supported on Ruby 2.0. Gathering stack traces is too slow on earlier versions of Ruby or JRuby

```ruby

require 'flamegraph'
html = Flamegraph.generate do
  # your work here
end

# or


Flamegraph.generate(filename) do
  # your work here
end

```

You can also pass some options:

```ruby

# will hide bottom x lines of the graph
Flamegraph.generate(filename, hide_x_bottom_lines: 20) do
  # your work here
end

# will order stacktraces alphabetically, like the original Flamegraph (https://github.com/brendangregg/FlameGraph) does
Flamegraph.generate(filename, sort_alphabetically: true) do
  # your work here
end

```

## Demo

Demo of: https://github.com/SamSaffron/flamegraph/blob/master/demo/demo.rb

http://samsaffron.github.io/flamegraph/demo.html

Demo of Discourse startup using: https://github.com/SamSaffron/flamegraph/blob/master/demo/rails_startup.rb

**WARNING VERY SLOW, MAY CRASH BROWSER TAB**
http://samsaffron.github.io/flamegraph/rails-startup.html

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
