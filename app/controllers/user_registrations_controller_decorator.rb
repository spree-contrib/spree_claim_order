UserRegistrationsController.class_eval do

  after_filter do
    claim_unclaimed if => Spree::ClaimOrder::Config[:require_email_confirmation]
  end, :only => :create
  after_filter :unclaimed_orders_flash

  private

  def unclaimed_orders_flash
    if @user.confirmation_token and @user.unclaimed_orders.present?
      flash[:error] = t("instructions_sent_at_registration")
    end
  end

  def claim_unclaimed
    @user.claim_all_unclaimed_orders
  end

end