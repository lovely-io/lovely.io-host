require 'spec_helper'

describe Package do
  describe "validation" do
    before do
      @package = Package.new

      Factory.attributes_for(:package).each do |key, value|
        @package.send("#{key}=", value)
      end

      @package.owner = Factory.create(:user)
    end

    it "should pass with valid attributes" do
      @package.should be_valid
    end

    it "should fail without an owner reference" do
      @package.owner_id = nil
      @package.should have(1).error_on(:owner_id)
    end

    it "should fail without a name" do
      @package.name = ''
      @package.should have(1).error_on(:name)
    end

    it "should fail with a malformed name" do
      @package.name = '--boo---'
      @package.should have(1).error_on(:name)
    end

    it "should fail with a non-uniq name" do
      @package.name = Factory.create(:package).name
      @package.should have(1).error_on(:name)
    end

    it "should fail without a description" do
      @package.description = ''
      @package.should have(1).error_on(:description)
    end

    it "should fail without a version number" do
      @package.version = ''
      @package.should have(1).error_on(:version)
    end

    it "should fail with a malformed number" do
      @package.version = 'some crap'
      @package.should have(1).error_on(:version)
    end

    it "should fail without a build string" do
      @package.build = ''
      @package.should have(1).error_on(:build)
    end

    it "should fail without a readme string" do
      @package.readme = ''
      @package.should have(1).error_on(:readme)
    end
  end

  describe "#version assignment" do
    before do
      @package = Package.new
      @package.version = '1.0.0'
    end

    it "should create a Version reference" do
      @package.should have(1).versions
    end

    it "should bypass the version number" do
      @package.versions[0].number.should == '1.0.0'
    end

    it "should return the version number back" do
      @package.version.should == '1.0.0'
    end
  end

  describe "mass-assignment" do
    before do
      @user = Factory.create(:user)
      @package = Package.new(Factory.attributes_for(:package, :owner => @user))
    end

    it "should not assign the 'owner' reference" do
      @package.owner.should be_nil
    end
  end

  describe "version switch" do
    before do
      @package = Factory.create(:package, {
        :version => '1.0.0',
        :build   => "Build 1",
        :readme  => "Readme 1"
      })

      @package.version = '2.0.0'
      @package.build   = 'Build 2'
      @package.readme  = 'Readme 2'
      @package.save!

      @package = Package.find(@package)
    end

    it "should use the latest version by default" do
      @package.version.should == '2.0.0'
      @package.build.should   == 'Build 2'
      @package.readme.should  == "<p>Readme 2</p>\n"
    end

    it "should use a previous build and readme when switched to another version" do
      @package.version = '1.0.0'

      @package.version.should == '1.0.0'
      @package.build.should   == 'Build 1'
      @package.readme.should  == "<p>Readme 1</p>\n"
    end
  end
end
