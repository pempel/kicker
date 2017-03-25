module HtmlHelpers
  class Link
    attr_accessor :text, :path, :active, :selected, :disabled
  end

  class LinkSet
    attr_reader :links

    def initialize
      @links = []
    end

    def link
      link = Link.new

      yield link

      @links = @links.map { |l| l.selected = false; l } if link.selected
      @links << link
    end
  end

  def link_group
    group = LinkSet.new

    yield group

    html = ""

    group.links.each do |link|
      link_class = "btn btn-default"
      link_class << " active" if link.active
      html << "<a class='#{link_class}' href='#{link.path}'>#{link.text}</a>"
    end

    html
  end

  def link_dropdown
    dropdown = LinkSet.new

    yield dropdown

    html = ""

    if dropdown.links.count == 1
      link = dropdown.links.first

      link_class = "btn btn-default"
      link_class << " active" if link.active

      html << "<a class='#{link_class}' href='#{link.path}'>#{link.text}</a>"
    else
      selected_link = dropdown.links.find { |l| l.selected }

      button_class = "btn btn-default dropdown-toggle"
      button_class += " active" if selected_link.try(:active)

      html << "<div class='btn-group'>"

      html << "<button class='#{button_class}' data-toggle='dropdown'>"
      html << "#{selected_link.text} " if selected_link.present?
      html << "<span class='caret'></span>"
      html << "</button>"

      html << "<ul class='dropdown-menu'>"
      dropdown.links.each do |link|
        html << (link.disabled ? "<li class='disabled'>" : "<li>")
        html << "<a href='#{link.path}'>#{link.text}</a>"
        html << "</li>"
      end
      html << "</ul>"

      html << "</div>"
    end

    html
  end
end
