module ShowsHelper
  def vimeo_video(id)
    %Q{
      <iframe class="video" src="http://player.vimeo.com/video/#{id}?title=0&amp;byline=0&amp;portrait=0" width="768" height="432" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
    }.html_safe
  end
end