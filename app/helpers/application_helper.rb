module ApplicationHelper
  def javascript_include_cdn(*modules)
    modules.map do |name|
      if package = Package.find_by_name(name)
        if version = package.versions.last
          javascript_include_tag(
            "http://cdn.#{request.host_with_port.gsub('www.', '')}/#{package.name}-#{version.number}.js"
          )
        end
      end
    end.compact.join("\n").html_safe
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
    MARKDOWN.render(string).html_safe
  end

  # allows to run greps on a text without huring h1,h2,h3,h4,a,pre,tt and so on tags content
  RENDERER = LovelyRenderer.new(
    filter_html:         true,
    hard_wrap:           true)

  MARKDOWN = Redcarpet::Markdown.new(RENDERER,
    no_intra_emphasis:   true,
    parse_tables:        true,
    fenced_code_blocks:  true,
    autolink:            true,
    space_after_headers: true,
    superscript:         true)
end
