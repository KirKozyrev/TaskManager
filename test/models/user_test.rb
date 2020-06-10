require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'create' do
    user = create(:user)
    assert user.persisted?
  end

  test 'create token' do
    user = create(:user)
    user.create_reset_digest

    user_db = User.find_by(id: user.id)

    assert_not user_db[:reset_digest].nil?
    assert_not user_db[:reset_sent_at].nil?
  end
end
