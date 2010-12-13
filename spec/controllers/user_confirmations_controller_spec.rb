require 'spec_helper'

describe UserConfirmationsController do

  let(:user) { mock_model(User, :email => 'user@test.com') }

  before do
    request.env["devise.mapping"] = :user # not sure why this is necessary
  end

  context "routes" do
    it "should understand the /user_confirmation/:confirmation_token route" do
      { :get => 'user_confirmation/ABCDEFG' }.should route_to(:controller => "user_confirmations", :action => "show", :confirmation_token => "ABCDEFG")
    end

    it "should understand the /user_confirmation route" do
      { :post => 'user_confirmation' }.should route_to(:controller => "user_confirmations", :action => "create")
    end
  end

  context "#create" do

    before do
      controller.stub :current_user => user
      User.stub(:send_confirmation_instructions => user)
    end

    it "should call User.send_confirmation_instructions" do
      User.should_receive(:send_confirmation_instructions).with(user)
      post :create
    end

    it "should redirect to account_path" do
      post :create
      response.should redirect_to(account_path)
    end

    context "when send_confirmation_instructions is successful" do
      before do
        user.stub(:errors => [])
        post :create
      end

      it "should set flash[:notice]" do
        flash[:notice].should == I18n.t("instructions_sent_success")
      end

      it "should not set flash[:error]" do
        flash[:error].should be_nil
      end
    end

    context "when send_confirmation_instructions is not successful" do
      before do
        user.stub(:errors => ["some error"])
        post :create
       end

      it "should set flash[:error]" do
        flash[:error].should == I18n.t("already_confirmed")
      end

      it "should not set flash[:notice]" do
        flash[:notice].should be_nil
      end
    end

  end

  context "#show" do

    before do
      controller.stub :current_user => user
      User.stub(:confirm_by_token => user)
    end

    it "should call User.confirm_by_token" do
      User.should_receive(:confirm_by_token)
      get :show, {:confirmation_token => "TOKEN"}
    end

    it "should redirect to account_path" do
      get :show, {:confirmation_token => "TOKEN"}
      response.should redirect_to(account_path)
    end

    context "when token is valid" do
      before do
        user.stub(:errors => [])
        get :show, {:confirmation_token => "TOKEN"}
      end

      it "should set flash[:notice]" do
        flash[:notice].should == I18n.t("account_confirmation_successful")
      end

      it "should not set flash[:error]" do
        flash[:error].should be_nil
      end
    end

    context "when token is invalid" do
      before do
        user.stub(:errors => ["some error"])
        get :show, {:confirmation_token => "TOKEN"}
      end

      it "should set flash[:error]" do
        flash[:error].should == I18n.t("invalid_token")
      end

      it "should not set flash[:notice]" do
        flash[:notice].should be_nil
      end
    end

  end

end