# app/services/analytics_service.rb
class AnalyticsService
  def initialize(user)
    @user = user
  end

  def mood_trends(period: 30.days)
    @user.moods
      .where('created_at >= ?', period.ago)
      .group_by_day(:created_at)
      .group(:feeling)
      .count
      .transform_keys { |key| [key[0], Mood.feelings.key(key[1])] }
  rescue => e
    Rails.logger.error "Analytics error: #{e.message}"
    {}
  end

  def category_breakdown
    @user.interactions
      .joins(:category)
      .group('categories.name')
      .count
  rescue => e
    Rails.logger.error "Analytics error: #{e.message}"
    {}
  end

  def content_type_preferences
    @user.interactions
      .group(:content_type)
      .count
      .transform_keys { |type| Interaction.content_types.key(type) }
  rescue => e
    {}
  end

  def weekly_activity
    @user.moods
      .where('created_at >= ?', 12.weeks.ago)
      .group_by_week(:created_at)
      .count
  rescue => e
    {}
  end

  def mood_by_time_of_day
    @user.moods
      .where('created_at >= ?', 30.days.ago)
      .group_by_hour_of_day(:created_at)
      .group(:feeling)
      .count
      .transform_keys { |key| [key[0], Mood.feelings.key(key[1])] }
  rescue => e
    {}
  end

  def generate_report
    {
      total_checkins: @user.moods.count,
      total_journal_entries: @user.journal_entries.count,
      current_streak: calculate_streak,
      mood_trends: mood_trends,
      insights: RecommendationEngine.new(@user).generate_insights
    }
  end

  private

  def calculate_streak
    dates = @user.moods.order(created_at: :desc).pluck(:created_at).map(&:to_date).uniq
    return 0 if dates.empty?

    streak = 1
    dates.each_cons(2) do |today, yesterday|
      break if (today - yesterday).to_i > 1
      streak += 1
    end
    streak
  rescue => e
    0
  end
end
