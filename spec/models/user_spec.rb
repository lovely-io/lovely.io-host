require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "validation" do
    before do
      @user = Factory.create(:user)
    end

    it "should be invalid without a provider" do
      @user.provider = ''
      @user.should have(1).error_on(:provider)
    end

    it "should be invalid without an UID" do
      @user.uid = ''
      @user.should have(1).error_on(:uid)
    end

    it "should be invalid with a non uniq UID" do
      user = User.new
      user.provider = @user.provider
      user.uid      = @user.uid
      user.should have(1).error_on(:uid)
    end

    it "should allow same UID for different providers" do
      @user.save

      user = User.new
      user.uid      = @user.uid
      user.provider = "someotherprovider"

      user.should have(0).errors_on(:uid)
    end
  end

  describe "mass-assignment" do
    before do
      @user = User.new(Factory.attributes_for(:user))
    end

    it "should assign the email" do
      @user.email.should_not be_empty
    end

    it "should assign the name" do
      @user.name.should_not be_empty
    end

    it "should not allow to assign the role" do
      @user.role.should be_nil
    end

    it "should not mass-assign auth-provider" do
      @user.provider.should be_nil
    end

    it "should not mass-assign UID" do
      @user.uid.should be_nil
    end
  end

  describe "user-roles" do
    before :each do
      @user = User.new
    end

    it "should say it's an admin when it has the admin role" do
      @user.role = "admin"
      @user.should be_admin
    end

    it "should say it's not an admin when it's not" do
      @user.role = "moderator"
      @user.should_not be_admin
    end
  end
end