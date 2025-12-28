require 'ostruct'

class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_mood_and_category

  def select
    # Renders selection page
  end

  def show
    @type = params[:content_type]

    # 1. Fetch from APIs (Cached)
    api_contents = fetch_from_api(@type)

    # 2. Fallback to database records
    db_contents = Content.where(category: @category)
                         .where(content_type: @type)
                         .order("RANDOM()")
                         .limit(5)

    # 3. Combine and TRANSFORM (This is where the Gemini magic happens)
    @contents = combine_contents(api_contents, db_contents, @type)

    # 4. Track for ML
    track_interaction(@type)
  end

  private

  def load_mood_and_category
    @mood = Mood.find_by(id: session[:current_mood_id]) || Mood.last

    # Support both ID and Name lookups to be safe
    if params[:category_id]
      @category = Category.find_by(id: params[:category_id])
    elsif params[:category]
      @category = Category.find_by(name: params[:category].downcase)
    end

    if @mood.nil? || @category.nil?
      redirect_to select_mood_path, alert: "Please check in with your heart first."
    end
  end

  def fetch_from_api(content_type)
    cache_key = "content_#{content_type}_#{@category.name}_#{@mood.feeling}_#{Date.today}"

    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      ContentFetcherService.fetch_all(content_type, @category.name, @mood.feeling)
    end
  rescue => e
    Rails.logger.error "API fetch error: #{e.message}"
    []
  end

  def combine_contents(api_contents, db_contents, content_type)
    combined = []

    # Format and Transform API items
    Array(api_contents).each do |api_item|
      formatted = format_api_content(api_item, content_type)
      combined << formatted if formatted
    end

    # Add database contents
    combined += db_contents.to_a

    # Final Shuffle
    combined.compact.shuffle.take(12)
  end

  def format_api_content(api_item, content_type)
    return nil if api_item.blank?

    case content_type
    when 'blog'
      # !!! THIS IS THE FIX !!!
      # Instead of just taking the snippet, we call Gemini here.
      zen_story = QuoteService.generate_zen_story(api_item[:title], api_item[:description])

      OpenStruct.new(
        content_type: 'blog',
        title: api_item[:title],
        blog: zen_story, # The full 3-paragraph story
        url: api_item[:url],
        category: @category
      )
    when 'quote'
      OpenStruct.new(
        content_type: 'quote',
        title: api_item[:author] || "Unknown",
        blog: api_item[:content],
        category: @category
      )
    when 'picture'
      OpenStruct.new(
        content_type: 'picture',
        url: api_item[:url],
        blog: "Captured by #{api_item[:photographer]}",
        category: @category
      )
    when 'music'
      OpenStruct.new(
        content_type: 'music',
        title: api_item[:name],
        url: api_item[:url],
        embed_url: api_item[:embed_url], # Ensure your service provides this
        blog: api_item[:description],
        category: @category
      )
    end
  end

  def track_interaction(content_type)
    return unless current_user && @mood && @category
    Interaction.create!(
      user: current_user,
      mood: @mood,
      category: @category,
      content_type: content_type,
      timestamp: Time.current
    )
  rescue => e
    Rails.logger.error "Interaction tracking error: #{e.message}"
  end
end
