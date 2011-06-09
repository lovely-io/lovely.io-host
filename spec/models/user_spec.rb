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
end