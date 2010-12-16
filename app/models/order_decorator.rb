Order.class_eval do

  after_save :assign_to_rightful_owner, :if => Proc.new {|order| order.completed? && order.email != order.user.email }

  def assign_to_rightful_owner
    return true if user.email == email
    new_user = User.find_by_email(email)
    return false if new_user.nil?
    return false if (Spree::ClaimOrder::Config[:require_email_confirmation] && !new_user.confirmed?)
    self.user = new_user
    save
  end

end