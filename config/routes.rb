Rails.application.routes.draw do
  match 'send_confirmation_instructions' => 'users#send_confirmation_instructions', :via => :put
  match 'orders/:id/claim' => 'orders#claim', :via => :put
end
