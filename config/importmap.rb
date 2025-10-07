pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/activestorage", to: "@rails--activestorage.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "trix"

pin "campfire/application", preload: true

# Pin all controller files following the *_controller.js naming convention
pin_all_from Campfire::Engine.root.join("app/javascript/campfire/controllers"), under: "controllers", to: "campfire/controllers"
