# ReadyCheck - Equipment Inspection App

ReadyCheck is a Flutter iOS app that allows users to manage equipment inspections with user profiles, location management, and inspection tracking capabilities.

## Features

### User Profile Management
- Editable user profile with First Name, Last Name, Location, Home Local #, and Work ID/Number
- Profile data is saved locally and synced with Firebase

### Equipment Inspection
- Create equipment inspections with the following details:
  - Location (selectable from predefined list)
  - Location Type (selectable from predefined list)
  - Employer (selectable from predefined list)
  - Equipment Type (selectable from predefined list)
  - Equipment Number (text input)
  - Pre-Shift Inspection notes
- All inspection data is saved locally and synced with Firebase

### Equipment Lookup
- Search for previous inspections by:
  - Selecting an Employer from dropdown
  - Entering Equipment Type
  - Entering Equipment Number
- Results show historical inspection data

### Setup & Configuration
- Manage Locations: Add/remove/edit inspection locations
- Manage Location Types: Add/remove/edit location type categories
- Manage Employers: Add/remove/edit employer information
- Manage Equipment Types: Add/remove/edit equipment type categories

## Technical Implementation

### Architecture
- Framework: Flutter for iOS
- Data Storage:
  - Firebase Firestore for cloud sync
  - SharedPreferences for local user data
- Platform: iOS with Xcode project included

### Data Model
The app uses the following data models:
- UserProfile: User information
- Location: Inspection locations
- LocationType: Location categorization
- Employer: Employer information
- EquipmentType: Equipment categorization
- EquipmentInspection: Inspection records

## Firebase Integration Setup

The app includes Firebase integration scaffolding. To enable full Firebase functionality:

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add an iOS app to your Firebase project with bundle ID: `com.readycheck.app`

### 2. Configure Firebase
1. Download the `GoogleService-Info.plist` file from your Firebase project
2. Replace the example file `ios/Runner/GoogleService-Info.plist.example` with your actual `GoogleService-Info.plist`
3. Ensure the file is included in your Xcode project

### 3. Enable Firestore Database
1. In Firebase Console, go to Firestore Database
2. Create database in test mode (or production mode with security rules)
3. The app will automatically create the required collections when data is first saved

### 4. Firebase Security Rules (Optional)
For production use, consider adding Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access to all documents
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Installation & Setup

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Xcode (for iOS development)
- iOS Simulator or iOS device

### 1. Clone and Setup
```bash
git clone <repository-url>
cd ReadyCheck
flutter pub get
```

### 2. iOS Setup
```bash
cd ios
pod install  # Install iOS dependencies
cd ..
```

### 3. Firebase Configuration
- Follow the Firebase Integration Setup steps above
- Ensure GoogleService-Info.plist is properly configured

### 4. Run the App
```bash
flutter run
```

## Usage

1. **Setup Data First**: Use the "Setup" tab to add locations, location types, employers, and equipment types before performing inspections.

2. **Create User Profile**: Fill out your profile information in the "Profile" tab.

3. **Perform Inspections**: Use the "Inspection" tab to record equipment inspections.

4. **Lookup Previous Inspections**: Use the "Lookup" tab to search for historical inspection data.

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_profile.dart
│   ├── setup_models.dart
│   └── equipment_inspection.dart
├── screens/                  # UI screens
│   ├── main_navigation.dart
│   ├── profile_screen.dart
│   ├── inspection_screen.dart
│   ├── lookup_screen.dart
│   └── setup_screen.dart
└── services/                 # Business logic
    ├── user_service.dart
    ├── equipment_service.dart
    └── setup_service.dart
```

## Dependencies

- `flutter`: Flutter framework
- `cloud_firestore`: Firebase Firestore integration
- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase authentication (future use)
- `shared_preferences`: Local data storage
- `provider`: State management
- `intl`: Internationalization support

## Future Enhancements

- User authentication and multi-user support
- Photo attachments for inspections
- Offline capability improvements
- Export inspection reports
- Push notifications for inspection reminders
- Advanced search and filtering options