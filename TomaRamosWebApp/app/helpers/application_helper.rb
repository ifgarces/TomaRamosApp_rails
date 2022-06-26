require "redcarpet"

module ApplicationHelper
  # Temporal only: it should be true in the views if the user is authenticated.
  TEMP_DEBUG_SHOW_NAV_BARS = false

  TOP_NAV_BAR_HEIGHT = "80px"
  BOTTOM_NAV_BAR_HEIGHT = "76px"

  # Renders a Markdown from a file name.
  #
  # References (many thanks, boys):
  #  - https://stackoverflow.com/questions/36957097/rails-4-how-i-use-the-contents-of-a-markdown-file-in-a-view
  #
  # @param filename [String] Relative to the Rails root directory
  # @return [String] Rendered HTML
  def renderMarkdownFile(filename)
    filename = "%s/%s" % [Rails.root, filename]
    Rails.logger.info("Rendering Markdown '#{filename}'")

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
