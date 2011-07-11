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

    it "should fail with a too long description" do
      @package.description = 'a' * 1.kilobyte
      @package.should have(1).error_on(:description)
    end

    it "should fail without a version number" do
      @package.version = ''
      @package.should have(2).error_on(:version)
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
      @package.build = 'a' * 500.kilobytes
      @package.should have(1).error_on(:build)
    end

    it "should fail without a readme string" do
      @package.readme = ''
      @package.should have(1).error_on(:readme)
    end

    it "should fail with too large readme file" do
      @package.readme = 'a' * 500.kilobytes
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
      @package.readme.should  == "Readme 2"
    end

    it "should use a previous build and readme when switched to another version" do
      @package.version = '1.0.0'

      @package.version.should == '1.0.0'
      @package.build.should   == 'Build 1'
      @package.readme.should  == "Readme 1"
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
        "#{@p1.name}" => "#{@p1.version}",
        "#{@p2.name}" => "#{@p2.version}"
      }

      @package = Factory.create(:package, :dependencies => @deps)
    end

    it "should save the dependencies" do
      package = Package.find(@package)
      package.version = package.versions.first

      package.dependencies.should == @deps.dup
    end
  end

  describe "#manifest parsing" do
    before do
      @manifest = {
        :name         => "some-package",
        :description  => "Some description",
        :version      => "1.2.3",
        :license      => "IDOYS",
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
      @package.version.should == @manifest[:version]
    end

    it "should assign the dependencies list" do
      @package.dependencies.should == @manifest[:dependencies]
    end

    it "should assign the license" do
      @package.license.should == @manifest[:license]
    end

    it "should have no manifest errors with a valid manifest" do
      @package.should have(0).errors_on(:manifest)
    end

    it "should set an error if the manifest is malformed" do
      @package.manifest = "I'm gonna get ya!"
      @package.should have(1).error_on(:manifest)
    end
  end

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
end
