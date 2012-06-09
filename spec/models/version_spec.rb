require 'spec_helper'

describe Version do
  describe "validation" do
    before do
      @version = FactoryGirl.build(:version, :package_id => 1)
    end

    it "should pass with valid attributes" do
      @version.should be_valid
    end

    it "should fail without a number" do
      @version.number = ''
      @version.should have(1).error_on(:number)
    end

    it "should fail with a malformed number" do
      @version.number = 'alfa1'
      @version.should have(1).error_on(:number)
    end

    it "should fail with a non-uniq number" do
      FactoryGirl.create(:version, @version.attributes)
      @version.should have(1).error_on(:number)
    end

    it "should pass if the same version number is used in other package" do
      FactoryGirl.create(:version, :package_id => 2)
      @version.should be_valid
    end

    it "should allow '-smth' name suffixes" do
      @version.number += '-RC2'
      @version.should be_valid
    end

    it "should fail without a build" do
      @version.build = ''
      @version.should have(1).error_on(:build)
    end

    it "should fail if the build is too huge" do
      @version.build = 'a' * 256.kilobytes
      @version.should have(1).error_on(:build)
    end

    it "should fail with too many images" do
      images = {}
      (Version::MAX_IMAGES_COUNT + 1).times do |i|
        images["image#{i}.png"] = "some data"
      end

      @version.images = images

      @version.should have(1).error_on(:base)
    end

    it "should fail without an index document" do
      @version.documents = {}
      @version.should have(1).error_on(:documents)
    end

    it "should pass document errors from documents" do
      @version.documents = {
        'index'        => 'a' * 256.kilobytes,
        'docs/bla bla' => 'asdf',
        'docs/okay'    => 'okay'
      }

      @version.should_not be_valid

      @version.should have(1).error_on("document 'index'")
      @version.should have(1).error_on("document 'docs/bla bla'")
      @version.should have(0).error_on("document 'docs/okay'")
    end

    it "should pass image errors from the images" do
      @version.images = {
        'boo.hoo' => 'some crap',
        'img.png' => 'correct data'
      }

      @version.should_not be_valid

      @version.should have(1).error_on("image 'boo.hoo'")
      @version.should have(0).error_on("image 'img.png")
    end
  end

  describe 'documents association' do
    describe '.index method' do
      before do
        Document.delete_all

        @version  = FactoryGirl.create(:version, :package_id => 1)
        @document = Document.last # already created index from the factory
      end

      it "should get found by the 'index' method" do
        Version.find(@version).documents.index.should == @document
      end
    end

    describe 'clean up' do
      before do
        Document.delete_all

        @version  = FactoryGirl.create(:version, :package_id => 1)
        Document.count.should == 1 # there is an index doc from the factory
      end

      it "should clean up the documents after a version was deleted" do
        Version.find(@version).destroy
        Document.count.should == 0
      end
    end

    describe "via hash assignment" do
      before do
        Document.delete_all

        @docs_hash = {
          'index'    => 'index bla bla bla',
          'docs/boo' => 'docs/boo bla bla bla'
        }

        @version = FactoryGirl.build(:version, :package_id => 1)
        @version.documents = @docs_hash
        @version.save!

        @version = Version.find(@version)
      end

      it "should create two documents" do
        @version.should have(2).documents
      end

      it "should have the defined urls" do
        @version.documents.urls.sort.should == @docs_hash.keys.sort
      end

      it "should allow to update the docs as well" do
        @version.documents = {
          'index' => 'new'
        }
        @version.save!

        @version = Version.find(@version)
        @version.should have(1).document
        @version.documents.index.text.should == 'new'

        Document.count.should == 1
      end
    end
  end

  describe "images association" do
    describe "assignment via hash" do
      before do
        Image.delete_all

        @images_hash = {
          'img1.png' => 'some PNG data',
          'img2.gif' => 'some GIF data'
        }

        @version = FactoryGirl.build(:version, :package_id => 1)
        @version.images = @images_hash
        @version.save!

        @version = Version.find(@version)
      end

      it "should create two images" do
        @version.should have(2).images
      end

      it "should create images with correct paths" do
        @version.images.map(&:path).sort.should == @images_hash.keys.sort
      end

      it "should rebuild all images on the next assignment" do
        @version.images = {
          'img1.png' => 'new PNG data'
        }
        @version.save!

        @version = Version.find(@version)
        @version.should have(1).image
        @version.images.first.path.should == 'img1.png'
        @version.images.first.data.should == 'new PNG data'

        Image.count.should == 1
      end
    end

    describe "build patch" do
      it "should adjust the build text to refer the images on cdn" do
        @package = FactoryGirl.create(:package)
        @version = FactoryGirl.build(:version, :package => @package)
        @version.images = {
          'img/1.png' => 'image 1 content',
          '/img2.png' => 'image 2 content'
        }
        @version.build = %Q{
          'images/img/1.png'
          "/images/img/1.png"
          "images/img2.png"
          '/images/img2.png'
        }

        Package.cdn_url = "http://cdn.test.com"
        @version.save :validate => false

        @version.build.should == %Q{
          'http://cdn.test.com/assets/#{@version.images.first.sha}'
          "http://cdn.test.com/assets/#{@version.images.first.sha}"
          "http://cdn.test.com/assets/#{@version.images.last.sha}"
          'http://cdn.test.com/assets/#{@version.images.last.sha}'
        }
      end
    end
  end

end
