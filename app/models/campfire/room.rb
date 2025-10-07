module Campfire
  class Room < ApplicationRecord
    has_many :memberships, dependent: :delete_all do
      def grant_to(users)
        room = proxy_association.owner
        Membership.insert_all(Array(users).collect { |user| { room_id: room.id, user_id: user.id, involvement: room.default_involvement } })
      end

      def revoke_from(users)
        destroy_by user: users
      end

      def revise(granted: [], revoked: [])
        transaction do
          grant_to(granted) if granted.present?
          revoke_from(revoked) if revoked.present?
        end
      end
    end

    has_many :users, through: :memberships
    has_many :messages, dependent: :destroy

    belongs_to :creator, class_name: "User"

    scope :opens,           -> { where(type: "Campfire::Rooms::Open") }
    scope :closeds,         -> { where(type: "Campfire::Rooms::Closed") }
    scope :directs,         -> { where(type: "Campfire::Rooms::Direct") }
    scope :without_directs, -> { where.not(type: "Campfire::Rooms::Direct") }

    scope :ordered, -> { order("LOWER(name)") }

    class << self
      def create_for(attributes, users:)
        transaction do
          create!(attributes).tap do |room|
            room.memberships.grant_to users
          end
        end
      end

      def original
        order(:created_at).first
      end
    end

    def receive(message)
      unread_memberships(message)
      # push_later(message) # TODO: Add later in Phase 8
    end

    def open?
      is_a?(Campfire::Rooms::Open)
    end

    def closed?
      is_a?(Campfire::Rooms::Closed)
    end

    def direct?
      is_a?(Campfire::Rooms::Direct)
    end

    def default_involvement
      "mentions"
    end

    private
      def unread_memberships(message)
        memberships.visible.disconnected.where.not(user: message.creator).update_all(unread_at: message.created_at, updated_at: Time.current)
      end

      # def push_later(message)
      #   Room::PushMessageJob.perform_later(self, message)
      # end
  end
end
