class SendTaskDeleteNotificationJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer

  def perform(task_id, task_author)
    user = User.find_by(id: task_author);
    UserMailer.with(user: user, id: task_id).task_deleted.deliver_now
  end
end
