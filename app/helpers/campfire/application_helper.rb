module Campfire
  module ApplicationHelper
    include Users::SidebarHelper

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

    def body_classes
      [ @body_class, admin_body_class, account_logo_body_class ].compact.join(" ")
    end

    private
      def admin_body_class
        # "admin" if Current.user&.can_administer?
      end

      def account_logo_body_class
        # "account-has-logo" if Current.account&.logo&.attached?
      end
  end
end
