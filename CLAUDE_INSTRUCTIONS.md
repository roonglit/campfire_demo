# Instructions for Claude Code - Campfire Engine Development

## Context
You are working on converting the "once-campfire" chat application into a Rails Engine called "campfire" that integrates with the "onerev" Rails application. This is an MVP focused on basic chat: users can join rooms and chat with each other.

## Critical Files to Read First
When resuming work, read these files in order:

1. **CAMPFIRE_ENGINE_PLAN.md** (in onerev root) - Master plan with all phases and checkboxes
2. **CONTINUE_WORK.md** (in campfire/) - Architecture decisions, patterns, troubleshooting
3. **campfire/app/models/campfire/user.rb** - User model with parent app integration
4. **onerev/CLAUDE.md** - Parent app's project instructions

## Working Directory Rules

### When to work in `campfire/` directory:
- Creating/editing models, controllers, views
- Creating migrations
- Running tests (`bin/rails test`)
- Making commits

### When to work in `onerev/` directory:
- Running migrations (`bin/rails campfire:install:migrations && bin/rails db:migrate`)
- Testing integration (`bin/dev` to start server)
- Making integration commits (Gemfile, routes, etc.)

## Standard Workflow for New Features

1. **Read the plan**: Check CAMPFIRE_ENGINE_PLAN.md for current phase and tasks
2. **Work in engine**: cd to `/home/mac/developments/onerev/campfire`
3. **Create code**: Models, controllers, views, migrations
4. **Test in dummy app**: The test/dummy app is for engine testing
5. **Tell user what to verify**: Give specific URLs and expected behavior
6. **Commit when asked**: User will explicitly request commits
7. **Update plan**: Mark completed tasks with X in CAMPFIRE_ENGINE_PLAN.md

## Key Architecture Rules

### Authentication
- NEVER create authentication in the engine
- ALWAYS delegate to parent app's `current_user` (Devise)
- Use `current_campfire_user` in engine code (auto-created via `Campfire::User.find_or_create_for`)
- `campfire_users` table has FK to parent's `users` table

### User Model Compatibility
- Parent app's User only has `email` field (NO `name` field)
- `Campfire::User#name` method falls back to email
- Always use `message.creator.email` or the `name` method (never assume parent User has name)

### Namespacing
- ALL models/controllers MUST be in `Campfire::` namespace
- Models inherit from `ApplicationRecord` (not `Campfire::ApplicationRecord`)
- Controllers inherit from `Campfire::ApplicationController`

### Database
- Engine uses SQLite (separate from parent's PostgreSQL) - this is INTENTIONAL
- Create migrations in `campfire/db/migrate/`
- User will copy to onerev with `bin/rails campfire:install:migrations`

### Routing
- Engine mounted at `/chat` in parent app
- All engine routes automatically prefixed with `/chat`
- Use `root to: "controller#action"` for engine's root (becomes `/chat`)

## Common Patterns

### Model Associations
```ruby
# For engine models
belongs_to :user  # means Campfire::User
belongs_to :room  # means Campfire::Room

# For parent app's user
belongs_to :user, class_name: "::User"
```

### Controllers
```ruby
module Campfire
  class SomethingsController < ApplicationController
    before_action :authenticate_user!  # From parent app

    def index
      # current_campfire_user is available (Campfire::User)
      # current_user is parent app's User
    end
  end
end
```

### Migrations
```ruby
class CreateCampfireSomething < ActiveRecord::Migration[8.1]
  def change
    create_table :campfire_somethings do |t|
      t.references :user, null: false, foreign_key: { to_table: :campfire_users }
      # t.references already creates index, don't add manually
    end
  end
end
```

## What User Expects

### Communication Style
- Tell user what to verify after completing tasks
- Give specific URLs: "Visit http://localhost:3000/chat/rooms"
- Explain what they should see: "You should see a list of rooms"
- Be concise but complete

### Commits
- Wait for user to request commits with "add and commit"
- Write descriptive commit messages
- Include affected files summary
- Always add the footer:
  ```
  🤖 Generated with [Claude Code](https://claude.com/claude-code)

  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

### Task Tracking
- Update CAMPFIRE_ENGINE_PLAN.md checkboxes as you complete tasks
- User will ask you to review and update progress periodically

## Troubleshooting Checklist

### "undefined method 'name'" error
- Remember: parent User only has email, use `creator.email` or `name` method

### "Could not find table 'action_text_rich_texts'"
- Run `bin/rails action_text:install` in `campfire/test/dummy/`

### Migrations not in onerev
- User needs to run: `bin/rails campfire:install:migrations` in onerev/

### Can't authenticate in engine
- Check that Devise helpers are included in engine.rb config
- Verify `authenticate_user!` is in ApplicationController

### Room types confusion
- `Campfire::Rooms::Open` - auto-membership for all users
- `Campfire::Rooms::Closed` - manual membership only
- `Campfire::Rooms::Direct` - 1-on-1 DMs

## Current State (as of last session)

### Completed
- ✅ Phase 0: Engine foundation, Devise integration
- ✅ Phase 1: Room management with STI (Open/Closed/Direct rooms)
- ✅ Phase 2: Basic messaging with ActionText

### Latest Commits
- `3a16732` - Initial engine setup and room management
- `971b15e` - Onerev integration
- `f939d51` - Messaging functionality with ActionText
- `e2b9981` - Work continuation guide

### Next Phase
- ⏳ Phase 3: Real-time features with ActionCable
  - Message broadcasting
  - Turbo Streams for live updates
  - Presence tracking

### Known Issues
- User needs to run migrations in onerev app (they said they'll handle it)
- Message pagination deferred to later phase

## Testing Instructions

### In Engine (test/dummy app)
```bash
cd /home/mac/developments/onerev/campfire
bin/rails db:migrate RAILS_ENV=test
bin/rails test
```

### In Parent App (onerev)
```bash
cd /home/mac/developments/onerev
bin/rails campfire:install:migrations
bin/rails db:migrate
bin/dev  # Start server
# Visit http://localhost:3000/chat
```

## Decision History

### Why separate campfire_users table?
- Allows engine-specific fields (role, active, bio, bot_token)
- Keeps parent app's User model clean
- FK relationship maintains data integrity

### Why SQLite in engine?
- User's preference
- Keeps engine portable
- Parent app uses PostgreSQL (different DB is fine)

### Why STI for room types?
- Mirrors once-campfire's design
- Clean polymorphic behavior for Open/Closed/Direct rooms
- Single table = simpler queries

### Why delegate authentication?
- Parent app already has Devise
- Avoids duplicate auth logic
- Engine users need parent User records anyway

## File Reference

### Models
- `app/models/campfire/user.rb` - Auto-created from parent User, delegates email
- `app/models/campfire/room.rb` - Base room with STI
- `app/models/campfire/rooms/open.rb` - Auto-membership room
- `app/models/campfire/rooms/closed.rb` - Manual membership room
- `app/models/campfire/rooms/direct.rb` - 1-on-1 DM room
- `app/models/campfire/membership.rb` - User-room join table
- `app/models/campfire/message.rb` - Chat messages with ActionText body

### Controllers
- `app/controllers/campfire/application_controller.rb` - Base controller with auth
- `app/controllers/campfire/rooms_controller.rb` - List and show rooms
- `app/controllers/campfire/messages_controller.rb` - CRUD for messages

### Views
- `app/views/campfire/rooms/index.html.erb` - Room list
- `app/views/campfire/rooms/show.html.erb` - Room chat interface
- `app/views/campfire/messages/edit.html.erb` - Edit message form

### Config
- `lib/campfire/engine.rb` - Engine configuration
- `config/routes.rb` - Engine routes

## Remember
- User will fix onerev integration issues themselves (they explicitly said this)
- Focus on engine code quality
- Ask for clarification if requirements are unclear
- Update CAMPFIRE_ENGINE_PLAN.md as you complete tasks
- Wait for user to request commits
