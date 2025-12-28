class JournalEntriesController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   @journal_entries = current_user.journal_entries.includes(:mood).recent.page(params[:page])
  # end
  def index
  # Orders by newest first
  @journal_entries = current_user.journal_entries.order(created_at: :desc)
 end
  def new
    @journal_entry = JournalEntry.new
    @mood = current_user.moods.find_by(id: session[:current_mood_id]) || current_user.moods.last
  end

  def create
    @journal_entry = current_user.journal_entries.build(journal_entry_params)
    if @journal_entry.save
      redirect_to journal_entries_path, notice: "Journal entry saved!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @journal_entry = current_user.journal_entries.find(params[:id])
  end

  def destroy
    @journal_entry = current_user.journal_entries.find(params[:id])
    @journal_entry.destroy
    redirect_to journal_entries_path, notice: "Entry deleted."
  end

 def analytics
  @mood_distribution = current_user.moods
    .group(:feeling)
    .count

  @entries_by_month = current_user.journal_entries
    .group_by_month(:created_at, last: 6)
    .count
end

  private

  def journal_entry_params
    params.require(:journal_entry).permit(:mood_id, :note)
  end
end
