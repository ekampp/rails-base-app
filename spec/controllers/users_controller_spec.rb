require 'spec_helper'

describe UsersController do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:admin) { create :admin }

  describe "#edit" do
    it { should respond_to :edit }

    context "logged in" do
      before { login_with user; get :edit }
      it { assigns(:user).should eq user }
    end
  end

end
