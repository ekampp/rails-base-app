require 'spec_helper'

describe SessionsController do

  #
  # NOTE: That since I'm using onmiauth, it's a big problem to test the correct
  #       behaviour, so this will have to be build on later in the process. For
  #       now, we are just testing that the action is present.
  #       <emil@kampp.me>
  #
  describe "#create" do
    it { should respond_to :create }
    let(:user) { create :user }
    before { controller.stub(:auth_hash).and_return {} }
    before { User.stub(:find_or_initialize_by).and_return user }
    before { post :create }

    context "variables" do
      it { assigns(:user).should eq user }
      it { controller.current_user.should eq user }
      it { session[:user_id].should eq user.id }
    end

    context "response" do
      it { response.should be_redirect }
    end
  end

  describe "#new" do
    it { should respond_to :new }

    context "when logged in" do
      let(:user) { create(:user) }
      before { login_with user; get :new }
      it { should redirect_to my_account_path }
    end

    context "when logged out" do
      before { logout; get :new }
      it { should render_template :new }
    end
  end

  describe "#destroy" do
    it { should respond_to :destroy }

    before { get :destroy }
    it { session[:user_id].should be_nil }
    it { response.should redirect_to root_path }
  end
end
