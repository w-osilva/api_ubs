# Rails Generators - global configuration

Rails.application.config.generators do |g|
  g.test_framework :rspec, fixture: true
  g.stylesheets false
  g.javascripts false
  g.helper false

  # factory bot
  g.fixture_replacement :factory_bot
  g.factory_bot true
  g.factory_bot dir: 'spec/factories'
end