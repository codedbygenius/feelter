# app/services/recommendation_engine.rb
class RecommendationEngine
  def initialize(user)
    @user = user
    # Don't rescue here - we want the ActiveRecord relation, not an array
    @interactions = user.interactions.where('timestamp >= ?', 30.days.ago)
  end

  def recommend_categories_for_mood(mood_feeling)
    # Find what categories this user typically chooses for this mood
    begin
      category_scores = @interactions
        .joins(:mood)
        .where(moods: { feeling: Mood.feelings[mood_feeling] })
        .group(:category_id)
        .count
        .sort_by { |_, count| -count }
        .to_h

      # If no history, use default recommendations
      return default_recommendations_for_mood(mood_feeling) if category_scores.empty?

      category_scores.keys.map { |id| Category.find_by(id: id) }.compact
    rescue => e
      Rails.logger.error "Recommendation error: #{e.message}"
      default_recommendations_for_mood(mood_feeling)
    end
  end

  def generate_insights
    insights = []

    begin
      # Mood consistency
      if mood_streak > 3
        insights << {
          type: 'positive',
          message: "You've been consistent with tracking for #{mood_streak} days! 🌟"
        }
      end

      # Usage patterns
      checkin_count = @user.moods.where('created_at >= ?', 7.days.ago).count
      if checkin_count >= 5
        insights << {
          type: 'positive',
          message: "Great job! You've checked in #{checkin_count} times this week 🎉"
        }
      end
    rescue => e
      Rails.logger.error "Insights error: #{e.message}"
    end

    insights
  end

  private

  def mood_streak
    moods = @user.moods.order(created_at: :desc).limit(10)
    return 0 if moods.empty?

    streak = 1
    current_mood = moods.first.feeling

    moods[1..-1].each do |mood|
      break if mood.feeling != current_mood
      streak += 1
    end

    streak
  rescue => e
    0
  end

  def default_recommendations_for_mood(mood_feeling)
    recommendations = {
      'happy' => ['uplifting', 'motivational'],
      'sad' => ['uplifting', 'calming'],
      'meh' => ['motivational', 'uplifting']
    }

    category_names = recommendations[mood_feeling.to_s] || ['uplifting']
    Category.where(name: category_names)
  end
end
