User.class_eval do

  if Spree::ClaimOrder::Config[:require_email_confirmation]
    devise :confirmable
  else
    # in case some other extension includes the :confirmable, we add it and remove it
    devise :confirmable
    User.devise_modules.pop
  end

  before_save :reset_confirmed_at_if_email_changed
  after_save :claim_all_unclaimed_orders, :if => Proc.new{ |user| !confirmation_required? }
  before_create :set_confirmation_sent_at, :if => Proc.new{ |user| unclaimed_orders.empty? }

  def unclaimed_orders
    Order.where("orders.email = ? AND orders.completed_at IS NOT NULL AND orders.user_id != ?", email, id)
  end

  # overrides User.anonymous! in spree_auth
  def self.anonymous!
    token = User.generate_token(:persistence_token)
    user = User.new(:email => "#{token}@example.net", :password => token, :password_confirmation => token, :persistence_token => token)
    user.confirm! if Spree::ClaimOrder::Config[:require_email_confirmation]
    user
  end

  def claim_all_unclaimed_orders
    unclaimed_orders.each do |order|
      order.assign_to_rightful_owner
    end  unless confirmation_required?
  end

  protected

  # overrides Devise::Modules::Confirmable#confirmation_required?
  def confirmation_required?
   User.devise_modules.include?(:confirmable) && !unclaimed_orders.empty? && !confirmed?
  end

  private

  def reset_confirmed_at_if_email_changed
    self.confirmed_at = nil if (!self.new_record? and self.changed.include?("email"))
  end

  def set_confirmation_sent_at
    self.confirmation_sent_at = Time.now
  end
end