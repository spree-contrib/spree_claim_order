User.class_eval do
  devise :confirmable
  before_save :reset_confirmed_at_if_email_changed

  def unclaimed_orders
    confirmed? ? Order.where("orders.email = ? AND orders.completed_at IS NOT NULL AND orders.user_id != ?", email, id) : []
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