Order.class_eval do

  def assign_to_rightful_owner
    return true if user.email == email
    new_user = User.find_by_email(email)
    return false if new_user.nil?
    return false if (Spree::ClaimOrder::Config[:require_email_confirmation] && !new_user.confirmed?)
    associate_user!(new_user)
  end

end