module Campfire
  class Engine < ::Rails::Engine
    isolate_namespace Campfire

    config.generators do |g|
      g.orm :active_record
      g.test_framework :test_unit
    end

    # Make Devise and Turbo helpers available in the engine
    config.to_prepare do
      Campfire::ApplicationController.include Devise::Controllers::Helpers if defined?(Devise)

      # Include Turbo helpers in both controllers and helpers
      if defined?(Turbo)
        Campfire::ApplicationController.include Turbo::Streams::StreamName
        Campfire::ApplicationHelper.include Turbo::StreamsHelper
        Campfire::ApplicationHelper.include Turbo::FramesHelper
      end
    end

    # Add engine's JavaScript path to asset pipeline load paths
    initializer "campfire.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end

    # Configure ActionCable to use the engine's channels
    initializer "campfire.action_cable" do
      ActiveSupport.on_load(:action_cable) do
        self.connection_class = -> { Campfire::ApplicationCable::Connection }
      end
    end
  end
end
