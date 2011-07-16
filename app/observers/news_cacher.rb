#
# The news cache sweeper
#
class NewsCacher < ActiveRecord::Observer
  observe :news

  def after_create(news)
    clean_cache
  end

  def after_update(news)
    clean_cache news
  end

  def after_destroy(news)
    clean_cache news
  end

protected

  def clean_cache(news=nil)
    system "rake app:clean:news #{
      news ? "NEWS_URI=#{news.uri}" : ''
    } &2> /dev/null"
  end

end