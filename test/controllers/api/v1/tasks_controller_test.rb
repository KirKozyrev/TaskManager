require 'test_helper'

class Api::V1::TasksControllerTest < ActionController::TestCase
  def after_teardown 
    super
    remove_uploaded_files 
  end
    
  def remove_uploaded_files 
    FileUtils.rm_rf(ActiveStorage::Blob.service.root) 
  end

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
    task_attributes = attributes_for(:task).merge({ assignee_id: assignee.id })

    assert_emails 1 do
      post :create, params: { task: task_attributes }, format: 'json'
    end
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
    sign_in(author)
    assignee = create(:user)
    task = create(:task, author: author)
    task_attributes = attributes_for(:task).
      merge({ author_id: author.id, assignee_id: assignee.id }).
      stringify_keys

    assert_emails 1 do
      patch :update, params: { id: task.id, task: task_attributes }, format: 'json'
    end
    assert_response :success

    task.reload
    task_attributes.keys.each do |key|
      assert_equal task_attributes[key.to_s].to_s, task[key.to_s].to_s
    end
  end

  test 'should delete destroy' do
    author = create(:user)
    sign_in(author)
    task = create(:task, author: author)

    assert_emails 1 do
      delete :destroy, params: { id: task.id }, format: 'json'
    end
    assert_response :success

    assert !Task.where(id: task.id).exists?
  end

  test 'should put attach_image' do
    author = create(:user)
    task = create(:task, author: author)
    image = file_fixture('test_photo.png')
    attachment_params = { image: Rack::Test::UploadedFile.new(image, 'image/png'), crop_x: 190, crop_y: 100, crop_width: 300, crop_height: 300 }

    put :attach_image, params: { id: task.id, attachment: attachment_params, format: :json }

    assert_response :success
    task.reload(assert { task.image.attached? })
  end

  test 'should put remove_image' do
    author = create(:user)
    task = create(:task, author: author)
    image = file_fixture('test_photo.png')
    attachableimage = Rack::Test::UploadedFile.new(image)
    task.image.attach(attachable_image)

    put :remove_image, params: { id: task.id, format: :json }

    assert_response :success
    task.reload(refute { task.image.attached? })
  end
end
