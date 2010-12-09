User.class_eval do
  devise :confirmable
  before_save :reset_confirmed_at_if_email_changed

  private

  def reset_confirmed_at_if_email_changed
    self.confirmed_at = nil if self.changed.include?("email")
  end
end