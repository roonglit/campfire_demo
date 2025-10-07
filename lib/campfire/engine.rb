module Campfire
  class Engine < ::Rails::Engine
    isolate_namespace Campfire

    config.generators do |g|
      g.orm :active_record
      g.test_framework :test_unit
    end

    # Make Devise helpers available in the engine
    config.to_prepare do
      Campfire::ApplicationController.include Devise::Controllers::Helpers if defined?(Devise)
    end
  end
end
