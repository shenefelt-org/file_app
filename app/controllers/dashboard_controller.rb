class DashboardController < ApplicationController
  # Force user authentication before accessing this dashboard page
  before_action :authenticate_user!

  def index
    @uploaded_files = UploadedFile.includes(:user).all
    @new_upload = UploadedFile.new
  end

  def upload
    if params[:uploaded_file] && params[:uploaded_file][:file]
      uploaded_io = params[:uploaded_file][:file]
      
      # Build the record tied directly to the current signed-in user
      @upload = current_user.uploaded_files.build(
        original_name: uploaded_io.original_filename,
        saved_name: SecureRandom.uuid + File.extname(uploaded_io.original_filename)
      )
      
      # Attach the file via Active Storage
      @upload.file.attach(uploaded_io)

      if @upload.save
        flash[:notice] = "File securely uploaded!"
      else
        flash[:alert] = "Could not save file record."
      end
    else
      flash[:alert] = "Please pick a file first."
    end
    
    redirect_to root_path
  end
end
