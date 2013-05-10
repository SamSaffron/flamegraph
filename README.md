# Flamegraph

Flamegraph support for arbitrary Ruby apps

## Installation

Add this line to your application's Gemfile:

    gem 'flamegraph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flamegraph

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
