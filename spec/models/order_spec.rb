require 'spec_helper'

describe Order do

  let(:email) { 'user@test.com' }
  let(:password) { 'spree123' }
  let(:order) { Order.create(:email => email, :user => User.anonymous!) }
  let(:user) { mock_model(User, :email => email, :password => password, :password_confirmation => password) }

  context "email confirmation required" do

    before do
      User.devise_modules.delete(:confirmable)
      Spree::ClaimOrder::Config.set(:require_email_confirmation => true)
      load('app/models/user_decorator.rb')
    end

    context "after save" do

      context "order is not completed" do

        before { order.stub(:completed_at => nil)}

        it "should not associate with correct user" do
          order.should_not_receive(:assign_to_rightful_owner)
          order.save
        end

      end
    end

    context "#assign_to_rightful_owner" do

      it "should return false if user does not exist with matching email address" do
        User.stub(:find_by_email => nil)
        order.assign_to_rightful_owner.should be_false
      end

      it "should return false if user is not confirmed" do
        User.stub(:find_by_email => user)
        user.stub(:confirmed? => false)
        order.assign_to_rightful_owner.should be_false
      end

      it "should re-assign order to user if user is found and confirmed" do
        User.stub(:find_by_email => user)
        user.stub(:confirmed? => true)
        order.assign_to_rightful_owner
        order.user.should == user
      end

    end

  end

  context "email confirmation required" do

    before do
      User.devise_modules.delete(:confirmable)
      Spree::ClaimOrder::Config.set(:require_email_confirmation => false)
      load('app/models/user_decorator.rb')
    end

    context "#assign_to_rightful_owner" do

      it "should return false if user does not exist with matching email address" do
        User.stub(:find_by_email => nil)
        order.assign_to_rightful_owner.should be_false
      end

      it "should return true if user is not confirmed" do
        User.stub(:find_by_email => user)
        user.stub(:confirmed? => false)
        order.assign_to_rightful_owner.should be_true
      end

      it "should re-assign order to user if user is found and confirmed" do
        User.stub(:find_by_email => user)
        user.stub(:confirmed? => true)
        order.assign_to_rightful_owner
        order.user.should == user
      end

    end


  end

end