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

    def gzip(string)
      require 'zlib'

      io   = StringIO.new
      gzip = Zlib::GzipWriter.new(io)
      gzip << string
      gzip.close

      io.string
    end

    describe "without a version number" do
      before do
        @package = Factory.create(:package)
        @version = @package.version

        Package.should_receive(:find).with('123').and_return(@package)
        @package.versions.should_receive(:last).and_return(@version)
        @version.should_receive(:build).and_return("the build")

        get :script, :id => '123'
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should send the package build back" do
        response.body.should == gzip("the build")
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
        @package = Factory.create(:package)
        @version = @package.version

        Package.should_receive(:find).with('123').and_return(@package)
        @package.versions.should_receive(:find_by_number).with('1.2.3').and_return(@version)
        @version.should_receive(:build).and_return("the build")

        get :script, :id => '123', :version => '1.2.3'
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should send the specified version build" do
        response.body.should == gzip("the build")
      end

      it "should send the text/javascript content type" do
        response.content_type.should == 'text/javascript'
      end

      it "should set an 1 year cache period" do
        response.header['Cache-Control'].should == "max-age=#{1.year.to_i}, public"
      end

      it "should set the Last-Modified header" do
        response.header['Last-Modified'].should == @version.updated_at.utc.httpdate
      end

      it "should set the Expires header" do
        response.header['Expires'].should == (@version.updated_at + 1.year).utc.httpdate
      end

      it "should set the ETag header" do
        response.header['ETag'].should_not be_blank
      end
    end

    describe "when a package doesn't exists" do
      before do
        Package.should_receive(:find).with('123').and_raise(ActiveRecord::RecordNotFound)

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

    describe "when If-Modified-Since header is present" do
      before do
        @package = Factory.create(:package)
        @version = @package.version

        Package.should_receive(:find).with('123').and_return(@package)
        @package.versions.should_receive(:last).and_return(@version)

        @version.updated_at = 2.months.ago

        @request.env['HTTP_IF_MODIFIED_SINCE'] = 1.day.ago.utc.rfc2822

        get :script, :id => '123'
      end

      it "should send 304 response back" do
        response.status.should == 304
      end

      it "should set the correct last-modified header" do
        response.headers['Last-Modified'].should == @version.updated_at.utc.httpdate
      end

      it "should send an empty body" do
        response.body.should be_blank
      end
    end
  end

  describe "#image" do
    describe "without a version number" do
      before do
        @package = Factory.create(:package)
        @version = @package.version
        @image   = Factory.build(:image)

        Package.should_receive(:find).with('123').and_return(@package)
        @package.versions.should_receive(:last).and_return(@version)
        @version.images.should_receive(:find_by_path).
          with('some/image.png').and_return(@image)

        get :image, :id => '123', :path => 'some/image.png'
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should send the image raw data" do
        response.body.should == @image.raw_data
      end

      it "should send the correct content type" do
        response.content_type.should == @image.content_type
      end

      it "should set an 1 day cache period" do
        response.header['Cache-Control'].should == "max-age=#{1.day.to_i}, public"
      end
    end

    describe "with a version number" do
      before do
        @package = Factory.create(:package)
        @version = @package.version
        @image   = Factory.build(:image)
        @image.updated_at = Time.now.dup

        Package.should_receive(:find).with('123').and_return(@package)
        @package.versions.should_receive(:find_by_number).with('1.2.3').and_return(@version)
        @version.images.should_receive(:find_by_path).
          with('some/image.png').and_return(@image)

        get :image, :id => '123', :version => '1.2.3', :path => 'some/image.png'
      end

      it "should send the 200 ok header" do
        response.should be_ok
      end

      it "should send the image raw data" do
        response.body.should == @image.raw_data
      end

      it "should send the correct content type" do
        response.content_type.should == @image.content_type
      end

      it "should set an 1 year cache period" do
        response.header['Cache-Control'].should == "max-age=#{1.year.to_i}, public"
      end

      it "should set the Last-Modified header" do
        response.header['Last-Modified'].should == @image.updated_at.utc.httpdate
      end

      it "should set the Expires header" do
        response.header['Expires'].should == (@image.updated_at + 1.year).utc.httpdate
      end

      it "should set the ETag header" do
        response.header['ETag'].should_not be_blank
      end
    end

    describe "when a package doesn't exists" do
      before do
        Package.should_receive(:find).with('123').and_raise(ActiveRecord::RecordNotFound)

        get :image, :id => '123', :path => 'some/image.png'
      end

      it "should send the 404 status" do
        response.status.should == 404
      end

      it "should send an empty body" do
        response.body.should be_empty
      end
    end

  end
end
