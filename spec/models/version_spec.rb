require 'spec_helper'

describe Version do
  describe "validation" do
    before do
      @version = Factory.build(:version, :package_id => 1)
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
      Factory.create(:version, @version.attributes)
      @version.should have(1).error_on(:number)
    end

    it "should pass if the same version number is used in other package" do
      Factory.create(:version, @version.attributes.merge(:package_id => @version.package_id + 1))
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
  end

  describe 'documents association' do
    describe '.index method' do
      before do
        @version  = Factory.create(:version, :package_id => 1)
        @document = Factory.create(:document, :version => @version, :path => 'index')
      end

      it "should get found by the 'index' method" do
        Version.find(@version).documents.index.should == @document
      end
    end

    describe 'clean up' do
      before do
        Document.delete_all

        @version  = Factory.create(:version, :package_id => 1)
        @document = Factory.create(:document, :version => @version)
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

        @version = Factory.build(:version, :package_id => 1)
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
      end
    end
  end

end
