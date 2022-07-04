require "omniauth"
require "figaro"

Rails.application.config.middleware.use OmniAuth::Builder do
  #TODO: assert the ENV variables exist when implementing Oauth

  provider :developer if (Rails.env.development?)
  provider :google_oauth2,
           ENV["OAUTH_CLIENT_ID"],
           ENV["OAUTH_CLIENT_SECRET"],
           scope: "email,profile",
           access_type: "online",
           response_type: "code",
           redirect_uri: "http://localhost:8888/google-auth/custom-redirect"
end

OmniAuth.config.allowed_request_methods = %i[get]
