require "spec_helper"

describe UserMailer do
  describe "#welcome" do
    let(:user) { create :user }
    let(:mail) { UserMailer.welcome user }

    describe "headers" do
      it { mail.subject.should eq("Welcome to future game.") }
      it { mail.to.first.should eq user.info[:email] }
      it { mail.from.first.should eq "do-not-reply@future-game.com" }
    end

    describe "content" do
      it { mail.body.should match my_account_url }
    end
  end

  describe "#godbye" do
    let(:user) { create :user }
    let(:mail) { UserMailer.godbye user }

    describe "headers" do
      it { mail.subject.should eq("Thank you for playing!") }
      it { mail.to.first.should eq user.info[:email] }
      it { mail.from.first.should eq "do-not-reply@future-game.com" }
    end

    describe "content" do
      it { mail.body.should match login_url }
    end
  end

end
