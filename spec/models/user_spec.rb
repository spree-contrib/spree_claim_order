require 'spec_helper'

describe User do
  let(:user) { User.create(:email => 'old@test.com', :password => 'spree123', :password_confirmation => 'spree123') }

  it "should include the confirmable Devise module" do
    User.devise_modules.include?(:confirmable).should be_true
  end

  before { Devise.stub_chain :mailer, :confirmation_instructions, :deliver => true }

  context "when created" do

    it "should send confirmation instruction when a regular user is created" do
      user.confirmation_token.should_not be_nil
    end

    it "should not send confirmation instructions when an anonymous user is created" do
      anonymous = User.anonymous!
      anonymous.confirmation_token.should be_nil
    end



  end

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
      @unclaimed_incomplete = Order.create(:user=> User.anonymous!, :email => user.email)
      @unclaimed_complete = Order.create(:user=> User.anonymous!, :email => user.email)
      @unclaimed_complete.update_attributes_without_callbacks(:completed_at => Time.now)
    end

    context "when user is not confirmed" do

      before { user.stub :confirmed? => false }

      it "should be empty" do
        user.unclaimed_orders.should be_empty
      end

    end

    context "when user is confimed" do

      before { user.stub :confirmed? => true }

      it "should not include unclaimed_complete in result" do
        user.unclaimed_orders.include?(@unclaimed_complete).should == true
      end

      it "should not include unclaimed_incomplete in result" do
        user.unclaimed_orders.include?(@unclaimed_incomplete).should == false
      end

      it "should not included already associated orders in result" do
        user.unclaimed_orders.include?(@claimed).should == false
      end
    end

  end

end