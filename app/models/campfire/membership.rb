module Campfire
  class Membership < ApplicationRecord
    belongs_to :room
    belongs_to :user

    enum :involvement, %w[ invisible nothing mentions everything ].index_by(&:itself), prefix: :involved_in

    scope :with_ordered_room, -> { includes(:room).joins(:room).order("LOWER(campfire_rooms.name)") }
    scope :without_direct_rooms, -> { joins(:room).where.not(room: { type: "Campfire::Rooms::Direct" }) }

    scope :visible, -> { where.not(involvement: :invisible) }
    scope :unread,  -> { where.not(unread_at: nil) }
    scope :connected, -> { where("connections > 0") }
    scope :disconnected, -> { where(connections: 0) }

    def read
      update!(unread_at: nil)
    end

    def unread?
      unread_at.present?
    end
  end
end
