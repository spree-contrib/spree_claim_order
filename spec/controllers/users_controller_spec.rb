require 'spec_helper'

describe UsersController do

  context "routes" do
    it "should understand the send_confirmation_instructions route" do
      { :put => 'send_confirmation_instructions' }.should route_to(:controller => "users", :action => "send_confirmation_instructions")
    end
  end

  context "send_confirmation_instructions" do

    let(:user) { mock_model(User) }

    before do
      controller.stub!(:current_user).and_return(user)
      Devise.stub_chain :mailer, :confirmation_instructions, :deliver => true
    end

    it  "should call send_confirmation_instructions on the current user" do
      user.should_receive :send_confirmation_instructions
      put :send_confirmation_instructions
    end

    it "should redirect to account_path" do
      user.stub :send_confirmation_instructions
      put :send_confirmation_instructions
      response.should redirect_to(account_path)
    end

    context "when send_confirmation_instructions is successful" do
      before do
         user.stub :send_confirmation_instructions => true
         put :send_confirmation_instructions
       end

      it "should set flash[:notice]" do
        flash[:notice].should_not be_nil
      end

      it "should not set flash[:error]" do
        flash[:error].should be_nil
      end
    end

    context "when send_confirmation_instructions is not successful" do
      before do
         user.stub :send_confirmation_instructions => false
         put :send_confirmation_instructions
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