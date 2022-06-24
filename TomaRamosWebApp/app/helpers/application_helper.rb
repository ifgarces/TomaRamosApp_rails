require "redcarpet"

module ApplicationHelper

  # Renders a Markdown from a file name
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
      hard_wrap: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    })
    @markdown ||= Redcarpet::Markdown.new(renderer, {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true
    })

    mdContent = File.open(filename, File::RDONLY).read()
    @markdown.render(mdContent).html_safe()
  end
end
