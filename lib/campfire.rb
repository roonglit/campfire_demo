require "campfire/version"
require "campfire/engine"

# Require dependencies
require "devise"
require "importmap-rails"
require "turbo-rails"

# Require extensions
require "campfire/rails_ext/string"

module Campfire
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_reader :importmap

    def initialize
      @importmap = Importmap::Map.new
      @importmap.draw(Engine.root.join("config/importmap.rb"))
    end
  end

  def self.init_config
    self.configuration ||= Configuration.new
  end
end

# Initialize configuration when engine loads
Campfire.init_config
