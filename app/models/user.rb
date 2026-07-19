class User < ApplicationRecord
  # Combine Devise modules and pass the encryption key from your credentials
  devise :two_factor_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         otp_secret_encryption_key: Rails.application.credentials.active_record_encryption[:primary_key]

  has_many :uploaded_files, dependent: :destroy
end
