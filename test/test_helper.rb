require 'simplecov'
SimpleCov.start

require 'coveralls'
Coveralls.wear!

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

require 'rails/test_help'

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all
  
  include ActionMailer::TestHelper
  include FactoryBot::Syntax::Methods
  include AuthHelper
end
