class ClaimOrderConfiguration < Configuration

  # Setting this to false will allow you to bypass email confirmation requirements
  # and orders will automatically be associated with existing user accounts even
  # if the account's email address has not been confirmed.
  #
  # Restart the app if you change this preference
  preference :require_email_confirmation, :boolean, :default => true

end