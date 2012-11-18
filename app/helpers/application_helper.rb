module ApplicationHelper
  def title
    base_title = "Trinkets"
    if @title.nil?
      "#{base_title} | The simplest way to keep track of your stuff"
    else
      "#{base_title} | #{@title}"
    end
  end
end
