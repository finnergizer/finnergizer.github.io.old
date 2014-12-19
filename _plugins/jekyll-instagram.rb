require "instagram"

module Jekyll
  class InstagramGenerator < Generator
    def generate(site)
        session = {:access_token => "230043606.83da8ea.4bdddbe202df49cf87b8c75a643df5d4"}
        puts session[:access_token]

        instagram_pictures = Array.new

        client = Instagram.client(:access_token => session[:access_token])
        for media_item in client.user_recent_media
          instagram_pictures << {"src"=>media_item.images.thumbnail.url, "caption"=>media_item.caption.text, "link"=>media_item.link}
        end

        site.data['instagram-pictures'] = instagram_pictures
    end
  end
end
