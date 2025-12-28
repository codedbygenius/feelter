# app/services/unsplash_service.rb
class UnsplashService
  include HTTParty
  base_uri 'https://api.unsplash.com'

  def initialize
    @access_key = ENV['UNSPLASH_ACCESS_KEY']
  end

  def search_photos(mood, category, per_page = 15)
    return [] unless @access_key.present?

    search_term = mood_to_search_term(mood, category)

    response = self.class.get('/search/photos', {
      query: {
        query: search_term,
        per_page: per_page,
        orientation: 'landscape'
      },
      headers: {
        'Authorization' => "Client-ID #{@access_key}"
      }
    })

    return [] unless response.success?

    response['results'].map do |photo|
      {
        url: photo['urls']['regular'],
        thumb_url: photo['urls']['thumb'],
        description: photo['description'] || photo['alt_description'] || 'Beautiful image',
        photographer: photo['user']['name'],
        photographer_url: photo['user']['links']['html']
      }
    end
  rescue => e
    Rails.logger.error "Unsplash API Error: #{e.message}"
    []
  end

  private

  def mood_to_search_term(mood, category)
    terms = {
      'happy' => {
        'uplifting' => 'joy happiness celebration sunshine',
        'calming' => 'peaceful sunrise nature beach',
        'motivational' => 'success achievement victory mountains',
        'serious' => 'contemplation reflection coffee'
      },
      'sad' => {
        'uplifting' => 'hope sunrise new beginning flowers',
        'calming' => 'rain peaceful solitude forest',
        'motivational' => 'overcoming adversity strength growth',
        'serious' => 'introspection thoughtful minimalist'
      },
      'meh' => {
        'uplifting' => 'colorful vibrant energy sunset',
        'calming' => 'zen meditation peaceful water',
        'motivational' => 'action movement progress fitness',
        'serious' => 'minimalist simple clean architecture'
      }
    }

    terms.dig(mood, category) || 'peaceful nature'
  end
end

# app/services/quote_service.rb
class QuoteService
  include HTTParty
  base_uri 'https://api.quotable.io'

  def self.fetch_quotes(category, mood, limit = 15)
    tags = map_to_tags(category, mood)

    quotes = []
    tags.each do |tag|
      response = get('/quotes/random', {
        query: {
          limit: 5,
          tags: tag
        }
      })

      next unless response.success?

      Array(response).each do |quote|
        quotes << {
          content: quote['content'],
          author: quote['author'],
          tags: quote['tags']
        }
      end

      break if quotes.size >= limit
    end

    quotes.take(limit)
  rescue => e
    Rails.logger.error "Quote API Error: #{e.message}"
    []
  end

  private

  def self.map_to_tags(category, mood)
    tag_map = {
      'uplifting' => ['inspirational', 'happiness', 'success', 'friendship'],
      'calming' => ['wisdom', 'philosophy', 'life', 'nature'],
      'motivational' => ['success', 'famous-quotes', 'perseverance', 'competition'],
      'serious' => ['wisdom', 'philosophy', 'life', 'history']
    }

    tag_map[category] || ['wisdom']
  end
end

# app/services/news_service.rb
class NewsService
  include HTTParty
  base_uri 'https://newsapi.org/v2'

  def initialize
    @api_key = ENV['NEWS_API_KEY']
  end

  def fetch_articles(category, mood, page_size = 15)
    return [] unless @api_key.present?

    query = build_query(category, mood)

    response = self.class.get('/everything', {
      query: {
        q: query,
        language: 'en',
        sortBy: 'relevancy',
        pageSize: page_size,
        apiKey: @api_key
      }
    })

    return [] unless response.success?

    response['articles'].map do |article|
      {
        title: article['title'],
        description: article['description'],
        url: article['url'],
        image_url: article['urlToImage'],
        published_at: article['publishedAt'],
        source: article['source']['name']
      }
    end
  rescue => e
    Rails.logger.error "News API Error: #{e.message}"
    []
  end

  private

  def build_query(category, mood)
    queries = {
      'uplifting' => 'inspiring OR success OR achievement OR breakthrough OR innovation',
      'calming' => 'mindfulness OR wellness OR nature OR meditation OR peaceful',
      'motivational' => 'innovation OR success OR entrepreneur OR achievement OR transformation',
      'serious' => 'analysis OR research OR insight OR technology OR science'
    }

    queries[category] || 'positive news'
  end
end

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
    # Return empty array for now - you can add Spotify later
    # SpotifyService.new.search_playlists(category, mood, 15)
    []
  end
end
