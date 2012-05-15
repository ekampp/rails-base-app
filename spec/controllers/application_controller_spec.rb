require "spec_helper"

describe ApplicationController do
  describe "#logged_in?" do
    it { should respond_to :logged_in? }
    context "when a user is logged in" do
      before { controller.stub(:current_user).and_return true }
      it { controller.logged_in?.should be_true }
    end
    context "when a user is not logged in" do
      before { controller.stub(:current_user).and_return false }
      it { controller.logged_in?.should be_false }
    end
  end

  describe "#current_user" do
    let(:user) { create :user }
    it { should respond_to :current_user }
    context "when a valid session is set" do
      before { session[:user_id] = user.id }
      it { controller.current_user.should eq user }
    end
    context "with an invalid session" do
      before { session[:user_id] = "hej" }
      it { controller.current_user.should be_nil }
    end
  end
end
