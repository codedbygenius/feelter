class MoodsController < ApplicationController
  before_action :authenticate_user!

  def select
    # Show mood selection page
  end

  # def create
  #   @mood = current_user.moods.build(mood_params)
  #   if @mood.save
  #     session[:current_mood_id] = @mood.id
  #     redirect_to select_category_path
  #   else
  #     render :select, status: :unprocessable_entity
  #   end
  # end
 def create
  @mood = Mood.new(feeling: params[:feeling])
  # Link this mood to the current user if you are using Devise
  @mood.user = current_user if user_signed_in?

  if @mood.save
    redirect_to select_category_path # This matches the route name in your file
  else
    render :select, status: :unprocessable_entity
  end
end


  private

  # def mood_params
  #   params.require(:mood).permit(:feeling)
  # end
  def mood_params
  params.permit(:feeling)
end
end
