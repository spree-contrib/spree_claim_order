UserRegistrationsController.class_eval do

  after_filter :unclaimed_orders_flash, :only => :create

  private

  def unclaimed_orders_flash
    if @user.confirmation_token and @user.unclaimed_orders.present?
      flash[:error] = t("instructions_sent_at_registration")
    end
  end

end