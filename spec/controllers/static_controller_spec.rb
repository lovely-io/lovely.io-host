require 'spec_helper'

describe StaticController do
  describe "GET #page" do
    describe "when a page exists" do
      before do
        get :page, :id => 'about'
      end

      it "should send 200 ok back" do
        response.should be_ok
      end

      it "should render 'pages/index'" do
        response.should render_template('pages/about')
      end
    end

    describe "when a page doesn't exists" do
      before do
        get :page, :id => "non existing"
      end

      it "should set the 404 response status" do
        response.status.should == 404
      end

      it "should render 404 error" do
        response.should render_template('pages/404')
      end
    end
  end

  describe "GET #script" do

    describe "without a version number" do
      before do
        Dir.should_receive(:[]).with("#{ASSETS_DIR}/123-*.js").and_return("123-0.0.0.js")
        File.should_receive(:read).and_return("the build")
        get :script, :id => '123'
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should send the package build back" do
        response.body.should == "the build"
      end

      it "should send the text/javascript content type" do
        response.content_type.should == 'text/javascript'
      end

      it "should set an 1 day cache period" do
        response.header['Cache-Control'].should == "max-age=#{1.day.to_i}, public"
      end
    end

    describe "with a version number" do
      before do
        File.should_receive(:read).with("#{ASSETS_DIR}/123-1.2.3.js").and_return("the build")

        get :script, :id => '123', :version => '1.2.3'
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should send the specified version build" do
        response.body.should == "the build"
      end

      it "should send the text/javascript content type" do
        response.content_type.should == 'text/javascript'
      end

      it "should set an 1 year cache period" do
        response.header['Cache-Control'].should == "max-age=#{1.year.to_i}, public"
      end
    end

    describe "when a package doesn't exists" do
      before do
        File.should_receive(:read).and_raise(StandardError)
        get :script, :id => '123', :format => :js
      end

      it "should send the 404 status" do
        response.status.should == 404
      end

      it "should send the text/javascript content type" do
        response.content_type.should == 'text/javascript'
      end

      it "should send a JavaScript comment in the body" do
        response.body.should == "/* 404 Page is not found */"
      end
    end
  end
end
