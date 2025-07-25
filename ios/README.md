# iOS Setup for ReadyCheck

This directory contains the iOS project configuration for the ReadyCheck Flutter app.

## Requirements
- Xcode 12.0 or later
- iOS 11.0 or later
- Flutter SDK
- CocoaPods

## Getting Started

### 1. Install Dependencies
```bash
cd ios
pod install
```

### 2. Firebase Configuration
The project includes a placeholder `GoogleService-Info.plist` file for development. To enable Firebase functionality:

1. Create a Firebase project at https://console.firebase.google.com/
2. Add an iOS app with bundle ID: `com.readycheck.app`
3. Download your `GoogleService-Info.plist` file
4. Replace `ios/Runner/GoogleService-Info.plist` with your downloaded file
5. Ensure the file is added to your Xcode project

### 3. Open in Xcode
```bash
open Runner.xcworkspace
```

**Important**: Always open the `.xcworkspace` file, not the `.xcodeproj` file, when using CocoaPods.

### 4. Build and Run
- Select your target device or simulator
- Press Cmd+R to build and run the app

## Project Structure
```
ios/
├── Flutter/                    # Flutter configuration files
│   ├── AppFrameworkInfo.plist
│   ├── Generated.xcconfig      # Generated Flutter settings
│   ├── Debug.xcconfig
│   └── Release.xcconfig
├── Runner/                     # Main iOS app target
│   ├── AppDelegate.swift       # App delegate with Firebase setup
│   ├── Info.plist             # App configuration
│   ├── Assets.xcassets        # App icons and images
│   ├── Base.lproj/            # Storyboards
│   ├── GoogleService-Info.plist  # Firebase configuration
│   ├── GeneratedPluginRegistrant.h
│   ├── GeneratedPluginRegistrant.m
│   └── Runner-Bridging-Header.h
├── Runner.xcodeproj/          # Xcode project file
├── Podfile                    # CocoaPods dependencies
└── README.md                  # This file
```

## Troubleshooting

### Build Issues
1. Clean build folder: Product → Clean Build Folder
2. Update pods: `cd ios && pod update`
3. Regenerate Flutter files: `flutter clean && flutter pub get`

### Firebase Issues
- Ensure `GoogleService-Info.plist` is properly added to the Xcode project
- Verify the bundle ID matches your Firebase app configuration
- Check Firebase console for any configuration issues

### CocoaPods Issues
- Update CocoaPods: `sudo gem install cocoapods`
- Clear pods cache: `pod cache clean --all`
- Reinstall pods: `rm -rf Pods && pod install`