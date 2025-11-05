# 📱 Installation Guide

## 🚀 Quick Start (APK Installation)

### Step 1: Download APK
Click the download button below or visit the [releases page](https://github.com/SujithClasher/SentinelGuard/releases) to download the latest APK file.

[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android)](https://github.com/SujithClasher/SentinelGuard/releases/download/v1.0.0/sentinel-guard-v1.0.0.apk)

### Step 2: Enable Unknown Sources
Before installing, you need to allow installation from unknown sources:

1. **Settings** → **Apps** → **Special access** → **Install unknown apps**
2. Select your browser app and enable "Allow from this source"
3. Or go to **Settings** → **Security** → Enable "Unknown sources"

### Step 3: Install APK
1. Open your file manager and navigate to the Downloads folder
2. Tap on the `sentinel-guard-v1.0.0.apk` file
3. Follow the installation prompts
4. Tap **Install** when prompted

### Step 4: Launch and Setup
1. Open the Sentinel Guard app from your app drawer
2. Complete the initial setup wizard
3. Grant necessary permissions for full functionality:
   - **Usage Access**: For monitoring app usage
   - **Overlay Permission**: For displaying screen time alerts
   - **Device Admin**: For advanced parental controls (optional)

## 🛠️ Developer Setup (Source Code)

### Prerequisites
- **Flutter SDK**: 3.2.0 or higher ([Installation Guide](https://flutter.dev/docs/get-started/install))
- **Android Studio**: Latest version ([Download](https://developer.android.com/studio))
- **Git**: For cloning the repository

### Step 1: Clone Repository
```bash
git clone https://github.com/SujithClasher/SentinelGuard.git
cd SentinelGuard
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Run the App
Connect an Android device or start an emulator, then run:

```bash
flutter run
```

### Step 4: Build Release APK (Optional)
For creating a release build:

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

## 🔧 Required Permissions

For full functionality, the app requires these permissions:

### Essential Permissions
- **Usage Stats**: Monitor app usage and screen time
- **Overlay**: Display screen time alerts and PIN dialogs
- **Internet**: For cloud features (when available)

### Optional Permissions
- **Device Admin**: Enhanced parental controls (recommended)
- **Accessibility**: Advanced monitoring features
- **Storage**: Export reports and data

## 📋 Troubleshooting

### Installation Issues

**Problem**: "App not installed" error
**Solution**:
1. Check if you have enough storage space
2. Ensure you're using a compatible Android version (8.0+)
3. Try downloading the APK again

**Problem**: "Blocked by Play Protect"
**Solution**:
1. Tap **Install anyway** (unsafe)
2. Go to **Play Protect settings** and disable scanning for this app
3. Or install from a trusted source

**Problem**: App crashes on launch
**Solution**:
1. Clear app data: **Settings** → **Apps** → **Sentinel Guard** → **Storage** → **Clear data**
2. Restart your device
3. Reinstall the app

### Permission Issues

**Problem**: Usage stats permission not granted
**Solution**:
1. Go to **Settings** → **Apps** → **Sentinel Guard** → **Permissions**
2. Enable **Usage Access**
3. Or go to **Settings** → **Apps** → **Special access** → **Usage access**

**Problem**: Overlay permission not working
**Solution**:
1. Go to **Settings** → **Apps** → **Sentinel Guard** → **Display over other apps**
2. Enable the permission

## 🔍 Testing the Installation

1. **Launch the app** and complete the setup
2. **Check permissions** are properly granted
3. **Test Kids Mode**:
   - Go to Dashboard → Tap "Kids Mode"
   - See the colorful launcher interface
   - Try exiting with PIN: `123456`
4. **Test App Management**:
   - Go to "App Control" section
   - Search for apps and set time limits
5. **Test Web Filtering**:
   - Go to "Web Filtering"
   - Toggle content categories

## 📞 Need Help?

- Check the [FAQ](FAQ.md) for common questions
- Report issues on [GitHub Issues](https://github.com/SujithClasher/SentinelGuard/issues)
- Review the [troubleshooting section](#-troubleshooting) above

## 📝 Requirements Summary

| Component | Minimum Requirement | Recommended |
|-----------|-------------------|-------------|
| **Android Version** | 8.0 (API 26) | 10.0+ (API 29) |
| **RAM** | 2GB | 4GB+ |
| **Storage** | 50MB | 100MB+ |
| **Screen** | 720p | 1080p+ |

---

**Ready to protect your family's digital wellbeing?** 🚀

[← Back to Main README](README.md)
