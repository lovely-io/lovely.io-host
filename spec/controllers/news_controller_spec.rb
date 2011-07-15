require 'spec_helper'

describe NewsController do
  include AuthenticationMocks

  before do
    @news = Factory.create(:news)
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "should assign the @news variable" do
      assigns[:news].should == [@news]
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
      News.should_receive(:find).with('some-url').and_return(@news)

      get :show, :id => 'some-url'
    end

    it "should assign the @news variable" do
      assigns[:news].should == @news
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
        News.should_receive(:new).and_return(@news)
        get :new
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should assign the @news variable" do
        assigns[:news].should == @news
      end

      it "should render the 'new' page" do
        response.should render_template('news/new')
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

        @news = News.new
        @data = {'some' => 'params'}
        News.should_receive(:new).with(@data).and_return(@news)
        @news.should_receive("author=").with(@current_user)
      end

      describe "with correct params" do
        before do
          @news.should_receive(:save).and_return(true)
          post :create, :news => @data
        end

        it "should redirect to the @news location" do
          response.should redirect_to(@news)
        end
      end

      describe "with incorrect data" do
        before do
          @news.should_receive(:save).and_return(false)
          post :create, :news => @data
        end

        it "should rerender the 'news/new' page" do
          response.should be_ok
          response.should render_template('news/new')
        end
      end
    end
  end

  describe "GET #edit" do
    describe "anonymous" do
      before do
        get :edit, :id => 'news-id'
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
        get :edit, :id => 'news-id'
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
        News.should_receive(:find).with('news-id').and_return(@news)
        get :edit, :id => 'news-id'
      end

      it "should assign the @news variable" do
        assigns[:news].should == @news
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should render the 'new' page" do
        response.should render_template('news/edit')
      end
    end
  end

  describe "POST #update" do
    describe "with anonymous" do
      before do
        put :update, :id => 'news-id'
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
        put :update, :id => 'news-id'
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
        News.should_receive(:find).with('news-id').and_return(@news)
      end

      describe "with correct params" do
        before do
          @news.should_receive(:update_attributes).with(@data).and_return(true)
          put :update, :id => 'news-id', :news => @data
        end

        it "should redirect to the @news location" do
          response.should redirect_to(@news)
        end
      end

      describe "with incorrect data" do
        before do
          @news.should_receive(:update_attributes).with(@data).and_return(false)
          put :update, :id => 'news-id', :news => @data
        end

        it "should rerender the 'news/new' page" do
          response.should be_ok
          response.should render_template('news/edit')
        end
      end
    end
  end

  describe "DELETE #destroy" do
    describe "with anonymous" do
      before do
        delete :destroy, :id => 'news-id'
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
        delete :destroy, :id => 'news-id'
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

        News.should_receive(:find).with('news-id').and_return(@news)
        @news.should_receive(:destroy)

        delete :destroy, :id => 'news-id'
      end

      it "should redirect back to the news index" do
        response.should redirect_to(news_index_path)
      end
    end
  end

end