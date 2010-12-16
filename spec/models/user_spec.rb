require 'spec_helper'

describe User do

  context "email confirmation required" do

    before do
      User.devise_modules.delete(:confirmable)
      Spree::ClaimOrder::Config.set(:require_email_confirmation => true)
      load('app/models/user_decorator.rb')
      o = Order.create(:email => 'old@test.com')
      o.update_attributes_without_callbacks(:completed_at => Time.now)
      @user = User.create(:email => 'old@test.com', :password => 'spree123', :password_confirmation => 'spree123')
    end

    it "should include the confirmable Devise module" do
      User.devise_modules.include?(:confirmable).should be_true
    end

    before { Devise.stub_chain :mailer, :confirmation_instructions, :deliver => true }

    context "when created" do

      it "should send confirmation instruction when a regular user is created" do
        @user.confirmation_token.should_not be_nil
      end

      it "should not send confirmation instructions when an anonymous user is created" do
        anonymous = User.anonymous!
        anonymous.confirmation_token.should be_nil
      end

      it "should not send confirmation instructions when a regular user is created with no unclaimed orders" do
        user = User.create(:email => 'other@test.com', :password => 'spree123', :password_confirmation => 'spree123')
        user.stub(:unclaimed_orders => [])
        user.confirmation_token.should be_nil
      end

    end

    context "User.anonymous!" do

      let(:anonymous) { User.anonymous! }

      it "should return a user in the database" do
        anonymous.id.should_not be_nil
      end

    end

    context "#save" do

      before { @user.confirm! }

      context "email address changes" do

        it "should set confirmed_at to nil" do
          @user.email = "new@test.com"
          @user.save
          @user.confirmed_at.should be_nil
        end

      end

      it "should not claim any unclaimed orders if confirmed_at is nil" do
        @user.stub(:confirmed_at => nil)
        @user.should_not_receive(:claim_all_unclaimed_orders)
        @user.stub(:unclaimed_orders => ['something'])
        @user.save
      end

      context "email address does not change" do

        it "should not change confirmed_at" do
          @user.login = "login"
          @user.save
          @user.confirmed_at.should_not be_nil
        end

      end

    end

    context "#claim_all_unclaimed_orders" do

      let(:order) { mock_model(Order) }

      before do
        @user.stub(:unclaimed_orders => [order])
        order.stub(:assign_to_rightful_owner)
      end

      it "should not assign unclaimed_orders to rightful owner if confirmation is required" do
        @user.stub(:confirmation_required? => true)
        order.should_not_receive(:assign_to_rightful_owner)
        @user.claim_all_unclaimed_orders
      end

      it "should assign unclaimed_orders to rightful owner if confirmed" do
        @user.stub(:confirmation_required? => false)
        order.should_receive(:assign_to_rightful_owner)
        @user.claim_all_unclaimed_orders
      end

    end

    context "#unclaimed_orders" do

      before do
        @claimed = @user.orders.create(:email => @user.email)
        @unclaimed_incomplete = Order.create(:user=> User.anonymous!, :email => @user.email)
        @unclaimed_complete = Order.create(:user=> User.anonymous!, :email => @user.email)
        @unclaimed_complete.update_attributes_without_callbacks(:completed_at => Time.now)
      end

      it "should not include unclaimed_complete in result" do
        @user.unclaimed_orders.include?(@unclaimed_complete).should == true
      end

      it "should not include unclaimed_incomplete in result" do
        @user.unclaimed_orders.include?(@unclaimed_incomplete).should == false
      end

      it "should not included already associated orders in result" do
        @user.unclaimed_orders.include?(@claimed).should == false
      end
    end


  end

  context "email confirmation not required" do

    context "confirmable already included" do

      before do
        User.devise_modules << :confirmable
        Spree::ClaimOrder::Config.set(:require_email_confirmation => false)
        load('app/models/user_decorator.rb')
      end

      it "should include the confirmable Devise module" do
         User.devise_modules.include?(:confirmable).should be_true
      end

    end

    context "confirmable not included" do

      before do
        User.devise_modules.delete(:confirmable)
        Spree::ClaimOrder::Config.set(:require_email_confirmation => false)
        load('app/models/user_decorator.rb')
        @user = User.create(:email => 'old@test.com', :password => 'spree123', :password_confirmation => 'spree123')
      end

      it "should not include the confirmable Devise module" do
        User.devise_modules.include?(:confirmable).should be_false
      end

      context "when created" do

        it "should not send confirmation instruction when a regular user is created" do
          @user.confirmation_token.should be_nil
        end

      end

      context "User.anonymous!" do

        let(:anonymous) { User.anonymous! }

        it "should return a user in the database" do
          anonymous.id.should_not be_nil
        end

      end

      context "#claim_all_unclaimed_orders" do

        let(:order) { mock_model(Order) }

        before do
          @user.stub(:unclaimed_orders => [order])
          order.stub(:assign_to_rightful_owner)
        end

        it "should assign unlaimed_orders to rightful owner if confirmed_at is nil" do
          @user.stub(:confirmed_at => nil)
          order.should_receive(:assign_to_rightful_owner)
          @user.claim_all_unclaimed_orders
        end

      end

    end

  end

end