#!/bin/bash

# ReadyCheck - Dependency Installation Script
# This script installs all required dependencies for the ReadyCheck Flutter iOS app

set -e  # Exit on any error

echo "🚀 ReadyCheck Dependency Installation"
echo "===================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${BLUE}🔄 $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "Please run this script from the ReadyCheck project root directory"
    exit 1
fi

print_success "Project root directory confirmed"
echo ""

# Step 1: Check Prerequisites
echo "📋 Step 1: Checking Prerequisites"
echo "--------------------------------"

# Check for Flutter
print_step "Checking for Flutter SDK..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    print_success "Flutter found: $FLUTTER_VERSION"
else
    print_error "Flutter SDK not found!"
    print_info "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter doctor
print_step "Running Flutter doctor..."
if flutter doctor > /dev/null 2>&1; then
    print_success "Flutter environment is ready"
else
    print_warning "Flutter doctor found some issues. Continuing anyway..."
    print_info "Run 'flutter doctor' after installation to see detailed issues"
fi

# Check for CocoaPods
print_step "Checking for CocoaPods..."
if command -v pod &> /dev/null; then
    POD_VERSION=$(pod --version)
    print_success "CocoaPods found: $POD_VERSION"
else
    print_error "CocoaPods not found!"
    print_info "Installing CocoaPods..."
    if command -v gem &> /dev/null; then
        sudo gem install cocoapods
        print_success "CocoaPods installed successfully"
    else
        print_error "Ruby gems not found. Please install CocoaPods manually:"
        print_info "Visit https://cocoapods.org/ for installation instructions"
        exit 1
    fi
fi

# Check for Xcode (optional, but recommended)
print_step "Checking for Xcode..."
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    print_success "Xcode found: $XCODE_VERSION"
else
    print_warning "Xcode not found or not in PATH"
    print_info "Xcode is required for iOS development. Install from App Store if needed."
fi

echo ""

# Step 2: Install Flutter Dependencies
echo "📦 Step 2: Installing Flutter Dependencies"
echo "----------------------------------------"

print_step "Running 'flutter pub get'..."
if flutter pub get; then
    print_success "Flutter dependencies installed successfully"
else
    print_error "Failed to install Flutter dependencies"
    exit 1
fi

echo ""

# Step 3: Install iOS Dependencies
echo "🍎 Step 3: Installing iOS Dependencies"
echo "------------------------------------"

if [ -d "ios" ] && [ -f "ios/Podfile" ]; then
    print_step "Installing CocoaPods dependencies..."
    cd ios
    
    # Clean previous installations if they exist
    if [ -d "Pods" ]; then
        print_info "Cleaning previous CocoaPods installation..."
        rm -rf Pods
        rm -rf Podfile.lock
    fi
    
    # Install pods
    if pod install; then
        print_success "iOS dependencies installed successfully"
    else
        print_error "Failed to install iOS dependencies"
        cd ..
        exit 1
    fi
    
    cd ..
else
    print_warning "iOS directory or Podfile not found. Skipping iOS dependencies."
fi

echo ""

# Step 4: Verify Installation
echo "🔍 Step 4: Verifying Installation"
echo "-------------------------------"

print_step "Checking Flutter dependencies..."
if flutter pub deps > /dev/null 2>&1; then
    print_success "Flutter dependencies verified"
else
    print_warning "Issue with Flutter dependencies verification"
fi

print_step "Checking iOS workspace..."
if [ -f "ios/Runner.xcworkspace/contents.xcworkspacedata" ]; then
    print_success "iOS workspace generated successfully"
else
    print_warning "iOS workspace not found. CocoaPods installation may have failed."
fi

echo ""

# Step 5: Final Instructions
echo "🎉 Installation Complete!"
echo "========================"
echo ""
print_success "All dependencies have been installed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Firebase Setup (Required):"
print_info "   • Create a Firebase project at https://console.firebase.google.com/"
print_info "   • Add an iOS app with bundle ID: com.readycheck.app" 
print_info "   • Replace ios/Runner/GoogleService-Info.plist with your Firebase config"
echo ""
echo "2. Run the app:"
print_info "   • Option A: flutter run"
print_info "   • Option B: open ios/Runner.xcworkspace (then build/run in Xcode)"
echo ""
echo "3. Verify setup:"
print_info "   • Run ./verify_ios_setup.sh to check all files are present"
echo ""
print_warning "⚠️  Important: Always use Runner.xcworkspace (not Runner.xcodeproj) in Xcode!"
echo ""
print_success "Happy coding! 🚀"