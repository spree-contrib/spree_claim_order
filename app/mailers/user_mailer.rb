class UserMailer < ActionMailer::Base

  default_url_options[:host] = Spree::Config[:site_url]

  def confirmation_instructions(user)

    @user = user

    mail(:to => user.email,
         :subject => Spree::Config[:site_name] + ' ' + t("confirmation_instructions"))
  end

end