class PostStorySerializer
  def initialize(story)
    @story = story
  end

  def as_json(*)
    data = {
      id: story.id.to_s,
      url: story.url,
    }

    data[:errors] = story.errors if story.errors.any?

    data
  end

  attr_accessor :story
end
