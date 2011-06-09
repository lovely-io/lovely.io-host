module ApplicationHelper
  def flash_messages
    unless flash.empty?
      content_tag :div, flash.map{ |key, value|
        content_tag :div, value, :class => key
      }, :id => :flash
    end
  end
end
