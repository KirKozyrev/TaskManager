require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get edit' do
    user = create(:user)
    get :edit, params: { id: user.id }
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    user_attrs = attributes_for(:user)
    post :create, params: { user: user_attrs }
    new_user = User.find_by(email: user_attrs[:email])
    assert new_user.present?
  end

  test 'should patch update' do
    user = create(:user)
    user_attrs = attributes_for(:user)
    patch :update, params: { id: user.id, user: user_attrs }
    searched_user = User.find(user.id)
    user_attrs.each do |key, value|
      unless (key.to_s == 'password') || (key.to_s == 'reset_digest')
        assert_equal value, searched_user[key]
      end
    end
  end

  test 'should delete destroy' do
    user = create(:user)
    delete :destroy, params: { id: user.id }
    assert_not User.exists?(id: user.id)
  end
end
