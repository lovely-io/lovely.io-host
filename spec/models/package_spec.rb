require 'spec_helper'

describe Package do
  describe "validation" do
    before do
      @package = Factory.build(:package)

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
      Factory.create(:package, :name => @package.name)
      @package.should have(1).error_on(:name)
    end

    it "should fail with a reserved name" do
      RESERVED_PACKAGE_NAMES.each do |name|
        @package.name = name
        @package.should have(1).error_on(:name)
      end
    end

    it "should fail without a description" do
      @package.description = ''
      @package.should have(1).error_on(:description)
    end

    it "should fail with a too long description" do
      @package.description = 'a' * 1.kilobyte
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

    it "should fail with too large builds" do
      @package.build = 'a' * 256.kilobytes
      @package.should have(1).error_on(:build)
    end

    it "should fail without a readme string" do
      @package.documents = {}
      @package.should have(1).error_on(:documents)
    end

    it "should fail with too large readme file" do
      @package.documents = {'index' => 'a' * 256.kilobytes}
      @package.should have(1).error_on("document 'index'")
    end

  end

  describe "mass-assignment" do
    before do
      @user    = Factory.create(:user)
      @package = Package.new(Factory.attributes_for(:package, :owner => @user))
    end

    it "should not assign the 'owner' reference" do
      @package.owner.should be_nil
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
      @package.versions.last.number.should == '1.0.0'
    end

    it "should return the version number back" do
      @package.version.number.should == '1.0.0'
    end
  end

  describe "version switch" do
    before do
      @package = Factory.create(:package, {
        :version   => '1.0.0',
        :build     => "Build 1",
        :documents => {:index => "Readme 1"}
      })

      @package.version   = '2.0.0'
      @package.build     = 'Build 2'
      @package.documents = {:index => "Readme 2"}
      @package.save!

      @package = Package.find(@package)
    end

    it "should use the latest version by default" do
      @package.version.number.should  == '2.0.0'
      @package.documents.index.text.should == "Readme 2"
    end

    it "should use a previous build and readme when switched to another version" do
      @package.version = '1.0.0'

      @package.version.number.should  == '1.0.0'
      @package.documents.index.text.should == "Readme 1"
    end
  end

  describe "#name attribute as the primary key" do
    before do
      @package = Factory.create(:package)
    end

    it "should return the name as the param" do
      @package.to_param.should == @package.name
    end

    it "should be findable by it's ID" do
      Package.find(@package.id).should == @package
    end

    it "should be findable by it's name" do
      Package.find(@package.name).should == @package
    end

    it "should raise ActiveRecord::RecordNotFound for a non-existing name" do
      lambda {
        Package.find('non-existing-name')
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "dependencies" do
    before do
      @p1 = Factory.create(:package)
      @p2 = Factory.create(:package)
      @p3 = Factory.create(:package)
      @p4 = Factory.create(:package)

      @deps = {
        "#{@p1.name}" => "#{@p1.version.number}",
        "#{@p2.name}" => "#{@p2.version.number}"
      }

      @package = Factory.create(:package, :dependencies => @deps)
    end

    it "should save the dependencies" do
      @package = Package.find(@package)
      @package.dependencies.should == @deps.dup
    end
  end

  describe "build assignment/access" do
    before do
      @build_text = "Some build text"
      @package = Factory.create(:package, :build => @build_text)
      @package = Package.find(@package)
    end

    it "should save the build" do
      @package.build.should == @build_text
    end

    it "should save it in the version" do
      @package.versions.last.build.should == @build_text
    end
  end

  describe "documents assignment/access" do
    before do
      @docs_hash = {
        'index'    => 'index document',
        'docs/boo' => 'docs/boo document'
      }

      @package = Factory.create(:package, :documents => @docs_hash)
      @package = Package.find(@package)
    end

    it "should save the documentation" do
      @package.documents.urls.sort.should == @docs_hash.keys.sort
    end

    it "should save the documents in the version record" do
      @package.versions.last.documents.should == @package.documents
    end
  end

  describe "#manifest parsing" do
    before do
      @manifest = {
        :name         => "some-package",
        :description  => "Some description",
        :version      => "1.2.3",
        :license      => "IDOYS",
        :home_url     => "http://bla.bla.bla",
        :owner_id     => "Hacking you!",
        :dependencies => {
          "pack1" => "1.2.3",
          "pack2" => "2.3.4"
        }
      }

      @package = Package.new(:manifest => @manifest.to_json)
    end

    it "should assign the name" do
      @package.name.should == @manifest[:name]
    end

    it "should assign the description" do
      @package.description.should == @manifest[:description]
    end

    it "should assign the version number" do
      @package.version.number.should == @manifest[:version]
    end

    it "should assign the dependencies list" do
      @package.dependencies.should == @manifest[:dependencies]
    end

    it "should assign the license" do
      @package.license.should == @manifest[:license]
    end

    it "should assign the home_url attribute" do
      @package.home_url.should == @manifest[:home_url]
    end

    it "should not access properties that are not on the list" do
      @package.owner_id.should_not == @manifest[:owner_id]
    end

    it "should have no manifest errors with a valid manifest" do
      @package.should have(0).errors_on(:manifest)
    end

    it "should set an error if the manifest is malformed" do
      @package.manifest = "I'm gonna get ya!"
      @package.should have(1).error_on(:manifest)
    end
  end

=begin

  describe "#to_json" do
    before do
      @package = Factory.create(:package)
      @v1 = @package.versions.first
      @v2 = Factory.create(:version, :package => @package)
      @v2 = Factory.create(:version, :package => @package)

      @package = Package.find(@package)
    end

    it "should export the thing in an object like that" do
      JSON.parse(@package.to_json).should == {
        'name'         => @package.name,
        'description'  => @package.description,
        'author'       => @package.owner.name,
        'license'      => @package.license,
        'versions'     => @package.versions.map(&:number),
        'dependencies' => @package.dependencies || {},
        'created_at'   => @package.created_at.as_json,
        'updated_at'   => @package.updated_at.as_json
      }
    end
  end
=end
end
