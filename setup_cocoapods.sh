#!/bin/bash

# CocoaPods Setup for ReadyCheck iOS Development
# This script helps set up CocoaPods for the ReadyCheck iOS project

set -e

echo "🚀 Setting up CocoaPods for ReadyCheck iOS development..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This setup script is designed for macOS."
    echo "For other platforms, you'll need to set up Flutter and CocoaPods manually."
    echo ""
    echo "Linux users:"
    echo "1. Install Flutter SDK: https://docs.flutter.dev/get-started/install/linux"
    echo "2. Install CocoaPods: sudo gem install cocoapods"
    echo "3. Run: cd ios && pod install"
    exit 1
fi

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "📦 Installing CocoaPods..."
    sudo gem install cocoapods
else
    echo "✅ CocoaPods is already installed ($(pod --version))"
fi

# Check if Flutter is installed, but don't fail if it's not
if ! command -v flutter &> /dev/null; then
    echo "⚠️  Flutter is not installed or not in PATH."
    echo "The project has been configured to work without Flutter for basic iOS development."
    echo "For full Flutter functionality, install Flutter: https://docs.flutter.dev/get-started/install/macos"
    echo ""
    echo "Continuing with CocoaPods setup..."
else
    echo "✅ Flutter is installed ($(flutter --version | head -n 1))"
    echo "📱 Running Flutter pub get..."
    flutter pub get
fi

# Navigate to iOS directory and install pods
echo "🔧 Installing CocoaPods dependencies..."
cd ios
pod install

echo "✅ Setup complete!"
echo ""
echo "You can now open the project in Xcode:"
echo "  open ios/Runner.xcworkspace"
echo ""
echo "Or use the convenience script:"
echo "  ./open_xcode.sh"