class UserConfirmationsController < Devise::ConfirmationsController
  include SpreeBase
  include Spree::AuthUser
  helper :users, 'spree/base'
  ssl_required

  def create
    user = User.send_confirmation_instructions(current_user)

    if user.errors.empty?
      flash[:notice] = t("instructions_sent_success")
    else
      flash[:error] = t("already_confirmed")
    end
    redirect_to account_path
  end

  def show
    user = User.confirm_by_token(params[:confirmation_token])

    if user.errors.empty?
      flash[:notice] = t("account_confirmation_successful")
    else
      flash[:error] = t("invalid_token")
    end
    redirect_to account_path
  end

end