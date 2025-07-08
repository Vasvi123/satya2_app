# Cloudinary Document Upload Setup Guide

## Step 1: Set Up Cloudinary Account

1. Go to [cloudinary.com](https://cloudinary.com)
2. Sign up for a free account
3. Once logged in, go to your Dashboard
4. Note these credentials:
   - **Cloud Name** (found in the dashboard)
   - **API Key** (not needed for direct upload)
   - **Upload Preset** (we'll create this next)

## Step 2: Create an Upload Preset

1. Go to **Settings** → **Upload** → **Upload Presets**
2. Click **Add Upload Preset**
3. Set these options:
   - **Mode**: `Unsigned` ✅ (this allows direct upload from Flutter without authentication)
   - **Folder**: `loan_documents` (recommended for better organization)
   - **Signing Mode**: `Unsigned`
4. Click **Save**
5. Copy the **Upload Preset Name** that was generated

## File Organization Structure

The app automatically organizes uploaded files in Cloudinary with this structure:
```
loan_documents/
├── user_email_1/
│   ├── Home_Loan/
│   │   ├── Identity_Proof_timestamp.pdf
│   │   ├── Bank_Statement_timestamp.pdf
│   │   └── ...
│   ├── Personal_Loan/
│   │   └── ...
│   └── ...
├── user_email_2/
│   └── ...
```

**File naming convention:**
- `{user_email}_{loan_type}_{document_type}_{timestamp}.{extension}`
- Example: `john_doe_gmail_com_Home_Loan_Identity_Proof_1703123456789.pdf`

## Step 3: Update Configuration

1. Open `lib/config/cloudinary_config.dart`
2. Replace the placeholder values with your actual credentials:

```dart
class CloudinaryConfig {
  static const String cloudName = 'YOUR_ACTUAL_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_ACTUAL_UPLOAD_PRESET';
}
```

## Step 4: Test the Upload

1. Run the app: `flutter run`
2. Navigate to a loan type (e.g., Home Loan)
3. Click "Upload Documents"
4. Try uploading a document
5. Check your Cloudinary dashboard to see the uploaded file

## Step 5: Firestore Setup (Optional)

The app automatically saves document metadata to Firestore. Make sure your Firebase project has Firestore enabled and the security rules allow write access for authenticated users.

## Security Notes

✅ **Safe to use**: Unsigned upload presets are safe for client-side uploads
✅ **No API Secret exposure**: We don't use the API secret in the client
✅ **Public files**: Uploaded files are public by default (suitable for document sharing)

## Troubleshooting

### Upload fails with "Upload preset not found"
- Double-check your upload preset name in `cloudinary_config.dart`
- Make sure the preset is set to "Unsigned" mode

### "Cloud name not found" error
- Verify your cloud name in the Cloudinary dashboard
- Check for typos in `cloudinary_config.dart`

### File not appearing in Cloudinary
- Check the upload preset folder setting
- Verify the file size (free tier has limits)
- Check the console for error messages

## File Types Supported

The app supports these file types for upload:
- PDF files (.pdf)
- Images (.jpg, .jpeg, .png)
- Documents (.doc, .docx)

## Features Implemented

✅ **Organized file storage**: Files are stored with user email, loan type, and document type
✅ **Comprehensive metadata**: File size, upload date, original filename, and more
✅ **Document management**: View all uploaded documents with filtering options
✅ **User-friendly naming**: Sanitized file names for better organization
✅ **Firestore integration**: Complete document metadata stored in database
✅ **Document viewer**: View uploaded documents in external browser
✅ **Progress tracking**: Real-time upload status and error handling

## Next Steps

1. **Add file validation**: Implement file size and type validation
2. **Add progress indicators**: Show upload progress to users
3. **Add document deletion**: Allow users to remove uploaded documents
4. **Add document preview**: Show thumbnails for uploaded images
5. **Add admin panel**: Create an admin interface to review uploaded documents
6. **Add document status**: Track document approval/rejection status
7. **Add notifications**: Notify users when documents are reviewed 