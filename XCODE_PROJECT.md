# ReadyCheck - Xcode Project Guide

## 🍎 Opening the Project in Xcode

This repository is now a complete Xcode project that can be opened directly in Xcode.

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/soccerfan26/ReadyCheck.git
   cd ReadyCheck
   ```

2. **Setup CocoaPods** (Required):
   ```bash
   # Option A: Automated setup (recommended)
   ./setup_cocoapods.sh
   
   # Option B: Manual setup
   flutter pub get
   cd ios && pod install
   ```

3. **Open in Xcode**:
   ```bash
   # Option A: Use convenience script
   ./open_xcode.sh
   
   # Option B: Open directly
   open ios/Runner.xcworkspace
   ```

4. **Build and Run**:
   - Select your target device or simulator in Xcode
   - Press ⌘+R to build and run the app

## 📁 Project Structure

```
ReadyCheck/
├── ios/                           # iOS Project Files
│   ├── Runner.xcworkspace/        # 🔹 Xcode Workspace (open this)
│   ├── Runner.xcodeproj/          # Xcode Project
│   ├── Runner/                    # iOS App Source
│   │   ├── AppDelegate.swift      # App Delegate with Firebase
│   │   ├── Info.plist            # App Configuration
│   │   ├── Assets.xcassets       # App Icons & Assets
│   │   ├── Base.lproj/           # Storyboards
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   └── GoogleService-Info.plist  # Firebase Config
│   ├── Flutter/                   # Flutter Configuration
│   └── Podfile                   # CocoaPods Dependencies
├── lib/                          # Flutter/Dart Source Code
├── open_xcode.sh                 # 🔹 Convenience Script
└── README.md
```

## 🔧 Development Workflow

### For Native iOS Development:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Edit Swift/Objective-C files in the `Runner` target
3. Modify iOS-specific settings in `Info.plist`
4. Add native iOS dependencies via `Podfile`

### For Flutter Development:
1. Edit Dart files in the `lib/` directory
2. Use `flutter run` for hot reload development
3. Use Xcode for debugging native iOS code

### For Mixed Development:
- Use Xcode for iOS-specific features and debugging
- Use Flutter tools for cross-platform business logic
- Both approaches work seamlessly together

## ⚙️ Configuration

### Firebase Setup (Required):
1. Create a Firebase project at https://console.firebase.google.com/
2. Add an iOS app with bundle ID: `com.readycheck.app`
3. Download `GoogleService-Info.plist`
4. Replace `ios/Runner/GoogleService-Info.plist` with your file
5. Ensure the file is added to your Xcode project

### Dependencies:
- **Prerequisites**: Flutter SDK and CocoaPods must be installed
- **Setup**: Run `./setup_cocoapods.sh` for automated setup
- CocoaPods dependencies are managed via `Podfile`
- Run `pod install` in the `ios/` directory when adding new native dependencies
- Flutter dependencies are managed via `pubspec.yaml`

## 🎯 Key Features

- **Equipment Inspection Management**: Native iOS UI for equipment inspections
- **Firebase Integration**: Cloud storage and authentication
- **User Profile Management**: iOS-native profile management
- **Historical Lookup**: Search and view inspection history
- **Configuration Management**: Setup locations, employers, and equipment types

## 🔍 Troubleshooting

### Common Issues:
1. **CocoaPods Not Installed**: Run `sudo gem install cocoapods`
2. **Flutter Not Found**: Install Flutter SDK from https://docs.flutter.dev/get-started/install
3. **Pod Install Fails**: Ensure Flutter is installed and run `flutter pub get` first
4. **Build Errors**: Clean build folder (Product → Clean Build Folder)
5. **Dependencies**: Use `./setup_cocoapods.sh` for automated setup
6. **Firebase**: Ensure `GoogleService-Info.plist` is properly configured

### Getting Help:
- Check `verify_ios_setup.sh` to ensure all files are present
- Review `SETUP.md` for detailed setup instructions
- Consult Flutter and iOS documentation for platform-specific issues

## 📱 App Information

- **Name**: ReadyCheck
- **Type**: Equipment Inspection App
- **Platform**: iOS (11.0+)
- **Framework**: Flutter with native iOS components
- **Languages**: Swift, Objective-C, Dart
- **Architecture**: MVVM with Provider state management

---

**Ready to develop!** 🚀

Your Xcode project is fully configured and ready for iOS development.