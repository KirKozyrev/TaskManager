class Web::PasswordResetsController < Web::ApplicationController
  def new
    @password_reset = ResetForm.new
  end

  def create
    user = User.find_by(password_reset_params)
    
    if user
      user.create_reset_digest

      UserMailer.with({ user: user }).password_reset.deliver_now

      redirect_to root_url
    end
  end

  def edit
  end

  private

  def password_reset_params
    params.require(:reset_form).permit(:email)
  end
end
