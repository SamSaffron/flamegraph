require 'flamegraph'

Flamegraph.generate("graph.html") do
  ENV['RAILS_ENV'] = 'profile'
  require File.expand_path(File.dirname(__FILE__) + "/config/environment")

  I18n.t("test")
end
