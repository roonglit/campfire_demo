module Campfire
  module User::Role
    extend ActiveSupport::Concern

    included do
      enum :role, %i[ member administrator bot ]
    end

    def can_administer?(record = nil)
      administrator? || self == record&.creator || record&.new_record?
    end
  end
end