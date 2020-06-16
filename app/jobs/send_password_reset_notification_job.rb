class SendPasswordResetNotificationJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer
  sidekiq_options lock: :until_and_while_executing, on_conflict: { client: :log, server: :reject }

  def perform(user_id, reset_token)
    user = User.find_by(id: user_id);
    return if user.blank?
    UserMailer.with(user: user, reset_token: reset_token).password_reset.deliver_now
  end
end
