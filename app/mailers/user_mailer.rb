class UserMailer < ActionMailer::Base

  def confirmation_instructions(user)

    @user = user

    mail(:to => user.email,
         :subject => Spree::Config[:site_name] + ' ' + t("confirmation_instructions"))
  end

end