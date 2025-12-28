Rails.application.routes.draw do
  # 1. The Root Page
  root to: "pages#home"

  # 2. Authentication
  devise_for :users

  # 3. The Dashboard (Fixed and Clean)
  get "dashboard", to: "pages#dashboard", as: :dashboard

  # 4. Mood selection flow
  get "mood/select", to: "moods#select", as: :select_mood
  post "mood/create", to: "moods#create", as: :create_mood

  # 5. Category selection
  get "category/select", to: "categories#select", as: :select_category

  # 6. Content type selection and display
  get "content/select", to: "contents#select", as: :select_content_type
  get "content/show", to: "contents#show", as: :show_content

  # 7. Journal entries
  resources :questions, only: [:index, :create]
  resources :journal_entries, only: [:index, :new, :create, :show, :destroy] do
    collection do
      get :analytics
    end
  end
end
