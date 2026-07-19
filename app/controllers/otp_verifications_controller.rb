class OtpVerificationsController < ApplicationController
  # This endpoint must be public because the user isn't technically fully signed in yet
  skip_before_action :authenticate_user!, raise: false

  def new
    # Kick them out if they landed here without a valid login tracking ID
    redirect_to new_user_session_path unless session[:otp_user_id]
  end

  def create
    user = User.find_by(id: session[:otp_user_id])
    
    if user && user.validate_and_consume_otp!(params[:otp_attempt])
      # Clear the temporary login state container
      session.delete(:otp_user_id)
      
      # Tell Devise to fully sign the user into the environment
      sign_in(:user, user)
      redirect_to root_path, notice: "Signed in successfully with 2FA protection!"
    else
      flash.now[:alert] = "Invalid 2FA token check failed. Please try again."
      render :new, status: :unprocessable_entity
    end
  end
end
