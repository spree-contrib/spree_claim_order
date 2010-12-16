require 'spec_helper'

describe UserSessionsController do

  context "#create" do

    let(:user) { mock User }
    let(:order) { mock_model Order }

    before do
      controller.stub :is_devise_resource? => true, :resource_name => nil, :require_no_authentication => nil, :user_signed_in? => true
      controller.stub_chain :warden, :authenticate!
      controller.stub :current_order => order
    end

    it "should associate with correct user" do
      controller.stub :current_user => user
      order.stub :associate_user!
      user.should_receive(:claim_all_unclaimed_orders)
      post :create, {}, { :order_id => 1 }
    end

  end

end