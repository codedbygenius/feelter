class Question < ApplicationRecord
  belongs_to :user

  # This triggers the job immediately when you click "Ask"
  after_create_commit :ask_the_guide

  private

  def ask_the_guide
    ChatbotJob.perform_now(self) # Use perform_now for :inline behavior
  end
end
