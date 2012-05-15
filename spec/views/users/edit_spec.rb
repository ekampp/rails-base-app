require "spec_helper"

describe "users/edit" do
  let(:user) { create(:user) }
  before { login_with user; render }

  it { rendered.should have_selector "h1" }
end
