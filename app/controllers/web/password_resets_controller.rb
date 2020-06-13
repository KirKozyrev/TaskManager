class Web::PasswordResetsController < Web::ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @password_reset = ResetForm.new
  end

  def create
    @password_reset = ResetForm.new(password_reset_params)
    user = @password_reset.user
    
    if @password_reset.valid?
      user.create_reset_digest

      UserMailer.with({ user: user }).password_reset.deliver_now

      redirect_to root_url
    else
      render(:new)
    end
  end

  def update
    if params[@user_type][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      @user.reset_digest = nil
      @user.save
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def edit
  end

  private

  def password_reset_params
    params.require(:reset_form).permit(:email)
  end

  def user_params
    params.require(@user_type).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(reset_digest: User.encrypt(params[:id]))
    @user_type = @user.type.downcase
  end

  def check_expiration
    if @user.reset_sent_at < 24.hours.ago
      redirect_to new_password_reset_url
    end
  end
end
