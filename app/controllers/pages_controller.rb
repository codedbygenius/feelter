# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  # def dashboard
  #   @recent_moods = current_user.moods.includes(:category).order(created_at: :desc).limit(10)
  #   @mood_stats = current_user.moods.group(:feeling).count
  # end
  def dashboard
    @journal_entries = current_user.journal_entries.order(created_at: :desc)
    # This line powers the graph
    @mood_data = current_user.moods.group_by_day(:created_at).count
    # This line powers the emoji cards
    @mood_counts = current_user.moods.group(:feeling).count
  end
end
