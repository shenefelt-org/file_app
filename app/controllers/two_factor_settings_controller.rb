class TwoFactorSettingsController < ApplicationController
  before_action :authenticate_user!

  def new
    # 1. Generate an OTP secret for the user if they don't have one yet
    unless current_user.otp_secret
      current_user.otp_secret = User.generate_otp_secret
      current_user.save!
    end

    # 2. Build the provisioning URI string for the authenticator app
    issuer = "Files Ten Platform"
    uri = current_user.otp_provisioning_uri(current_user.email, issuer: issuer)

    # 3. Compile the URI string into a raw SVG QR code
    qrcode = RQRCode::QRCode.new(uri)
    @qrcode = qrcode.as_svg(
      color: "9d84b7",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
  end

  def create
    # Validate the 6-digit token against the user's secret key
    if current_user.validate_and_consume_otp!(params[:code])
      current_user.update!(otp_required_for_login: true)
      flash[:notice] = "Two-factor authentication successfully activated!"
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid verification code. Please try again."
      # Re-render the QR code if validation fails
      new
      render :new, status: :unprocessable_entity
    end
  end
end
