class CategoriesController < ApplicationController
  before_action :authenticate_user!
  # Optional: Uncomment the next line if you want to strictly force a mood check-in
  # before_action :ensure_mood_selected

  def select
    # 1. Load the mood safely (Silent fallback if session is empty)
    @current_mood = Mood.find_by(id: session[:current_mood_id]) ||
                    current_user.moods.last ||
                    Mood.new(feeling: 'meh')

    # 2. ML Recommendations
    recommendation_engine = RecommendationEngine.new(current_user)
    recommended_categories = recommendation_engine.recommend_categories_for_mood(@current_mood.feeling) || []

    # 3. Get all categories and sort them
    all_categories = Category.all.to_a
    @categories = sort_by_recommendations(all_categories, recommended_categories)

    # 4. Track which ones are recommended for the "Badge" in the view
    @recommended_category_ids = recommended_categories.map(&:id)
  end

  private

  def ensure_mood_selected
    # Only redirect if there is absolutely no mood history
    if session[:current_mood_id].nil? && current_user.moods.none?
      redirect_to select_mood_path
    end
  end

  def sort_by_recommendations(all_categories, recommended_categories)
    # Put recommended categories first, then the rest
    recommended_ids = recommended_categories.map(&:id)
    recommended = all_categories.select { |c| recommended_ids.include?(c.id) }
    others = all_categories.reject { |c| recommended_ids.include?(c.id) }

    recommended + others
  end
end
