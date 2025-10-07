module Campfire
  class Message < ApplicationRecord
    include Broadcasts

    belongs_to :room, touch: true
    belongs_to :creator, class_name: "User"

    has_rich_text :body

    before_create -> { self.client_message_id ||= SecureRandom.uuid }
    after_create_commit -> { room.receive(self) }

    scope :ordered, -> { order(:created_at) }
    scope :with_creator, -> { preload(:creator) }

    def plain_text_body
      body.to_plain_text.presence || ""
    end

    def to_key
      [ client_message_id ]
    end
  end
end
