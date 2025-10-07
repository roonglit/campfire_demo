module Campfire
  class MessagesController < ApplicationController
    before_action :set_room
    before_action :set_message, only: %i[ edit update destroy ]

    def create
      @message = @room.messages.create!(message_params.merge(creator: current_campfire_user))

      redirect_to room_path(@room), notice: "Message posted"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to room_path(@room), alert: "Error: #{e.message}"
    end

    def edit
    end

    def update
      @message.update!(message_params)
      redirect_to room_path(@room), notice: "Message updated"
    end

    def destroy
      @message.destroy
      redirect_to room_path(@room), notice: "Message deleted"
    end

    private
      def set_room
        @room = current_campfire_user.rooms.find(params[:room_id])
      end

      def set_message
        @message = @room.messages.find(params[:id])
      end

      def message_params
        params.require(:message).permit(:body)
      end
  end
end
