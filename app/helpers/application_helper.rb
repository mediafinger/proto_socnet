module ApplicationHelper

  # return the title-Tag of a given page
  def title
    base_title = "socnet"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # return the logo
  def logo
    image_tag("tower_small.jpg", :alt => 'standing out', :class => 'round')
  end

end

