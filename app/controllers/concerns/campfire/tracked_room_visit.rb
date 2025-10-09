module Campfire
  module TrackedRoomVisit
    extend ActiveSupport::Concern

    included do
      helper_method :last_room_visited
    end

    def remember_last_room_visited
      cookies.permanent[:last_room] = @room.id
    end

    def last_room_visited
      current_campfire_user.rooms.find_by(id: cookies[:last_room]) || default_room
    end

    private
      def default_room
        current_campfire_user.rooms.original
      end
  end
end