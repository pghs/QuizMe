OmniAuth.config.logger = Rails.logger

SERVICES = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :developer unless Rails.env.production?
  provider :facebook, SERVICES['facebook']['key'], SERVICES['facebook']['secret'] # if SERVICES['github']
  provider :twitter, SERVICES['twitter']['key'], SERVICES['twitter']['secret'] # if SERVICES['twitter']
  provider :tumblr, SERVICES['tumblr']['key'], SERVICES['tumblr']['secret'] # if SERVICES['tumblr']
end