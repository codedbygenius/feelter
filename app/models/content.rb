class Content < ApplicationRecord
  belongs_to :category
  belongs_to :mood, optional: true

  enum :content_type, { quote: 0, blog: 1, music: 2, picture: 3 }

  validates :content_type, presence: true
  validates :title, presence: true
  validates :url, presence: true, if: -> { music? || picture? }
  validates :blog, presence: true, if: -> { blog? }

  scope :for_category, ->(category) { where(category: category) }
  scope :for_mood, ->(mood) { where(mood: mood) }

  def embed_url
    # If the column exists or was set by the service, return it
    return read_attribute(:embed_url) if respond_to?(:embed_url) && read_attribute(:embed_url).present?

    # Otherwise, if it's music and we have a Spotify URL, generate it
    if content_type == 'music' && url.present?
      if url.include?("playlist")
        playlist_id = url.split("/").last.split("?").first
        "https://open.spotify.com/embed/playlist/#{playlist_id}?utm_source=generator"
      elsif url.include?("track")
        track_id = url.split("/").last.split("?").first
        "https://open.spotify.com/embed/track/#{track_id}?utm_source=generator"
      end
    end
  end
end
