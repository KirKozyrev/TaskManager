require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'task created' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_created

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'New Task Created', email.subject
    assert email.body.to_s.include?("Task #{task.id} was created")
  end

  test 'task updated' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_updated

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Task Updated', email.subject
    assert email.body.to_s.include?("Task #{task.id} was updated")
  end

  test 'task deleted' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, id: task.id }
    email = UserMailer.with(params).task_deleted

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Task Deleted', email.subject
    assert email.body.to_s.include?("Task #{task.id} was deleted")
  end

  test 'password reset' do
    user = create(:user)
    user.create_reset_digest
    params = { user: user }.merge({ reset_token: user.reset_token })

    email = UserMailer.with(params).password_reset

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Password Reset', email.subject
    assert email.body.to_s.include?('Link for password reset:')
  end
end
