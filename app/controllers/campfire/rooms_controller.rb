module Campfire
  class RoomsController < ApplicationController
    before_action :set_room, only: %i[ show ]

    def index
      @rooms = current_campfire_user.rooms.ordered
    end

    def show
      # Will add messages later in Phase 2
    end

    private
      def set_room
        if room = current_campfire_user.rooms.find_by(id: params[:id])
          @room = room
        else
          redirect_to main_app.root_url, alert: "Room not found or inaccessible"
        end
      end
  end
end
