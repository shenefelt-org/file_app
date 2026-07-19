import sys
import os
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from google.oauth2 import service_account

def upload_to_rails_storage(file_path, folder_id, original_name):
    # Setup authentication
    SCOPES = ['https://www.googleapis.com/auth/drive']
    SERVICE_ACCOUNT_FILE = 'credentials.json' # Adjust path if necessary
    
    creds = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    service = build('drive', 'v3', credentials=creds)

    # Set metadata (using the original name passed from Rails)
    file_metadata = {
        'name': original_name,
        'parents': [folder_id]
    }
    
    # Upload the file
    media = MediaFileUpload(file_path, resumable=True)
    file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()

    # Print the resulting Google Drive File ID so Ruby can capture it
    print(file.get('id'))

if __name__ == '__main__':
    # Grab arguments passed from Rails
    # sys.argv[1] = local path, sys.argv[2] = folder ID, sys.argv[3] = original filename
    if len(sys.argv) < 4:
        print("Missing arguments", file=sys.stderr)
        sys.exit(1)
        
    upload_to_rails_storage(sys.argv[1], sys.argv[2], sys.argv[3])
