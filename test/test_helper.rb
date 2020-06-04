ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

require 'coveralls'
Coveralls.wear!
require 'rails/test_help'

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  include FactoryBot::Syntax::Methods
  include AuthHelper
end
