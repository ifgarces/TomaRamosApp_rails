require "redcarpet"
require "utils/logging_util"
require "enums/event_type_enum"

module ApplicationHelper
  FEEDBACK_FORM_URL = "https://forms.gle/cm4YeuNtS9PrDutc8"
  COOKIE_INFORMATION_URL = "https://www.kaspersky.es/resource-center/definitions/cookies"

  # Names of controllers in which navbars should be visible.
  CONTROLLERS_WITH_NAV_BARS = ["main", "course_instances", "course_events", "event_types"]

  # Note: could not find documentation on the constructor of Rails' `ApplicationHelper`, so I named
  # the arguments myself... Anyway, this is for initializing logging on this module.
  def initialize(context, optionsHash, originController)
    super(context, optionsHash, originController)
    @log = LoggingUtil.getStdoutLogger(__FILE__)
  end

  # Gets the background color for a [non-evaluation] event in the week schedule view.
  #
  # @param event [CourseEvent]
  # @return [String] Color HEX
  def self.getScheduleColorForEvent(event)
    return case (event.event_type.name)
      when EventTypeEnum::CLASS
        "white"
      when EventTypeEnum::ASSISTANTSHIP
        "#cafccd"
      when EventTypeEnum::LABORATORY
        "#cadefc"
      else
        raise RuntimeError.new(
          "Unexpected type name '%s' for event %s: should be non-evaluation type" % [
            event.event_type.name, event
          ]
        )
    end
  end

  # @return [User] The stored user from the `session`, creating it if needed.
  def getUserFromSession()
    user = User.find_by(id: session[:guestUserId])
    if (session[:guestUserId].nil? || user.nil?)
      user = createNewSessionUser()
    end
    return user
  end

  # Used to check whether a host entered the application for the first time (or the session expired).
  #
  # @return [Boolean] Whether there is user data stored in session (cookies) or not. Also ensures
  #   the data is consistent (user exists in database).
  def isUserInSession()
    return (session[:guestUserId] != nil) && (User.find_by(id: session[:guestUserId]) != nil)
  end

  # @return [User]
  def createNewSessionUser()
    guestUser = User.createNewGuestUser()
    session[:guestUserId] = guestUser.id
    @log.info("New guest User created '#{guestUser.username}', for host '#{request.host}'")
    return guestUser
  end

  # @param requestParams [Hash]
  # @return [Boolean] Whether both navigation bars should be displayed depending on the request
  #   (e.g. on the current controller or webpage)
  def shouldDisplayNavBars(requestParams)
    return CONTROLLERS_WITH_NAV_BARS.include?(requestParams[:controller])
  end

  # Allows to set a button of the nav bar as highlighted based on the current request path.
  #
  # @param buttonHref [String]
  # @return [String]
  def getClassForBottomNavButton(buttonHref)
    return "btn " + case (buttonHref)
      when "/courses"
        [/\/courses/, /\/catalog*/, /\/course_instance*/].any? { |pathRegex|
          request.path.match(pathRegex)
        } ? "btn-secondary" : "btn-outline-secondary"
      when "/schedule"
        request.path.match(/\/schedule/) ? "btn-secondary" : "btn-outline-secondary"
      when "/evaluations"
        request.path.match(/\/evaluations/) ? "btn-secondary" : "btn-outline-secondary"
      else
        errMsg = "Unexpected value '#{buttonHref}', can't get CSS class"
        @log.fatal(errMsg)
        raise ArgumentError.new(errMsg)
      end
  end

  # @param curriculum [String]
  # @return [String] Color HEX
  def self.getDecorationClassForCurriculum(curriculum)
    return "border " + case (curriculum)
    when "2022"
      "border-success"
    when "2016"
      "border-info"
    when "2016/2022", "2022/2016"
      "border-white"
    else
      "border-2 border-warning"
    end
  end

  # References: https://stackoverflow.com/a/42119143/12684271
  #
  # @return [Boolean] Whether the current request is from the local network (development) or not.
  def isRequestLocal()
    return [request.remote_addr, request.remote_ip].all? { |host|
      (host == "localhost") || host.start_with?("127.")
    }
  end

  # Renders Markdown from a file name.
  #
  # References (many thanks, boys):
  #  - https://stackoverflow.com/questions/36957097/rails-4-how-i-use-the-contents-of-a-markdown-file-in-a-view
  #
  # @param filename [String] Filename of the MD file inside ${RAILS_ROOT}/markdown.
  # @return [String] Rendered HTML
  def renderMarkdownFile(filename)
    filepath = File.join(File.join(Rails.root, "markdown"), filename)

    @log.debug("Rendering Markdown file '%s'" % [filepath])

    raise ArgumentError.new(
      "Markdown file '%s' not found" % [filepath]
    ) unless File.exist?(filepath)

    @renderer ||= Redcarpet::Render::HTML.new({
      filter_html: true,
      no_images: true, #! can't due Rails' security constraints for assets
      no_links: false,
      no_styles: false,
      safe_links_only: false,
      with_toc_data: false,
      hard_wrap: true,
      prettify: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    })
    @markdown ||= Redcarpet::Markdown.new(@renderer, {
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

    mdRawContent = File.open(filepath, File::RDONLY).read()
    @markdown.render(mdRawContent).html_safe()
  end
end
