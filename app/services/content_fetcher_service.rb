# app/services/content_fetcher_service.rb
class ContentFetcherService
  def self.fetch_all(content_type, category, mood)
    case content_type.to_s
    when 'picture'
      fetch_pictures(category, mood)
    when 'quote'
      fetch_quotes(category, mood)
    when 'blog'
      fetch_blogs(category, mood)
    when 'music'
      fetch_music(category, mood)
    else
      []
    end
  end

  private

  def self.fetch_pictures(category, mood)
    UnsplashService.new.search_photos(mood, category, 15)
  end

  def self.fetch_quotes(category, mood)
    QuoteService.fetch_quotes(category, mood, 15)
  end

  def self.fetch_blogs(category, mood)
    NewsService.new.fetch_articles(category, mood, 15)
  end

  def self.fetch_music(category, mood)
    # Fetch both playlists and tracks
    spotify = SpotifyService.new
    playlists = spotify.search_playlists(category, mood, 10)
    tracks = spotify.search_tracks(category, mood, 5)

    # Combine and shuffle
    (playlists + tracks).shuffle
  end
end
