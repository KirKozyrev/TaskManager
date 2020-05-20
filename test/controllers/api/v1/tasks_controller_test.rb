require 'test_helper'

class Api::V1::TasksControllerTest < ActionController::TestCase
  test 'should get show' do
    author = create(:user)
    task = create(:task, author: author)
    get :show, params: { id: task.id, format: :json }
    assert_response :success
  end

  test 'should get index' do
    get :index, params: { format: :json }
    assert_response :success
  end

  test 'should post create' do
    author = create(:user)
    sign_in(author)
    assignee = create(:user)
    task_attributes = attributes_for(:task).
      merge({ assignee_id: assignee.id })
    post :create, params: { task: task_attributes, format: :json }
    assert_response :created

    data = JSON.parse(response.body)
    created_task = Task.find_by(id: data['task']['id'])

    assert created_task.present?
    task_attributes.keys.each do |key|
      assert_equal task_attributes.stringify_keys[key.to_s].to_s, created_task[key.to_s].to_s
    end
  end

  test 'should put update' do
    author = create(:user)
    assignee = create(:user)
    task = create(:task, author: author)
    task_attributes = attributes_for(:task).
      merge({ author_id: author.id, assignee_id: assignee.id }).
      stringify_keys

    patch :update, params: { id: task.id, format: :json, task: task_attributes }
    assert_response :success

    task.reload
    task_attributes.keys.each do |key|
      assert_equal task_attributes[key.to_s].to_s, task[key.to_s].to_s
    end
  end

  test 'should delete destroy' do
    author = create(:user)
    task = create(:task, author: author)
    delete :destroy, params: { id: task.id, format: :json }
    assert_response :success

    assert !Task.where(id: task.id).exists?
  end
end