module Campfire
  class SidebarsController < ApplicationController
    def show
      all_memberships = current_campfire_user.memberships.includes(:room).order("campfire_rooms.updated_at DESC")
      @direct_memberships = all_memberships.select { |m| m.room.is_a?(Rooms::Direct) }
      @other_memberships = all_memberships.reject { |m| m.room.is_a?(Rooms::Direct) }
    end
  end
end
