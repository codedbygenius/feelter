class DashboardsController < ApplicationController
  def show
    # Fetch moods from the last 7 days
    @mood_data = current_user.moods
                             .where(created_at: 7.days.ago..Time.current)
                             .group_by_day(:created_at)
                             .count

    # If you want to map "feeling" names to numbers (1-5) for a line graph:
    @mood_scores = current_user.moods
                               .where(created_at: 14.days.ago..Time.current)
                               .group_by_day(:created_at)
                               .average(:intensity) # Assuming you have an intensity column
  end
end
