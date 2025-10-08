module Campfire
  module Users::SidebarHelper
    def sidebar_turbo_frame_tag(src: nil, &)
      turbo_frame_tag :user_sidebar, src: src, target: "_top", data: {
        turbo_permanent: true,
        controller: "rooms-list read-rooms turbo-frame",
        rooms_list_unread_class: "unread",
        action: "presence:present@window->rooms-list#read read-rooms:read->rooms-list#read turbo:frame-load->rooms-list#loaded refresh-room:visible@window->turbo-frame#reload".html_safe # otherwise -> is escaped
      }, &
    end
  end
end
