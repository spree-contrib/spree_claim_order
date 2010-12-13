Rails.application.routes.draw do

  devise_scope :user do
    post "/user_confirmation" => "user_confirmations#create", :as => :user_confirmation
    get "/user_confirmation/:confirmation_token" => "user_confirmations#show"
  end

  match 'send_confirmation_instructions' => 'users#send_confirmation_instructions', :via => :put
  match 'orders/:id/claim' => 'orders#claim', :via => :put, :as => :claim_order
end
