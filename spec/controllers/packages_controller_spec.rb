require 'spec_helper'

describe PackagesController do
  include AuthenticationMocks

  before do
    @user = FactoryGirl.create(:user)
  end

  describe "GET #index" do
    before do
      @package = FactoryGirl.create(:package)
      Package.stub!(:find).and_return([@package])
    end

    it "should render OK by default" do
      get :index
      response.should be_ok
      response.should render_template('index')
    end

    it "should render the JSON response as well" do
      get :index, :format => 'json'
      response.should be_ok
      response.body.should == "[#{@package.to_json}]"
    end
  end

  describe "GET #show" do
    it "should render the packages/show if package exists" do
      @package = FactoryGirl.create(:package)
      Package.should_receive(:find).with('123').and_return(@package)

      get :show, :id => '123'

      response.should be_ok
      response.should render_template('packages/show')
    end

    it "should render 404 when package is not found" do
      get :show, :id => '999999-non-existing'

      response.status.should == 404
      response.should render_template('pages/404')
    end
  end

  describe "POST #create" do
    describe "when accessed anonymously" do
      it "should render 422 error" do
        post :create

        response.status.should == 422
        response.should render_template('sessions/new')
      end
    end

    describe "when accessed by a logged-in user" do
      before do
        logged_in! @user

        @package = FactoryGirl.create(:package)
        @params  = {'package' => 'params'}

        Package.should_receive(:new).with(@params).and_return(@package)
      end

      it "should assign the owner" do
        post :create, :package => @params

        @package.owner.should == @user
      end

      it "should render JSON response with the package url when saved successfully" do
        @package.should_receive(:save).and_return(true)

        post :create, :package => @params

        response.should be_ok
        response.content_type.should == 'application/json'
        response.body.should == {:url => package_url(@package)}.to_json
      end

      it "should render the package errors when the saving is failed" do
        @package.should_receive(:save).and_return(false)
        @package.should_receive(:errors).and_return(@errors = {'the' => 'errors'})

        post :create, :package => @params

        response.should be_ok
        response.content_type.should == 'application/json'
        response.body.should == {:errors => @errors}.to_json
      end
    end
  end

  describe "DELETE #destroy" do
    describe "when accessed anonymously" do
      it "should render 422 error" do
        delete :destroy, :id => '123'

        response.status.should == 422
        response.should render_template('sessions/new')
      end
    end

    describe "when logged in correctly" do
      before do
        logged_in! @user

        @package = FactoryGirl.create(:package, :owner => @user)
        Package.should_receive(:find).with(@package.id.to_s).and_return(@package)

        @version = @package.versions.last
      end

      it "should render 404 for a non-existing package" do
        Package.find(@package.id.to_s) # reseting the should_receive mock
        Package.should_receive(:find).with('9999').and_raise(ActiveRecord::RecordNotFound)

        delete :destroy, :id => '9999'

        response.status.should == 404
        response.should render_template('pages/404')
      end

      it "should render 422 access-denied when accessing someone else's package" do
        @package.owner = FactoryGirl.create(:user)

        delete :destroy, :id => @package.id

        response.status.should == 422
        response.should render_template('pages/422')
      end

      it "should require a :version parameter" do
        @package.should_not_receive(:destroy)
        @version.should_not_receive(:destroy)

        delete :destroy, :id => @package.id

        response.should be_ok
        response.content_type.should == 'application/json'
        response.body.should == {:errors => {:server => "can't find the version"}}.to_json
      end

      it "should call #destroy on the package" do
        @package.should_receive(:destroy)
        @version.should_receive(:destroy)

        @package.versions.should_receive(:find_by_number).with(@version.number).and_return(@version)
        @package.versions.should_receive(:count).and_return(0)

        delete :destroy, :id => @package.id, :version => @version.number
      end

      it "should render JSON with the packages_url back" do
        @package.versions.should_receive(:find_by_number).with(@version.number).and_return(@version)

        delete :destroy, :id => @package.id, :version => @version.number

        response.should be_ok
        response.content_type.should == 'application/json'
        response.body.should == {:url => packages_url}.to_json
      end
    end
  end
end