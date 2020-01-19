class OpenGraph
  include OpenGraphReader::Object

  namespace :og
  url :url, required: true
  string :type,  required: true, downcase: true, default: "website"
  string :title, required: true
  url :image, required: true, collection: true

  class Image
    include OpenGraphReader::Object

    namespace :og, :image
    content :url, image: true

    url :url
    string :type
    string :alt
    url :secure_url
    integer :width
    integer :height

    def url
      secure_url || properties[:url] || content
    end
  end
end
