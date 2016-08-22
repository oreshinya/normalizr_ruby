require 'active_support/core_ext/class/attribute'
require "normalizr_ruby/version"

module NormalizrRuby
  include ActiveSupport::Configurable
  config_accessor :key_transform do
    :camel_lower
  end
end
