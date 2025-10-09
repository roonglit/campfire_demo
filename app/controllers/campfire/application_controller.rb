module Campfire
  class ApplicationController < ActionController::Base
    include TrackedRoomVisit
    include Turbo::Streams::Broadcasts, Turbo::Streams::StreamName

    before_action :authenticate_user!
    before_action :set_current_campfire_user

    # Get or create Campfire::User for current onerev user
    def current_campfire_user
      @current_campfire_user
    end
    helper_method :current_campfire_user

    private

    def set_current_campfire_user
      @current_campfire_user = Campfire::User.find_or_create_for(current_user) if user_signed_in?
    end
  end
end
