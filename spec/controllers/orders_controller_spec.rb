require 'spec_helper'

describe OrdersController do

  context "routes" do
    it "should understand the claim route" do
      { :put => '/orders/R123/claim' }.should route_to(:controller => "orders", :action => "claim", :id => 'R123')
    end
  end

  context "claim" do

    let(:email) { 'user@test.com' }
    let(:password) { 'spree123' }
    let(:order) { Order.create(:user => User.anonymous!, :email => email) }
    let(:user) { mock_model(User, :email => email) }

    before do
      controller.stub(:current_user).and_return(user)
      user.stub(:has_role? => false)
      user.stub(:confirmed? => true)
    end

    it "should redirect to account_path" do
      put :claim, {:id => order.number}
      response.should redirect_to(account_path)
    end

    it "should find correct order" do
      Order.should_receive(:find_by_number).and_return(order)
      put :claim, {:id => order.number}
    end

    it "should call #assign_to_rightful_owner on order" do
      Order.stub(:find_by_number => order)
      order.should_receive :assign_to_rightful_owner
      put :claim, {:id => order.number}
    end

    context "when assign_to_rightful_owner is successful" do
      before do
        Order.stub(:find_by_number => order)
        order.stub(:assign_to_rightful_owner => true)
        put :claim, {:id => '123'}
      end

      it "should set flash[:notice]" do
        flash[:notice].should_not be_nil
      end

      it "should not set flash[:error]" do
        flash[:error].should be_nil
      end
    end

    context "when assign_to_rightful_owner is not successful" do
      before do
        Order.stub(:find_by_number => order)
        order.stub(:assign_to_rightful_owner => false)
        put :claim, {:id => '123'}
       end

      it "should set flash[:error]" do
        flash[:error].should_not be_nil
      end

      it "should not set flash[:notice]" do
        flash[:notice].should be_nil
      end
    end

  end

end