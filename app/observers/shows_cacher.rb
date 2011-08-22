#
# The shows cache sweeper
#
class ShowsCacher < ActiveRecord::Observer
  observe :show

  def after_create(show)
    clean_cache
  end

  def after_update(show)
    clean_cache show
  end

  def after_destroy(show)
    clean_cache show
  end

protected

  def clean_cache(show=nil)
    system "rake app:clean:shows #{
      show ? "SHOW_URI=#{show.uri}" : ''
    } &2> /dev/null"
  end

end