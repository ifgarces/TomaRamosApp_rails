require "omniauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  #TODO: assert the ENV variables exist when implementing Oauth

  provider :developer if (Rails.env.development?)

  provider :google_oauth2,
    ENV.fetch("OAUTH_CLIENT_ID") { nil },
    ENV.fetch("OAUTH_CLIENT_SECRET") { nil },
    scope: "email,profile",
    access_type: "online",
    response_type: "code",
    redirect_uri: "http://localhost:8888/google-auth/custom-redirect"
end

OmniAuth.config.allowed_request_methods = %i[get]
