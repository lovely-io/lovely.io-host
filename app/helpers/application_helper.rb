module ApplicationHelper
  def flash_messages
    flash[:notice] = "Hello world!"
    unless flash.empty?
      content_tag :div, flash.map{ |key, value|
        content_tag :div, value, :class => key
      }.join("\n").html_safe, :id => :flash
    end
  end

  def body_class_name
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
end
