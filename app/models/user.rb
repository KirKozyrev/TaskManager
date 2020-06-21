class User < ApplicationRecord
  attr_accessor :reset_token

  has_one_attached :avatar

  has_secure_password
  has_many :my_tasks, class_name: 'Task', foreign_key: :author_id
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: /@/ }

  def create_reset_digest
    self.reset_token = User.new_token
    self.update(reset_digest: User.encrypt(reset_token), reset_sent_at: Time.zone.now)
  end

  def token_expire?
    return true if self.reset_sent_at < 24.hours.ago
  end

  def self.encrypt(string)
    Base64.encode64(string)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
