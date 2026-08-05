require_relative "boot"

require "rails"
# Pick the frameworks we need, excluding Active Storage/Action Text/Action Mailbox
# (system libvips here is 8.12.1, older than the 8.13 Active Storage requires;
# this app doesn't need file uploads/rich text/inbound email, so skip them entirely
# rather than fighting a system library upgrade for unused functionality).
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BottledWaterTrnc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # tr is primary/default; el and ru are added here later with no route/controller
    # changes required elsewhere (see config/locales and the Mobility-backed models).
    config.i18n.available_locales = [:tr, :en]
    config.i18n.default_locale = :tr
  end
end
