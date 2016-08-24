require "action_controller"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/hash/except"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/object/blank"
require "active_support/configurable"
require "active_support/concern"


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
