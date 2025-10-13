module Campfire
  class User < ApplicationRecord
    include Role

    has_many :memberships, dependent: :delete_all
    has_many :rooms, through: :memberships
  
    # Reference parent app's User model
    belongs_to :user, class_name: "::User"

    scope :active, -> { where(active: true) }
    scope :ordered, -> { order("LOWER(campfire_users.name)") }

    # Delegate authentication fields to parent app's User
    delegate :email, to: :user
    delegate :id, to: :user, prefix: true

    
    has_many :messages, dependent: :destroy, foreign_key: :creator_id

    # Auto-create Campfire::User when onerev user first accesses chat
    def self.find_or_create_for(parent_user)
      find_or_create_by(user: parent_user) do |campfire_user|
        campfire_user.name = parent_user.try(:name) || parent_user.email
        campfire_user.role = :member
        campfire_user.active = true
      end
    end

    # Override name to provide fallback to email if blank
    def name
      self[:name].presence || email
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
