require "active_support"
require "action_controller"

module NormalizrRuby
  include ActiveSupport::Configurable
  config_accessor :key_transform do
    :camel_lower
  end
end

require "normalizr_ruby/version"
require "normalizr_ruby/key_transform"
require "normalizr_ruby/schema"
require "normalizr_ruby/converter"
require "normalizr_ruby/normalizable"
