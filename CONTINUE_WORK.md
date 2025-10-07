# Campfire Engine - Work Continuation Guide

## What We're Building
We're converting the once-campfire chat application into a Rails Engine that integrates with the onerev Rails app. This is an MVP focused on basic chat functionality: users can join rooms and chat with each other.

## Current Status
- ✅ **Phase 0**: Foundation - Engine created, Devise integrated, basic setup complete
- ✅ **Phase 1**: Room Management - Room, Membership models created with STI for room types
- ✅ **Phase 2**: Messaging - Message model with ActionText, MessagesController, basic views
- ⏳ **Phase 3**: Real-time features (ActionCable) - NOT STARTED YET

Latest commit: `f939d51` - "Add messaging functionality with ActionText support"

## Key Architecture Decisions

### 1. Rails Engine Approach
- Engine name: `campfire`
- Mounted at: `/chat` in onerev app
- Database: SQLite (separate from onerev's PostgreSQL)
- Namespace: `Campfire::` for all models/controllers

### 2. Authentication Strategy
- Engine delegates to parent app's Devise authentication
- Separate `campfire_users` table with FK to `users` table
- `Campfire::User.find_or_create_for(parent_user)` auto-creates campfire user on first access
- `current_campfire_user` helper available in all engine controllers

### 3. User Name Compatibility
- onerev's User model only has `email` field (no `name`)
- `Campfire::User#name` falls back to email if parent User lacks name
- All views and scopes use `email` directly or through name method

### 4. Room Types (STI Pattern)
- `Campfire::Rooms::Open` - auto-grants access to all users
- `Campfire::Rooms::Closed` - explicit membership only
- `Campfire::Rooms::Direct` - for direct messages (1-on-1)

## File Locations

### Engine Code (campfire/)
- Models: `app/models/campfire/`
- Controllers: `app/controllers/campfire/`
- Views: `app/views/campfire/`
- Routes: `config/routes.rb`
- Migrations: `db/migrate/`

### Test/Dummy App (campfire/test/dummy/)
- Used for testing the engine in isolation
- Has its own database with Devise installed
- Migrations: `test/dummy/db/migrate/`

### Integration (onerev/)
- Mount: `config/routes.rb` has `mount Campfire::Engine => "/chat"`
- Gemfile: `gem "campfire", path: "campfire"`
- User needs to run migrations: `bin/rails campfire:install:migrations && bin/rails db:migrate`

## How to Continue Work

### 1. Read the Plan
```bash
# Check overall progress and next steps
cat /home/mac/developments/onerev/CAMPFIRE_ENGINE_PLAN.md
```

### 2. Verify Current State
```bash
# In campfire engine directory
cd /home/mac/developments/onerev/campfire
git log --oneline -5  # Check recent commits

# In onerev app directory
cd /home/mac/developments/onerev
bin/rails db:migrate:status | grep campfire  # Check if migrations are run
```

### 3. Test Current Functionality
```bash
# Start onerev server
cd /home/mac/developments/onerev
bin/dev

# Visit: http://localhost:3000/chat
# Should see room list and be able to post messages
```

### 4. Working in Engine vs Parent App
- **Engine work** (models, controllers, views): Work in `campfire/` directory
- **Migrations**: Create in `campfire/db/migrate/`, then copy to onerev with `bin/rails campfire:install:migrations`
- **Integration work**: Work in `onerev/` directory

## Common Patterns

### Creating a Migration in Engine
```bash
cd /home/mac/developments/onerev/campfire
bin/rails g migration CreateCampfireSomething
# Edit the migration in campfire/db/migrate/
# Then in onerev app:
cd /home/mac/developments/onerev
bin/rails campfire:install:migrations
bin/rails db:migrate
```

### Adding a Model
```ruby
# campfire/app/models/campfire/something.rb
module Campfire
  class Something < ApplicationRecord
    # belongs_to :user means Campfire::User
    # For parent app's user, use: belongs_to :user, class_name: "::User"
  end
end
```

### Adding a Controller
```ruby
# campfire/app/controllers/campfire/somethings_controller.rb
module Campfire
  class SomethingsController < ApplicationController
    # current_campfire_user is available
    # current_user is the parent app's user (if using Devise)
  end
end
```

### Adding Routes
```ruby
# campfire/config/routes.rb
Campfire::Engine.routes.draw do
  resources :somethings
  # Routes are automatically namespaced: /chat/somethings
end
```

## Known Issues & Solutions

### Issue: "undefined method 'name'" for User
**Solution**: onerev's User only has email. Use `message.creator.email` or `user.name` (which falls back to email)

### Issue: ActionText tables missing
**Solution**: Run `bin/rails action_text:install` in `campfire/test/dummy/` for engine testing

### Issue: Migrations not appearing in onerev
**Solution**: Run `bin/rails campfire:install:migrations` from onerev directory

### Issue: Can't see rooms
**Solution**: Create a room in Rails console:
```ruby
user = User.first
campfire_user = Campfire::User.find_or_create_for(user)
room = Campfire::Rooms::Open.create!(name: "General", creator: campfire_user)
```

## Next Steps (Phase 3)
See CAMPFIRE_ENGINE_PLAN.md for full details. Next major tasks:
1. ActionCable integration for real-time updates
2. Message broadcasting when created
3. Turbo Streams for instant message display
4. Presence tracking (who's online)

## Testing Strategy
1. Work in engine (`campfire/`) and test in dummy app first
2. Once working, copy migrations to onerev and test integration
3. User handles onerev integration verification

## Commit Strategy
- Commit frequently at task boundaries
- Use descriptive messages explaining what was added/fixed
- Include "🤖 Generated with Claude Code" footer
- User will request commits explicitly

## Important Reminders
- Engine uses SQLite, parent app uses PostgreSQL - this is intentional
- Always namespace models/controllers with `Campfire::`
- `current_campfire_user` not `current_user` in engine code
- Work on engine code in `campfire/`, not `onerev/`
- User will verify work after each phase
