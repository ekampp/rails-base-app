require File.expand_path('../boot', __FILE__)

# NOTE: We are not using the full stack of railies, so we only load the ones,
#       that we use. <emil@kampp.me>
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  # Because we precompile assets on deployment, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module FutureGame
  class Application < Rails::Application
    config.encoding = "utf-8"

    # Logging
    config.filter_parameters += [:password]

    # Assets
    config.assets.enabled = true
    config.assets.version = '1.0'

    # Generators
    config.generators do |g|
      g.helper false
      g.orm :mongoid
      g.assets false
      g.template_engine :haml
      g.test_framework :rspec, :fixtures => :factory_girl
    end
  end
end
