Rails.application.routes.draw do
  get "/current_user", to: "current_user#index"
  get "/doctors", to: "current_user#all_doctors"
  get "/doctors/:id", to: "current_user#show"

  get "/my_availabilities", to: "availabilities#my_availabilities"

  get "/my_appointments", to: "appointments#my_appointments"
  # Обновление текста в записи
  patch "/appointments/:id", to: "appointments#update"

  # Отмена
  delete "/appointments/:id/cancel", to: "appointments#cancel"

  patch "/current_user", to: "current_user#update"
  put "/current_user", to: "current_user#update"

  resources :chats, only: [ :index, :create, :show ] do
    resources :messages, only: [ :index, :create ]
  end

  devise_for :users, path: "", path_names: {

    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }

  resources :appointments, only: [ :index, :create ]
  resources :availabilities, only: [ :create, :index ]
  delete "/availabilities", to: "availabilities#destroy_slots"

  mount ActionCable.server => '/cable'
end
