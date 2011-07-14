require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  include AuthenticationMocks

  before do
    @user = Factory.create(:user)
  end

  describe "GET #index" do
    describe "as an admin" do
      before do
        admin!
        get :index
      end

      it "should render the pages index" do
        response.should render_template('index')
      end

      it "should send 200 ok" do
        response.should be_ok
      end
    end

    describe "with a regular user" do
      before do
        logged_in!
        get :index
      end

      it "should send 422 error back" do
        response.status.should == 422
      end

      it "should render the 422 page" do
        response.should render_template('pages/422')
      end
    end
  end

  describe "GET #show" do
    before do
      User.should_receive(:find).with('the-id').and_return(@user)

      get :show, :id => 'the-id'
    end

    it "should assign @user variable" do
      assigns[:user].should == @user
    end

    it "should render the 'show' template" do
      response.should render_template('show')
    end

    it "should send 200 Ok status" do
      response.should be_ok
    end
  end

  describe "GET #edit" do
    describe "normal case" do
      before do
        logged_in!(@user)
        User.should_receive(:find).with('the-id').and_return(@user)

        get :edit, :id => 'the-id'
      end

      it "should assign the @user variable" do
        assigns[:user].should == @user
      end

      it "should render the 'edit' page" do
        response.should be_ok
        response.should render_template('edit')
      end
    end

    describe "anonymous access" do
      before do
        anonymous!
        User.should_not_receive(:find).with('the-id')
        get :edit, :id => 'the-id'
      end

      it "should send 422 error" do
        response.status.should == 422
      end

      it "should render the login page" do
        response.should render_template('sessions/new')
      end
    end

    describe "attempt to edit another user" do
      before do
        logged_in!(Factory.create(:user))
        User.should_receive(:find).with('the-id').and_return(@user)

        get :edit, :id => 'the-id'
      end

      it "should send the 422 error" do
        response.status.should == 422
        response.should render_template('pages/422')
      end
    end
  end

  describe "PUT #update" do
    describe "normal case" do
      before do
        logged_in!(@user)
        User.should_receive(:find).with('the-id').and_return(@user)
      end

      describe "with correct data" do
        before do
          @user.should_receive(:update_attributes).with('[some-data]').and_return(true)

          put :update, :id => 'the-id', :user => '[some-data]'
        end

        it "should set the flash[:notice]" do
          flash[:notice].should_not be_empty
        end

        it "should redirect to the profile page" do
          response.should redirect_to(profile_path)
        end
      end

      describe "with incorrect data" do
        before do
          @user.should_receive(:update_attributes).with('[some-data]').and_return(false)
          put :update, :id => 'the-id', :user => '[some-data]'
        end

        it "should render the 'edit' template again" do
          response.should render_template('edit')
        end
      end
    end

    describe "anonymous access" do
      before do
        anonymous!
        User.should_not_receive(:find).with('the-id')
        put :update, :id => 'the-id', :user => '[some-data]'
      end

      it "should send 422 error" do
        response.status.should == 422
      end

      it "should render the login page" do
        response.should render_template('sessions/new')
      end
    end

    describe "attempt to edit another user" do
      before do
        logged_in!(Factory.create(:user))
        User.should_receive(:find).with('the-id').and_return(@user)
        @user.should_not_receive(:update_attributes)

        put :update, :id => 'the-id', :user => '[some-data]'
      end

      it "should send the 422 error" do
        response.status.should == 422
        response.should render_template('pages/422')
      end
    end
  end

  describe "GET #token" do
    describe "simple open the page" do
      before do
        logged_in! @user

        get :token
      end

      it "should not generate a token" do
        assigns[:token].should be_nil
      end

      it "should render the 'token' page" do
        response.should be_ok
        response.should render_template('token')
      end
    end

    describe "actual token generating" do
      before do
        logged_in! @user

        @token = "some-token"
        @user.should_receive(:new_auth_token!).and_return(@token)

        get :token, :create => true
      end

      it "should generate new token" do
        assigns[:token].should == @token
      end

      it "should render the 'token' page" do
        response.should be_ok
        response.should render_template('token')
      end
    end

    describe "anonymous access" do
      before do
        anonymous!
        get :token
      end

      it "should send 422 error" do
        response.status.should == 422
      end

      it "should render the login page" do
        response.should render_template('sessions/new')
      end
    end
  end

  describe "GET #new" do
    it "should render 404 not-found" do
      get :new
      response.status.should == 404
      response.should render_template('pages/404')
    end
  end

  describe "POST #create" do
    it "should render 404 not-found" do
      post :create
      response.status.should == 404
      response.should render_template('pages/404')
    end
  end

  describe "DELETE #destroy" do
    it "should render 404 not-found" do
      delete :destroy, :id => 'some-id'
      response.status.should == 404
      response.should render_template('pages/404')
    end
  end
end