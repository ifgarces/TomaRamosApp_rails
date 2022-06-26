require "omniauth"
require "figaro"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if (Rails.env.development?)
  provider :google_oauth2,
           ENV["GCLOUD_CLIENT_ID"],
           ENV["CGLOUD_PRIVATE_KEY_ID"],
           scope: "email,profile",
           redirect_uri: "http://localhost:8888/google-auth/redirect"
end

OmniAuth.config.allowed_request_methods = %i[get]
