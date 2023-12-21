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

  get "search" => "searches#search"

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
    resources :reviews, only: [:index, :show, :edit, :update]
    resources :review_comments
    resources :reports, only: [:index, :edit, :update]
    root to: 'homes#top'
  end

  scope module: :public do
    # 退会確認画面
    get  '/customers/check' => 'customers#check'
    # 論理削除用のルーティング
    patch  '/customers/withdraw' => 'customers#withdraw'
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
      resource :reports, only: [:new, :create]
      get :complete, on: :member
    end
    resources :tags
    resources :taggings
    root to: 'homes#top'
    get "search_tag" => "reviews#search_tag"
    get 'about' => 'homes#about', as: 'about'
  end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
