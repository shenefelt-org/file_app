class UploadedFile < ApplicationRecord
  belongs_to :user

  # connect model to active storage
  has_one_attached :file 
end
