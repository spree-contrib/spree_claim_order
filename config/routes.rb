Rails.application.routes.draw do
  match 'send_confirmation_instructions' => 'users#send_confirmation_instructions'
end
