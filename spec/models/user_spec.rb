require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "validation" do
    before do
      @user = FactoryGirl.create(:user)
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

    it "should be invalid with a malformed email" do
      @user.email = 'malformed'
      @user.should have(1).error_on(:email)
    end

    it "should allow empty emails" do
      @user.email = ''
      @user.should have(0).errors_on(:email)
    end
  end

  describe "mass-assignment" do
    before do
      @user = User.new(FactoryGirl.attributes_for(:user))
    end

    it "should assign the email" do
      @user.email.should_not be_empty
    end

    it "should assign the name" do
      @user.name.should_not be_empty
    end

    it "should assign the home-url property" do
      @user.home_url.should_not be_empty
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
        @user = FactoryGirl.create(:user, :provider => @auth['provider'], :uid => @auth['uid'])
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

      describe "#home_url assignment" do
        it "should correctly set a twitter's user location" do
          @auth['provider'] = 'twitter'
          @user = User.find_or_create_by_auth(@auth)
          @user.home_url.should == "http://twitter.com/#{@auth['user_info']['nickname']}"
        end

        it "should correctly set a github account location" do
          @auth['provider'] = 'github'
          @user = User.find_or_create_by_auth(@auth)
          @user.home_url.should == "http://github.com/#{@auth['user_info']['nickname']}"
        end

        it "should correctly set a facebooker's external location" do
          @auth['provider'] = 'facebook'
          @user = User.find_or_create_by_auth(@auth)
          @user.home_url.should == "http://www.facebook.com/profile.php?id=#{@auth['uid']}"
        end
      end

    end

  end

  describe "#new_auth_token!" do
    before do
      @user = FactoryGirl.create(:user)
      @token = @user.new_auth_token!
    end

    it "should create an auth-token" do
      @token.should_not be_blank
    end

    it "should save a hash in the database" do
      user = User.find(@user)
      user.auth_token.should_not be_blank
      user.auth_token.should_not include(@token.split('$').last)
    end

    it "should embed the user's ID into the token" do
      @token.split('$').first.should == @user.id.to_s
    end
  end

  describe ".find_by_auth_token" do
    before do
      @user  = FactoryGirl.create(:user)
      @token = @user.new_auth_token!
    end

    it "should find a user by a correct token" do
      User.find_by_auth_token(@token).should == @user
    end

    it "should find nothing if the token is wrong" do
      User.find_by_auth_token("#{@user.id}$bogustoken").should be_nil
    end
  end
end