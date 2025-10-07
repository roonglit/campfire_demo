module Campfire
  class DirectsController < ApplicationController
    def new
      @users = User.where.not(id: current_user.id).order(:email)
    end

    def create
      other_user = User.find(params[:user_id])
      campfire_other_user = Campfire::User.find_or_create_for(other_user)

      room = Campfire::Rooms::Direct.find_or_create_for([current_campfire_user, campfire_other_user])

      redirect_to room_path(room)
    end
  end
end
