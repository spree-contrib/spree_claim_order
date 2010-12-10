Order.class_eval do

  def assign_to_rightful_owner
    new_user = User.find_by_email(email)
    return false if (new_user.nil? or !new_user.confirmed?)
    self.user = new_user
    save
  end

end