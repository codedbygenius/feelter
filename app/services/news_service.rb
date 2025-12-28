class NewsService
  include HTTParty
  base_uri 'https://newsapi.org/v2'

  def initialize
    @api_key = ENV['NEWS_API_KEY']
  end

  def fetch_articles(category, mood, page_size = 10)
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
      'uplifting' => 'inspiring OR success OR achievement OR breakthrough',
      'calming' => 'mindfulness OR wellness OR nature OR meditation',
      'motivational' => 'innovation OR success OR entrepreneur OR achievement',
      'serious' => 'analysis OR research OR insight OR technology'
    }

    queries[category] || 'positive news'
  end
end
