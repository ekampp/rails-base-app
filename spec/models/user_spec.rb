require 'spec_helper'

describe User do

  # Required fields
  it { should have_field(:role).of_type(String).with_default_value_of('player') }
  it { should have_field(:provider).of_type(String) }
  it { should have_field(:uid).of_type(String) }
  it { should have_field(:info).of_type(Hash) }
  it { should have_field(:banned).of_type(Boolean).with_default_value_of(false) }

  # Indexes
  it { should have_index_for(:provider) }
  it { should have_index_for(:role) }

  # Validations
  # it { should validate_presence_of(:uid) }
  # it { should validate_uniqueness_of(:uid) }
  it { should validate_presence_of(:provider) }
  it { should validate_inclusion_of(:role).to_allow("player", "admin") }

  describe "Paranoia" do
    it "should not allow destroy to completely remove the records" do
      user = create :user
      user.destroy.should be_true
      User.deleted.include?(user).should be_true
      User.deleted.find(user.id).restore.should be_true
      User.find(user.id).should be_true
    end
    it "should allow to destroy a user by calling +delete!+ explicitely" do
      user = create :user
      user.delete!.should be_true
      User.deleted.include?(user).should be_false
      expect{ User.deleted.find(user.id) }.to raise_error
    end
  end
end
