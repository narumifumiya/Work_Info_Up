Rails.application.routes.draw do

  # devise usersのコントローラと干渉するため、publicを付けてURLを差別化
  namespace :public do
    resources :users, only: [:index, :show, :edit, :update] do
      resources :tasks, except: [:create, :update]
    end
    get '/users/:id/favorites' => 'users#favorites'
  end
  # taskのformでurlのpublicが干渉してパーシャル化が出来ない為、namespaceの外でpathを指定
  post "public/users/:user_id/tasks" => "public/tasks#create", as: :user_tasks
  patch "public/users/:user_id/tasks/:id" => "public/tasks#update", as: :user_task

  # ユーザー用
  scope module: :public do
    root to: "homes#top"
    # sign_upのエラーメッセージ表示後にリロードした際にルートエラーが起きないように設定
    get "users" => "users#users"
    resources :departments, only: [:show]
    get "search" => "searches#search"
    resources :groups, except: [:new] do
      resource :permits, only: [:create, :destroy]
      resource :group_users, only: [:create, :destroy]
      resources :event_notices, only: [:new, :create]
      get "event_notices" => "event_notices#sent"
      resources :chats, only: [:index, :create, :destroy]
    end
    get "groups/:id/permits" => "groups#permits", as: :permits
    # 得意先周辺
    resources :companies, only: [:index, :show] do
      resources :offices
      resources :customers
      resources :projects, except: [:destroy] do
        resources :project_comments, only: [:create, :destroy]
        resource :favorites, only: [:create, :destroy]
      end
    end
    # 通知用
    resources :notifications, only: [:index] do
      collection do
        delete "destroy_all"
      end
    end
  end

  # 管理者用
  namespace :admin do
    root to: "homes#top"
    resources :departments, except: [:new]
    resources :users, only: [:index, :show, :edit, :update]
    resources :groups, only: [:index, :destroy]
    get "search" => "searches#search"
    # 得意先周辺
    resources :companies, except: [:new] do
      resources :projects, except: [:new, :create] do
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
  sessions: "public/sessions"
}

# ゲストログイン用
devise_scope :user do
  post "public/guest_sign_in", to: "public/sessions#guest_sign_in"
end

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
