module Campfire
  module Message::Broadcasts
    def broadcast_create
      broadcast_append_to room, :messages, target: [ room, :messages ]
    end
  end
end
