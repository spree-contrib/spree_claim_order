require 'spec_helper'

describe User do
  let(:user) { User.new(:email => 'old@test.com', :password => 'spree123', :password_confirmation => 'spree123') }

  before do
    user.stub(:send_confirmation_instructions => true)
    user.save
    Devise.stub_chain :mailer, :confirmation_instructions, :deliver => true
    user.confirm!
  end

  it "should include the confirmable Devise module" do

    User.devise_modules.include?(:confirmable).should be_true

  end

  context "email address changes" do

    it "should set confirmed_at to nil" do
      user.email = "new@test.com"
      user.save
      user.confirmed_at.should be_nil
    end

  end

  context "email address does not change" do

    it "should not change confirmed_at" do
      user.login = "login"
      user.save
      user.confirmed_at.should_not be_nil
    end

  end

end