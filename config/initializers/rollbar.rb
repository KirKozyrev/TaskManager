Rollbar.configure do |config|
  config.access_token = '88a2e474717f4a4fa30665d87a08ee14'

  if Rails.env.test?
    config.enabled = false
  end

  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
end
