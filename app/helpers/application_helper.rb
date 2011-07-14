module ApplicationHelper
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

  def md(string='')
    string = Redcarpet.new(string, :autolink, :filter_html, :no_image, :safelink).to_html
    MD_PATCHES.each{ |patch| string.gsub! *patch }
    string.html_safe
  end

  MD_PATCHES = [
    ["code>",        "tt>"     ],
    ["<pre><tt>",    "<pre>"   ],
    ["</tt></pre>",  "</pre>"  ]
  ]
end
