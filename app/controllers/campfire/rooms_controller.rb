module Campfire
  class RoomsController < ApplicationController
    before_action :set_room, only: %i[ show edit update destroy ]

    def index
      # Auto-grant access to open rooms for current user
      grant_access_to_open_rooms

      @rooms = current_campfire_user.rooms.ordered
    end

    def show
    end

    def new
      @room = Room.new
    end

    def create
      @room = Room.create_for(room_params.merge(creator: current_campfire_user), users: current_campfire_user)

      redirect_to room_path(@room), notice: "Room created successfully"
    rescue ActiveRecord::RecordInvalid => e
      render :new, status: :unprocessable_entity
    end

    def edit
    end

    def update
      @room.update!(room_params)
      redirect_to room_path(@room), notice: "Room updated successfully"
    rescue ActiveRecord::RecordInvalid => e
      render :edit, status: :unprocessable_entity
    end

    def destroy
      @room.destroy
      redirect_to rooms_path, notice: "Room deleted successfully"
    end

    private
      def set_room
        if room = current_campfire_user.rooms.find_by(id: params[:id])
          @room = room
        else
          redirect_to rooms_path, alert: "Room not found or inaccessible"
        end
      end

      def room_params
        params.require(:room).permit(:name, :type)
      end

      def grant_access_to_open_rooms
        Campfire::Rooms::Open.find_each do |open_room|
          open_room.grant_access_to_user_if_needed(current_campfire_user)
        end
      end
  end
end
