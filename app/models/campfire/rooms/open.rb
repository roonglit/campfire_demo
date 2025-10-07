module Campfire
  module Rooms
    # Rooms open to all users. When a new user accesses chat, they're automatically granted membership.
    class Open < Room
      after_save_commit :grant_access_to_all_users

      private
        def grant_access_to_all_users
          memberships.grant_to(User.active) if type_previously_changed?(to: "Campfire::Rooms::Open")
        end
    end
  end
end
