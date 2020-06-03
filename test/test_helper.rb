ENV['RAILS_ENV'] ||= 'test'
require 'coveralls'
Coveralls.wear!('rails')
require_relative '../config/environment'
require 'rails/test_help'
require 'Capybara'

Capybara.default_max_wait_time = 45

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  include FactoryBot::Syntax::Methods
  include AuthHelper
end
