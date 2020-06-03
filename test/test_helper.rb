require 'coveralls'
Coveralls.wear!('rails')

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  Capybara.default_max_wait_time = 25
  parallelize(workers: :number_of_processors)

  fixtures :all

  include FactoryBot::Syntax::Methods
  include AuthHelper
end
