require 'spec_helper'

describe News do
  describe 'validation' do
    before do
      @news = News.new
      Factory.attributes_for(:news).each do |key, value|
        @news.send("#{key}=", value)
      end
    end

    it "should pass with valid attributes" do
      @news.should be_valid
    end

    it "should fail without a title" do
      @news.title = ''
      @news.should have(1).error_on(:title)
    end

    it "should fail with a non-uniq title" do
      other_news = Factory.create(:news)
      @news.title = other_news.title
      @news.should have(1).error_on(:title)
    end

    it "should fail without a text" do
      @news.text = ''
      @news.should have(1).error_on(:text)
    end
  end

  describe '#uri' do
    before do
      @news = Factory.create(:news, :title => "Some very-important.news--")
    end

    it "should generate an uri out of the title" do
      @news.uri.should == 'some-very-important-news'
    end

    it "should return the uri with the #to_param method" do
      @news.to_param.should == @news.uri
    end

    it "should find the news by the uri" do
      News.find(@news.uri).should == @news
    end

    it "should rais ActiveRecord::RecordNotFound when a news is not found" do
      lambda {
        News.find('some non existing uri')
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should still find the news by an integer id" do
      News.find(@news.id).should == @news
    end
  end
end
