require 'spec_helper'

describe ShowsController do
  include AuthenticationMocks

  before do
    @show = FactoryGirl.create(:show)
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "should assign the @show variable" do
      assigns[:shows].should == [@show]
    end

    it "should send the 200 ok status back" do
      response.should be_ok
    end

    it "should render the 'index' page" do
      response.should render_template('index')
    end
  end

  describe "GET #show" do
    before do
      Show.should_receive(:find).with('some-url').and_return(@show)

      get :show, :id => 'some-url'
    end

    it "should assign the @show variable" do
      assigns[:show].should == @show
    end

    it "should send the 200 ok header" do
      response.should be_ok
    end

    it "should render the 'show' page" do
      response.should render_template('show')
    end
  end

  describe "GET #new" do
    describe "anonymous" do
      before do
        get :new
      end

      it "should send the 422 header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "regular user" do
      before do
        logged_in!
        get :new
      end

      it "should send the 422 error header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "admin user" do
      before do
        admin!
        Show.should_receive(:new).and_return(@show)
        get :new
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should assign the @show variable" do
        assigns[:show].should == @show
      end

      it "should render the 'new' page" do
        response.should render_template('shows/new')
      end
    end
  end

  describe "POST #create" do
    describe "with anonymous" do
      before do
        post :create
      end

      it "should send the 422 header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "with regular user" do
      before do
        logged_in!
        post :create
      end

      it "should send the 422 error header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "with admin user" do
      before do
        admin!

        @show = Show.new
        @data = {'some' => 'params'}
        Show.should_receive(:new).with(@data).and_return(@show)
        @show.should_receive("author=").with(@current_user)
      end

      describe "with correct params" do
        before do
          @show.should_receive(:save).and_return(true)
          post :create, :show => @data
        end

        it "should redirect to the @show location" do
          response.should redirect_to(@show)
        end
      end

      describe "with incorrect data" do
        before do
          @show.should_receive(:save).and_return(false)
          post :create, :show => @data
        end

        it "should render the 'shows/new' page" do
          response.should be_ok
          response.should render_template('shows/new')
        end
      end
    end
  end

  describe "GET #edit" do
    describe "anonymous" do
      before do
        get :edit, :id => 'show-id'
      end

      it "should send the 422 header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "regular user" do
      before do
        logged_in!
        get :edit, :id => 'show-id'
      end

      it "should send the 422 error header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "admin user" do
      before do
        admin!
        Show.should_receive(:find).with('show-id').and_return(@show)
        get :edit, :id => 'show-id'
      end

      it "should assign the @show variable" do
        assigns[:show].should == @show
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should render the 'new' page" do
        response.should render_template('shows/edit')
      end
    end
  end

  describe "POST #update" do
    describe "with anonymous" do
      before do
        put :update, :id => 'show-id'
      end

      it "should send the 422 header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "with regular user" do
      before do
        logged_in!
        put :update, :id => 'show-id'
      end

      it "should send the 422 error header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "with admin user" do
      before do
        admin!
        @data = {'some' => 'params'}
        Show.should_receive(:find).with('show-id').and_return(@show)
      end

      describe "with correct params" do
        before do
          @show.should_receive(:update_attributes).with(@data).and_return(true)
          put :update, :id => 'show-id', :show => @data
        end

        it "should redirect to the @show location" do
          response.should redirect_to(@show)
        end
      end

      describe "with incorrect data" do
        before do
          @show.should_receive(:update_attributes).with(@data).and_return(false)
          put :update, :id => 'show-id', :show => @data
        end

        it "should rerender the 'shows/new' page" do
          response.should be_ok
          response.should render_template('shows/edit')
        end
      end
    end
  end

  describe "DELETE #destroy" do
    describe "with anonymous" do
      before do
        delete :destroy, :id => 'show-id'
      end

      it "should send the 422 header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "with regular user" do
      before do
        logged_in!
        delete :destroy, :id => 'show-id'
      end

      it "should send the 422 error header" do
        response.status.should == 422
      end

      it "should render the 422 error page" do
        response.should render_template('pages/422')
      end
    end

    describe "with admin user" do
      before do
        admin!

        Show.should_receive(:find).with('show-id').and_return(@show)
        @show.should_receive(:destroy)

        delete :destroy, :id => 'show-id'
      end

      it "should redirect back to the shows index" do
        response.should redirect_to(shows_path)
      end
    end
  end
end
