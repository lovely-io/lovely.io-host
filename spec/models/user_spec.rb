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

  describe ".find_or_create_by_auth" do
    before do
      @auth = {
        'provider'   => 'someprovider',
        'uid'        => 'someuid',
        'user_info'  => {
          'name'     => 'User Fullname',
          'location' => 'User Location',
          'image'    => 'http://avatar.url'
        }
      }

      User.delete_all :provider => @auth['provider'], :uid => @auth['uid']
    end

    describe "with existing user" do
      before do
        @user = Factory.create(:user, :provider => @auth['provider'], :uid => @auth['uid'])
      end

      it "should find that user by provider and an UID" do
        User.find_or_create_by_auth(@auth).should == @user
      end
    end

    describe "new user creation" do

      describe "basic properties" do
        before do
          @user = User.find_or_create_by_auth(@auth)
        end

        it "should assign the provider property" do
          @user.provider.should == @auth['provider']
        end

        it "should assign the UID property" do
          @user.uid.should == @auth['uid']
        end

        it "should assign the user name" do
          @user.name.should == @auth['user_info']['name']
        end

        it "should assign the user's location" do
          @user.location.should == @auth['user_info']['location']
        end

        it "should assign the user's avatar url" do
          @user.avatar_url.should == @auth['user_info']['image']
        end
      end

      describe "#external_url assignment" do
        it "should correctly set a twitter's user location" do
          @auth['provider'] = 'twitter'
          @user = User.find_or_create_by_auth(@auth)
          @user.external_url.should == "http://twitter.com/#{@auth['user_info']['nickname']}"
        end

        it "should correctly set a github account location" do
          @auth['provider'] = 'github'
          @user = User.find_or_create_by_auth(@auth)
          @user.external_url.should == "http://github.com/#{@auth['user_info']['nickname']}"
        end

        it "should correctly set a facebooker's external location" do
          @auth['provider'] = 'facebook'
          @user = User.find_or_create_by_auth(@auth)
          @user.external_url.should == "http://www.facebook.com/profile.php?id=#{@auth['uid']}"
        end
      end

    end

  end
end