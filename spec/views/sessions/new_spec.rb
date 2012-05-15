require "spec_helper"

describe "sessions/new" do
  before { logout; render }

  it { rendered.should have_selector "#login_msg" }

  context "when in development env" do
    it { rendered.should have_selector "a#developer_login" }
    it { rendered.should have_link_to "/auth/developer" }
  end
end
