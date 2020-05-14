require 'test_helper'

class Web::DevelopersControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    new_user_attrs = attributes_for(:developer)
    post :create, params: { developer: new_user_attrs }
    new_user = User.find_by(first_name: new_user_attrs[:first_name])
    assert_not new_user.nil?
  end
end
