$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "normalizr_ruby"

require "support/setup_database"
Dir["#{File.dirname(__FILE__)}/support/models/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/support/schemas/*.rb"].each { |f| require f }

require "minitest/autorun"
require "minitest/pride"
require "minitest-power_assert"
