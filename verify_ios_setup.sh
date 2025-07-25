#!/bin/bash

# ReadyCheck iOS Setup Verification Script
# This script verifies that all necessary files are present for Xcode compatibility

echo "🔍 ReadyCheck iOS Setup Verification"
echo "===================================="

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the ReadyCheck project root directory"
    exit 1
fi

echo "✅ Project root directory confirmed"

# Check critical iOS files
ios_files=(
    "ios/Runner.xcodeproj/project.pbxproj"
    "ios/Flutter/Generated.xcconfig"
    "ios/Flutter/AppFrameworkInfo.plist"
    "ios/Flutter/Debug.xcconfig"
    "ios/Flutter/Release.xcconfig"
    "ios/Podfile"
    "ios/Runner/AppDelegate.swift"
    "ios/Runner/Info.plist"
    "ios/Runner/GeneratedPluginRegistrant.h"
    "ios/Runner/GeneratedPluginRegistrant.m"
    "ios/Runner/GoogleService-Info.plist"
)

echo "📁 Checking essential iOS files:"
all_present=true

for file in "${ios_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (MISSING)"
        all_present=false
    fi
done

# Check xcconfig references
echo ""
echo "🔗 Checking xcconfig references:"
if grep -q "Generated.xcconfig" ios/Flutter/Debug.xcconfig 2>/dev/null; then
    echo "✅ Debug.xcconfig references Generated.xcconfig"
else
    echo "❌ Debug.xcconfig missing Generated.xcconfig reference"
    all_present=false
fi

if grep -q "Generated.xcconfig" ios/Flutter/Release.xcconfig 2>/dev/null; then
    echo "✅ Release.xcconfig references Generated.xcconfig"
else
    echo "❌ Release.xcconfig missing Generated.xcconfig reference"
    all_present=false
fi

# Summary
echo ""
echo "📋 Summary:"
if [ "$all_present" = true ]; then
    echo "✅ All essential files are present!"
    echo "🚀 Your project should be compatible with Xcode."
    echo ""
    echo "Next steps:"
    echo "1. cd ios && pod install"
    echo "2. open ios/Runner.xcworkspace"
    echo "3. Replace ios/Runner/GoogleService-Info.plist with your Firebase config"
else
    echo "❌ Some files are missing. Please check the setup instructions."
fi