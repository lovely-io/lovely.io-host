module ApplicationHelper
  def javascript_include_core
    if core = Package.find_by_name('core')
      if version = core.versions.last
        javascript_include_tag Rails.env == 'production' ?
          "http://cdn.lovely.io/core-#{version.number}.js" :
          "http://#{request.host_with_port}/core-#{version.number}.js"
      end
    end
  end

  def flash_messages
    unless flash.empty?
      content_tag :div, flash.map{ |key, value|
        content_tag :div, value, :class => key
      }.join("\n").html_safe, :id => :flash
    end
  end

  def body_class_name
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end

  def disqus_comments
    return '' if Rails.env != 'production'
    content_tag(:div, '', :id => :disqus_thread) +
    content_tag(:script, %Q{
      var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = 'http://lovelyio.disqus.com/embed.js';
      document.getElementsByTagName('head')[0].appendChild(dsq);
    }, :type => 'text/javascript')
  end

  def md(string='')
    string = Redcarpet.new(string, *MD_OPTIONS).to_html
    MD_PATCHES.each{ |patch| string.gsub! *patch }
    string.html_safe
  end

  MD_OPTIONS = [
    :autolink, :filter_html, :no_image, :no_intraemphasis
  ]

  MD_PATCHES = [
    ["code>",        "tt>"     ],
    ["<pre><tt>",    "<pre>"   ],
    ["</tt></pre>",  "</pre>"  ]
  ]
end
