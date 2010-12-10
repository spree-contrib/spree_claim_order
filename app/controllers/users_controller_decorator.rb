UsersController.class_eval do

  def send_confirmation_instructions
    if current_user.send_confirmation_instructions
      flash[:notice] = t('instructions_sent_success')
    else
      flash[:error] = t('instructions_sent_failed')
    end
    redirect_to account_path
  end

end