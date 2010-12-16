UserSessionsController.class_eval do

  after_filter :claim_orders, :only => :create

  private

  def claim_orders
    current_user.claim_all_unclaimed_orders
  end

end