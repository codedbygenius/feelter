class QuestionsController < ApplicationController
  def index
    @questions = current_user.questions.order(created_at: :asc)
    @question = Question.new
  end

def create
  @question = Question.new(question_params)
  @question.user = current_user # <--- This is crucial!

  if @question.save
    # If using :inline mode in development.rb, this waits for the AI
    redirect_to questions_path
  else
    @questions = current_user.questions.order(created_at: :desc)
    render :index
  end
end

  private

  def question_params
    params.require(:question).permit(:user_question)
  end
end
