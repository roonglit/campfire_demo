module Campfire
  class Rooms::OpensController < ApplicationController
    def show
    end

    def new
    end

    def create
      room = Rooms::Open.create_for(room_params, users: [current_campfire_user])

      broadcast_create_room(room)
      redirect_to room_url(room)
    end
  end
end
