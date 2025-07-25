# ReadyCheck - Equipment Inspection App

A complete **Xcode Project** for iOS equipment inspection management with Flutter and Firebase integration.

## 🍎 Xcode Project Ready

This repository contains a **complete Xcode project** that can be opened directly in Xcode:

- **Location**: `ios/Runner.xcworkspace`
- **Project Type**: iOS app with Flutter engine integration
- **Languages**: Swift, Objective-C, Dart
- **Dependencies**: Managed via CocoaPods
- **Firebase**: Pre-configured for iOS

### Open in Xcode
```bash
# Option 1: Use the convenience script
./open_xcode.sh

# Option 2: Open directly
open ios/Runner.xcworkspace
```
> **Important**: Always use `.xcworkspace` file, not `.xcodeproj` when opening in Xcode.

## Features

- **User Profile Management**: Create and manage inspector profiles
- **Equipment Inspection**: Record detailed equipment inspections
- **Equipment Lookup**: Search and view historical inspection data
- **Setup & Configuration**: Manage locations, employers, and equipment types

## Quick Start

1. **Install Dependencies**: Run `./install.sh` to install all required dependencies
2. **Setup Firebase**: Follow the instructions in [SETUP.md](SETUP.md) to configure Firebase
3. **Open in Xcode**: Run `open ios/Runner.xcworkspace` (use .xcworkspace, not .xcodeproj)  
4. **Run App**: Execute `flutter run` or build/run from Xcode

## Requirements

- Flutter 3.0.0+
- iOS 11.0+
- Xcode 12.0+
- Firebase project (for data storage)

For detailed setup instructions, see [SETUP.md](SETUP.md).
