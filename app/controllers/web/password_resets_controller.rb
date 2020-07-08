class Web::PasswordResetsController < Web::ApplicationController
  before_action :get_user, only: [:edit, :update]

  def new
    @password_reset = ResetForm.new
  end

  def create
    @password_reset = ResetForm.new(password_reset_params)
    user = @password_reset.user

    if user.present? && @password_reset.valid?
      user.create_reset_digest

      SendPasswordResetNotificationJob.perform_async(user.id, user.reset_token)

      redirect_to(root_url)
    else
      render(:new)
    end
  end

  def update
    if @user.token_expire?
      redirect_to(root_url)
      return
    end

    if @user.update(user_params)
      @user.reset_digest = nil
      @user.save
      redirect_to(root_url)
    else
      render(:edit)
    end
  end

  def edit; end

  private

  def password_reset_params
    params.require(:reset_form).permit(:email)
  end

  def user_params
    params.require(@user_type).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(reset_digest: User.encrypt(params[:id]))

    if @user.present?
      @user_type = @user.type.downcase
    else
      redirect_to(root_url)
    end
  end
end
