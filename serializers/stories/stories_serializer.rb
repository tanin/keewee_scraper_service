class StoriesSerializer
  def initialize(story)
    @story = story
  end

  def as_json(*)
    {
      id: story.id.to_s,
      url: story.url,
      type: story.meta_data&.dig('type'),
      title: story.meta_data&.dig('title'),
      images: story.meta_data&.dig('images'),
      updated_time: story.updated_at,
      scrape_status: story.scrape_status
    }
  end

  attr_accessor :story
end
