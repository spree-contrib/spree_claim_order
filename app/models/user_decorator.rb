User.class_eval do
  devise :confirmable
  before_save :reset_confirmed_at_if_email_changed

  def unclaimed_orders
    confirmed? ? Order.where("email = ? AND user_id != ?", email, id) : []
  end

  private

  def reset_confirmed_at_if_email_changed
    self.confirmed_at = nil if self.changed.include?("email")
  end
end