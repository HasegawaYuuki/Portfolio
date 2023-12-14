Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    passwords: 'public/passwords'
  }

  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end



  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :relationships, only: [] do
      member do
        get :followings
        get :followers
      end
    end
    resources :reviews, only: [:index, :show]
    resources :review_comments
    root to: 'homes#top'
  end

  scope module: :public do
    resources :customers, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
        get "followings" => "relationships#followings", as: "followings"
        get "followers" => "relationships#followers", as: "followers"
        member do
          get :favorite_index
        end
    end
    resources :reviews do
      resource :favorites, only: [:create, :destroy]
      resources :review_comments, only: [:create, :destroy]
    end
    resources :tags
    resources :taggings
    root to: 'homes#top'
    get 'about' => 'homes#about', as: 'about'
    get "search_tag" => "reviews#search_tag"
  end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
