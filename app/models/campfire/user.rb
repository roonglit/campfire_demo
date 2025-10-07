module Campfire
  class User < ApplicationRecord
    # Reference parent app's User model
    belongs_to :user, class_name: "::User"

    enum :role, { member: 0, administrator: 1, bot: 2 }

    scope :active, -> { where(active: true) }
    scope :ordered, -> { joins(:user).order("LOWER(users.email)") }

    # Delegate authentication fields to parent app's User
    delegate :email, to: :user
    delegate :id, to: :user, prefix: true

    # Helper method for display name (fallback to email if name not present)
    def name
      user.try(:name) || email
    end

    has_many :memberships, dependent: :delete_all
    has_many :rooms, through: :memberships
    has_many :messages, dependent: :destroy, foreign_key: :creator_id

    # Auto-create Campfire::User when onerev user first accesses chat
    def self.find_or_create_for(parent_user)
      find_or_create_by(user: parent_user) do |campfire_user|
        campfire_user.role = :member
        campfire_user.active = true
      end
    end

    def initials
      name.scan(/\b\w/).join.presence || email[0].upcase
    end

    def title
      [name, bio].compact_blank.join(" – ")
    end

    def deactivated?
      !active?
    end
  end
end
