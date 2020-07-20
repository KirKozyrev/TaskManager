module UserRepository
  def self.included(base)
    base.extend(ClassMethods)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    create_reset_digest if User.find_by(reset_digest: User.encrypt(reset_token))
    update(reset_digest: User.encrypt(reset_token), reset_sent_at: Time.zone.now)
  end

  def token_expire?
    reset_sent_at < ONE_DAY_AGO
  end

  module ClassMethods
    def encrypt(string)
      Base64.encode64(string)
    end
    
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
