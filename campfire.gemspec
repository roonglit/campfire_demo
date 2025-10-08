require_relative "lib/campfire/version"

Gem::Specification.new do |spec|
  spec.name        = "campfire"
  spec.version     = Campfire::VERSION
  spec.authors     = [ "Roonglit Chareonsupkul" ]
  spec.email       = [ "roonglit@gmail.com" ]
  spec.homepage    = "https://github.com/roonglit/campfire"
  spec.summary     = "Real-time chat engine for Rails applications"
  spec.description = "Campfire is a Rails engine that provides real-time chat functionality with rooms, direct messages, and file attachments."
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.0.beta1"
  spec.add_dependency "sqlite3", "~> 2.0"
  spec.add_dependency "redis", "~> 5.0"
  spec.add_dependency "kredis", "~> 1.7"
  spec.add_dependency "turbo-rails", "~> 2.0"
  spec.add_dependency "stimulus-rails", "~> 1.3"
  spec.add_dependency "importmap-rails", "~> 2.0"
  spec.add_dependency "propshaft", "~> 1.0"
  spec.add_dependency "image_processing", "~> 1.2"
  spec.add_dependency "web-push", "~> 3.0"
  spec.add_dependency "rails_autolink", "~> 1.1"
  spec.add_dependency "geared_pagination", "~> 1.1"
  spec.add_dependency "jbuilder", "~> 2.11"
  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "net-http-persistent", "~> 4.0"
  spec.add_dependency "platform_agent", "~> 1.0"
  spec.add_dependency "rqrcode", "~> 2.0"
  spec.add_dependency "tailwindcss-rails"
end
