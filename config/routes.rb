Rails.application.routes.draw do

  devise_scope :user do
    post "/user_confirmation" => "user_confirmations#create", :as => :create_user_confirmation
    get "/user_confirmation/:confirmation_token" => "user_confirmations#show", :as => :user_confirmation
  end

end
