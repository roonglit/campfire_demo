module Campfire
  module Message::Broadcasts
    def broadcast_create
      broadcast_append_to room, :messages,
        target: "messages",
        partial: "campfire/messages/message",
        locals: { message: self }
    end
  end
end
