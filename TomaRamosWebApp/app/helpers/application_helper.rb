require "redcarpet"
require "utils/logging_util"
require "enums/event_type_enum"

module ApplicationHelper
  APP_VERSION_NAME = "0.1"

  # Dimension constants
  MAX_WEBPAGE_WIDTH = "650px"
  TOP_NAV_BAR_HEIGHT = "70px"
  BOTTOM_NAV_BAR_HEIGHT = "82px"

  # Note: could not find documentation on the constructor of Rails' `ApplicationHelper`, so I named
  # these myself...
  def initialize(context, optionsHash, originController)
    super(context, optionsHash, originController)
    @@log = LoggingUtil.getStdoutLogger(__FILE__)
  end

  # @return [User] The stored user from the `session`, creating it if needed.
  def getUserFromSession()
    guestUserId = session[:guestUserId]

    if ((guestUserId == nil) || (User.find_by(id: guestUserId) == nil))
      guestUser = User.createNewGuestUser()
      guestUser.save!()
      session[:guestUserId] = guestUser.id
      @log.info("New guest User created '#{guestUser.username}', for host '#{request.host}'")
    else
      guestUser = User.find_by(id: guestUserId)
    end

    return guestUser
  end

  # @param requestParams [Hash]
  # @return [Boolean] Whether both navigation bars should be displayed depending on the request
  #   (e.g. on the current controller or webpage)
  def shouldNavBarsBeHidden(requestParams)
    return (requestParams[:controller] != "pages")
  end

  # Allows to set a button of the nav bar as highlighted based on the current request path.
  #
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

  # References: https://stackoverflow.com/a/42119143/12684271
  #
  # @return [Boolean] Whether the server is running on localhost in the developer's machine, or not.
  def isRequestLocal()
    return [request.remote_addr, request.remote_ip].map { |host|
      (host == "localhost") || host.start_with?("127.")
    } == [true, true]
  end

  # Gets the background color for a [non-evaluation] event in the week schedule view.
  # @param event [CourseEvent]
  # @return [String]
  def self.getScheduleColorForEvent(event)
    return case (event.event_type.name)
      when EventTypeEnum::CLASS
        "white"
      when EventTypeEnum::ASSISTANTSHIP
        "#cafccd"
      when EventTypeEnum::LABORATORY
        "#cadefc"
      else
        raise RuntimeError.new("Unexpected type name '%s' for event %s: should be non-evaluation type" % [
          event.event_type.name, event]
        )
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
    
    @@log.debug("Rendering Markdown file '#{filename}'")

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
