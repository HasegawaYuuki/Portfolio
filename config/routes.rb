Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :reviews, only: [:index, :show]
    resources :review_comments
    root to: 'homes#top'
  end

  scope module: :public do
    resources :customers, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      	get "follows" => "relationships#follows", as: "follows"
      	get "followers" => "relationships#followers", as: "followers"
    end
    resources :reviews
    resources :review_comments
    resources :favorites
    resources :tags
    resources :taggings
    root to: 'homes#top'
    get 'about' => 'homes#about', as: 'about'
  end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
