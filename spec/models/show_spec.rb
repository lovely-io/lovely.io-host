require 'spec_helper'

describe Show do
  describe 'validation' do
    let(:show) { Factory.build(:show) }

    it "should pass with valid attributes" do
      show.should be_valid
    end

    it "should fail without a title" do
      show.title = ''
      show.should have(1).error_on(:title)
    end

    it "should fail with a non-uniq title" do
      other_news = Factory.create(:show)
      show.title = other_news.title
      show.should have(1).error_on(:title)
    end

    it "should fail without a text" do
      show.text = ''
      show.should have(1).error_on(:text)
    end

    it "should fail without a vimeo_id" do
      show.vimeo_id = ''
      show.should have(1).error_on(:vimeo_id)
    end
  end

  describe '#uri' do
    let(:show) { Factory.create(:show, :title => "Some very-cool.show--") }

    it "should generate an uri out of the title" do
      show.uri.should == 'some-very-cool-show'
    end

    it "should return the uri with the #to_param method" do
      show.to_param.should == show.uri
    end

    it "should find the news by the uri" do
      Show.find(show.uri).should == show
    end

    it "should rais ActiveRecord::RecordNotFound when a news is not found" do
      lambda {
        Show.find('some non existing uri')
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should still find the news by an integer id" do
      Show.find(show.id).should == show
    end
  end
end
