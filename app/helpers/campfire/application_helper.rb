module Campfire
  module ApplicationHelper
    def campfire_importmap_tags(entry_point = "campfire/application")
      importmap = Campfire.configuration.importmap

      # Generate the importmap JSON
      importmap_json = importmap.to_json(resolver: self)

      # Build the HTML tags
      tags = []

      # 1. Add the importmap JSON script tag
      tags << content_tag(:script, importmap_json.html_safe,
                          type: "importmap",
                          "data-turbo-track": "reload")

      # 2. Add preload links for better performance
      importmap.preloaded_module_paths(resolver: self).each do |path|
        tags << tag.link(rel: "modulepreload", href: path)
      end

      # 3. Add the entry point that starts the engine's JavaScript
      tags << content_tag(:script,
                          "import '#{entry_point}'".html_safe,
                          type: "module",
                          "data-turbo-track": "reload")

      safe_join(tags, "\n")
    end
  end
end
