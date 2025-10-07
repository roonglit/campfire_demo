module Campfire
  module Rooms
    # Rooms open to all users. When a new user accesses chat, they're automatically granted membership.
    class Open < Room
      after_create_commit :grant_access_to_all_users

      def grant_access_to_user_if_needed(campfire_user)
        unless users.include?(campfire_user)
          memberships.grant_to([campfire_user])
        end
      end

      private
        def grant_access_to_all_users
          # Grant access to all existing Campfire users when room is created
          all_campfire_users = Campfire::User.all
          memberships.grant_to(all_campfire_users) if all_campfire_users.any?
        end
    end
  end
end
