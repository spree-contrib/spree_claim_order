require 'spec_helper'

describe User do
  let(:user) { User.create(:email => 'old@test.com', :password => 'spree123', :password_confirmation => 'spree123') }

  it "should include the confirmable Devise module" do

    User.devise_modules.include?(:confirmable).should be_true

  end

  before { Devise.stub_chain :mailer, :confirmation_instructions, :deliver => true }

  context "#save" do

    before { user.confirm! }

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

  context "#unclaimed_orders" do

    before do
      @claimed = user.orders.create(:email => user.email)
      @unclaimed = Order.create(:user=> User.anonymous!, :email => user.email)
    end

    context "when user is not confirmed" do

      before { user.stub :confirmed? => false }

      it "should be empty" do
        user.unclaimed_orders.should be_empty
      end

    end

    context "when user is confimed" do

      before { user.stub :confirmed? => true }

      it "should return unclaimed orders" do
        user.unclaimed_orders.include?(@unclaimed).should == true
      end

      it "should not return claimed orders" do
        user.unclaimed_orders.include?(@claimed).should == false
      end
    end

  end

end