require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  include AuthenticationMocks

  describe "GET #new" do
    before do
      get :new
    end

    it "should render the 'new' template" do
      response.should render_template('new')
    end

    it "should send 200 ok header" do
      response.should be_ok
    end
  end

  describe "POST #create" do
    describe "with successful authentication" do
      before do
        @data = {'omniauth' => 'data'}
        @user = Factory.create(:user)
        User.should_receive(:find_or_create_by_auth).with(@data).and_return(@user)

        @request.env['omniauth.auth'] = @data

        post :create
      end

      it "should assign the current user correctly" do
        controller.send(:current_user).should == @user
      end

      it "should set the flash 'notice'" do
        flash[:notice].should_not be_empty
      end

      it "should redirect to the root_url" do
        response.should redirect_to(root_path)
      end
    end

    describe "with failed authentication" do
      before do
        User.should_not_receive(:find_or_create_by_auth)

        post :create
      end

      it "should render the 'new' template" do
        response.should render_template('new')
      end

      it "should set the 'error' flash" do
        flash[:error].should_not be_empty
      end
    end
  end

  describe "GET #destroy" do
    before do
      controller.send(:current_user=, Factory.create(:user))

      get :destroy
    end

    it "should reset the current_user reference" do
      controller.send(:current_user).should be_nil
    end

    it "should redirect to the root_url" do
      response.should redirect_to(root_path)
    end
  end
end