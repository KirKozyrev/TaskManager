class Web::PasswordResetsController < Web::ApplicationController
  def new
    @password_reset = ResetForm.new
  end

  def edit
  end
end
