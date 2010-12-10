User.class_eval do
  devise :confirmable
  before_save :reset_confirmed_at_if_email_changed

  def unclaimed_orders
    confirmed? ? Order.where("email = ? AND user_id != ?", email, id) : []
  end

  # overrides User.anonymous! in spree_auth
  def self.anonymous!
    token = User.generate_token(:persistence_token)
    user = User.new(:email => "#{token}@example.net", :password => token, :password_confirmation => token, :persistence_token => token)
    user.confirm!
    user
  end

  private

  def reset_confirmed_at_if_email_changed
    self.confirmed_at = nil if (!self.new_record? and self.changed.include?("email"))
  end
end