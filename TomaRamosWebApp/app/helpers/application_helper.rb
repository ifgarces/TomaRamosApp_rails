require "redcarpet"

module ApplicationHelper

  #? Is there a better way to encapsulate this? could this be automated maybe based on releases on
  #? the private GitHub repo of the project
  APP_VERSION_NAME = "0.1" #"2022-20.0"

  # Navigation bars dimensions
  TOP_NAV_BAR_HEIGHT = "70px"
  BOTTOM_NAV_BAR_HEIGHT = "82px"

  # @param requestParams [Hash]
  # @return [Boolean] Whether both navigation bars should be displayed depending on the request
  # (e.g. on the current controller or webpage)
  def shouldNavBarsBeHidden(requestParams)
    return (requestParams[:controller] != "pages")
  end

  # @param startTime [Time]
  # @param endTime [Time]
  # @return [String]
  def getReadableTimeInterval(startTime, endTime)
    return "%s:%s – %s:%s" % [startTime.hour, startTime.min, endTime.hour, endTime.min]
  end

  # Allows to set a button of the nav bar as highlighted based on the current request path.
  # @param buttonHref [String]
  # @return [String]
  def getClassForBottomNavButton(buttonHref)
    return "btn " + case (buttonHref)
      when "/home"
        (request.path == "/home") ? "btn-secondary" : "btn-outline-secondary"
      when "/courses"
        (
          (request.path == "/courses") || request.path.match(/course_instance*/)
        ) ? "btn-secondary" : "btn-outline-secondary"
      when "/schedule"
        (request.path == "/schedule") ? "btn-secondary" : "btn-outline-secondary"
      when "/evaluations"
        (request.path == "/evaluations") ? "btn-secondary" : "btn-outline-secondary"
      else
        raise ArgumentError.new("Unexpected value '#{buttonHref}', can't get CSS class")
      end
  end

  # Renders a Markdown from a file name.
  #
  # References (many thanks, boys):
  #  - https://stackoverflow.com/questions/36957097/rails-4-how-i-use-the-contents-of-a-markdown-file-in-a-view
  #
  # @param filename [String] Relative to the Rails root directory
  # @return [String] Rendered HTML
  def renderMarkdownFile(filename)
    filename = "%s/%s" % [Rails.root, filename]
    Rails.logger.debug("Rendering Markdown file '#{filename}'")

    raise ArgumentError.new(
      "Markdown file '#{filename}' not found"
    ) unless File.exist?(filename)

    renderer = Redcarpet::Render::HTML.new({
      filter_html: true,
      no_images: true, #! can't due Rails' security behavior for assets
      no_links: false,
      no_styles: false,
      safe_links_only: false,
      with_toc_data: false, #* would be interesting, but not in this case
      hard_wrap: true,
      prettify: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    })
    @markdown ||= Redcarpet::Markdown.new(renderer, {
      autolink: false,
      disable_indented_code_blocks: true,
      strikethrough: true,
      lax_spacing: false,
      space_after_headers: true,
      superscript: true,
      underline: false,
      highlight: true,
      quote: true #?
    })

    mdRawContent = File.open(filename, File::RDONLY).read()
    @markdown.render(mdRawContent).html_safe()
  end
end
