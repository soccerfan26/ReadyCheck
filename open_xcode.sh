#!/bin/bash

# ReadyCheck - Open in Xcode Script
# This script opens the ReadyCheck project in Xcode

echo "🍎 Opening ReadyCheck in Xcode..."

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the ReadyCheck project root directory"
    exit 1
fi

# Check if CocoaPods dependencies are installed
if [ ! -d "ios/Pods" ]; then
    echo "⚠️  CocoaPods dependencies not found."
    echo "   Run './setup_cocoapods.sh' to set up CocoaPods automatically, or:"
    echo "   1. cd ios && pod install"
    echo ""
    read -p "Do you want to continue opening Xcode anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cancelled. Please set up CocoaPods first."
        exit 1
    fi
fi

# Check if Xcode workspace exists
if [ ! -f "ios/Runner.xcworkspace/contents.xcworkspacedata" ]; then
    echo "⚠️  Warning: Xcode workspace not found. The project will still open but you may need to run 'pod install' first."
fi

# Check if Xcode is available
if ! command -v open &> /dev/null; then
    echo "❌ Error: Unable to open files on this system"
    exit 1
fi

# Open the workspace in Xcode
if [ -f "ios/Runner.xcworkspace/contents.xcworkspacedata" ]; then
    echo "✅ Opening Runner.xcworkspace in Xcode..."
    open ios/Runner.xcworkspace
else
    echo "⚠️  Opening Runner.xcodeproj in Xcode (workspace not available)..."
    open ios/Runner.xcodeproj
fi

echo "🚀 ReadyCheck should now be open in Xcode!"
echo ""
echo "📋 Next steps:"
echo "1. Select your target device or simulator"
echo "2. Press ⌘+R to build and run"
echo "3. Make sure GoogleService-Info.plist is configured for Firebase"