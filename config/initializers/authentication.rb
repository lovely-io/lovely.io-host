AUTHENTICATION_PROVIDERS = []
Rails.application.config.middleware.use OmniAuth::Builder do
  YAML.load_file("config/authentication.yml")[Rails.env].each do |type, params|
    AUTHENTICATION_PROVIDERS << type
    provider type.to_sym, params['key'], params['secret']
  end
end
