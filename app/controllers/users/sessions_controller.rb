class Users::SessionsController < Devise::SessionsController
  def create
    # 1. Look up the user by email before Warden touches the lifecycle
    self.resource = User.find_by(email: params[:user][:email])

    # 2. Verify the password matches safely
    if resource && resource.valid_password?(params[:user][:password])
      # 3. Check if they have 2FA turned on
      if resource.otp_required_for_login?
        # Store their ID in the clean session
        session[:otp_user_id] = resource.id
        
        # Redirect directly to the OTP verification screen
        redirect_to user_otp_verification_path, status: :see_other and return
      end
    end

    # 4. If they don't have 2FA enabled, or if the password/email is wrong,
    # let standard Devise handle the authentication and errors perfectly.
    super
  end
end
