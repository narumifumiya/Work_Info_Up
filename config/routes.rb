Rails.application.routes.draw do


  # devise usersのコントローラと干渉するため、publicを付けてURLを差別化
  namespace :public do
    resources :users, only: [:index, :show, :edit, :update]
    get '/users/:id/favorites' => 'users#favorites'
  end

  # ユーザー用
  scope module: :public do
    root to: 'homes#top'
    # resources :users, only: [:index, :show, :edit, :update]
    resources :departments, only: [:show]
    get "search" => "searches#search"
    resources :groups, except: [:destroy] do
      resource :group_users, only: [:create, :destroy]
    end
    resources :companies, only: [:index, :show] do
      resources :offices, only: [:index, :new, :edit, :create, :update, :destroy]
      resources :customers
      resources :projects, except: [:destroy] do
        resources :project_comments, only: [:create, :destroy]
        resource :favorites, only: [:create, :destroy]
      end
    end
  end

  # 管理者用
  namespace :admin do
    root to: 'homes#top'
    resources :departments, only: [:index, :edit, :create, :update, :destroy]
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    get "search" => "searches#search"
    resources :companies do
      resources :projects, only: [:index, :show, :edit, :update, :destroy] do
        resources :project_comments, only: [:destroy] do
          collection do
            delete "destroy_all"
          end
        end
      end
    end
  end

  # ユーザー用
# URL /users/sign_in ...
devise_for :users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# ゲストログイン用
devise_scope :user do
  post 'public/guest_sign_in', to: 'public/sessions#guest_sign_in'
end

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
