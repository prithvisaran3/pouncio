# Pouncio

Pouncio is a premium Flutter application for early career software engineers, new grads, and mobile app developers to track and find matching jobs.

## Security & Setup Instructions

To prevent unauthorized distribution and replication, the repository has been secured. Follow these configuration steps to build and run the application locally.

### 1. Configure the Local Environment

Copy the `.env.example` file to `.env`:
```bash
cp .env.example .env
```

Populate the `.env` file with your variables:
- **`APP_SECRET_KEY`**: Set this to `pouncio_secure_key_prithvi_2026` to authorize the runtime application build. If this token is missing or incorrect, the app will show an "Unauthorized Build" security lockout shield screen.
- **`SCRAPER_URL`**: Your Cloud Function manual scraper endpoint URL.
- **Firebase Parameters**: Your Firebase API keys, project IDs, sender IDs, and bundle ID details.

### 2. Add Native Firebase Configurations

Native Firebase configuration files are omitted from Git tracking for security. You must supply your own configurations:
1. **Android**: Download `google-services.json` from the Firebase Console and place it at:
   `android/app/google-services.json` (see `google-services.json.example` for format).
2. **iOS**: Download `GoogleService-Info.plist` from the Firebase Console and place it at:
   `ios/Runner/GoogleService-Info.plist` (see `GoogleService-Info.plist.example` for format).

### 3. Run the Application

Install dependencies and run the build:
```bash
flutter pub get
flutter run
```
