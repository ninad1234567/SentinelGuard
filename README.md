# 🛡️ Sentinel Guard

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-brightgreen" alt="Platform: Android">
  <img src="https://img.shields.io/badge/API%20Level-21+-blue" alt="API Level">
  <img src="https://img.shields.io/badge/Flutter-3.2.0+-blue" alt="Flutter Version">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
  <img src="https://img.shields.io/badge/Status-Demo-orange" alt="Demo Status">
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen" alt="PRs Welcome">
</p>

<p align="center">
  <strong>🎬 Professional Parental Control Demo | Material Design 3 | Flutter</strong>
</p>

<p align="center">
  <a href="#-installation">📦 Install</a> •
  <a href="#-features">✨ Features</a> •
  <a href="#-demo">🎬 Demo</a> •
  <a href="#-usage">🚀 Usage</a> •
  <a href="#-contributing">🤝 Contributing</a> •
  <a href="#-license">📄 License</a>
</p>

## 📋 Table of Contents

- [🛡️ Introduction](#-introduction)
- [✨ Features](#-features)
- [📱 Installation](#-installation)
- [🎬 Demo](#-demo)
- [🚀 Usage](#-usage)
- [⚙️ Configuration](#️-configuration)
- [🛠️ Tech Stack](#️-tech-stack)
- [🤝 Contributing](#-contributing)
- [🗺️ Roadmap](#️-roadmap)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)

## 🛡️ Introduction

**Sentinel Guard** is a comprehensive **parental control demo application** built with Flutter, showcasing modern mobile app development practices and Material Design 3 implementation. This demo application demonstrates advanced UI/UX patterns for parental monitoring and child safety features.

### 🎯 What It Does

Sentinel Guard provides a complete demonstration of parental control interfaces including:
- **Real-time activity monitoring** with realistic mock data
- **App usage tracking** and management controls
- **Screen time management** with scheduling capabilities
- **Content filtering** and web safety features
- **Kids mode launcher** with PIN protection
- **Premium feature showcases** with upgrade flows

### 🚀 Key Features

- **🎨 Material Design 3** - Modern, accessible UI components
- **📱 Kids Mode** - Child-friendly launcher interface
- **⏰ Screen Time Management** - Usage tracking and limits
- **🔒 PIN Protection** - Secure access controls
- **📊 Analytics Dashboard** - Usage statistics and reports
- **🎯 App Controls** - Block/allow app permissions
- **🌐 Web Filtering** - Content category management
- **⭐ Premium Features** - Subscription model showcase

### 💡 Why It's Useful

This demo serves as an excellent **portfolio piece** and **learning resource** for:
- **Flutter developers** learning advanced state management and Material Design 3
- **UI/UX designers** exploring parental control interfaces and user experience patterns
- **Product managers** understanding feature requirements and implementation complexity
- **Students** studying mobile app architecture, state management, and modern Flutter patterns
- **Developers** showcasing comprehensive app development skills and best practices

---

## 📱 Installation

### 📦 APK Download & Demo

<div align="center">

## 🚀 **DOWNLOAD APK & WATCH DEMO**

**[📱 DOWNLOAD APK (142.9 MB)](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file)** | **[🎬 WATCH YOUTUBE DEMO](https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd)**

<div align="center">
  <a href="https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file" target="_blank">
    <img src="https://img.shields.io/badge/📱_DOWNLOAD_APK_(142.9_MB)-brightgreen?style=for-the-badge&logo=android" alt="Download APK">
  </a>
  <a href="https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd" target="_blank" style="margin-left: 10px;">
    <img src="https://img.shields.io/badge/🎬_WATCH_DEMO_VIDEO-red?style=for-the-badge&logo=youtube" alt="Watch Demo Video">
  </a>
</div>

**Quick Access:**
- **[🔗 MediaFire APK Download](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file)** - Direct APK download (142.9 MB)
- **[🎬 YouTube Demo Video](https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd)** - Watch app in action

</div>

#### 📥 **APK Download Options**

**Option 1: Direct Download (Recommended)**
- **[📱 MediaFire Download](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file)** - 142.9 MB APK file
- **Ready to install** - No building required

**Option 2: Build from Source**
1. **Clone & Setup** the repository (see [Development Setup](#-development-setup))
2. **Build the APK** using Flutter commands
3. **Install on device** for testing

**Why Build Option?** APK files are **build artifacts** that:
- **Change frequently** during development
- Should be **built fresh** for security and compatibility
- Allow you to **customize** the build process

**Quick Build Commands:**
```bash
# 1. Install dependencies
flutter pub get

# 2. Build debug APK (recommended for testing)
flutter build apk --debug

# 3. Find the APK file
# Location: build/app/outputs/flutter-apk/app-debug.apk
# Size: ~150 MB
```

**[🎯 Jump to Development Setup](#-development-setup)**

### 📋 System Requirements

- **Android Version:** 8.0 (API 26) or higher
- **Storage:** 200 MB free space
- **RAM:** 2 GB minimum
- **Architecture:** ARMv7, ARM64, x86, x86_64

### ⚡ Quick Start Guide

#### 🚀 For Users (Download & Install)
1. **[📱 Download APK from MediaFire](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file)** (142.9 MB)
2. **[🎬 Watch demo video](https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd)** to see features
3. **Install APK** on your Android device
4. **Launch and explore** all demo features

#### 🛠️ For Developers (Build & Customize)
```bash
# 1. Clone the repository
git clone https://github.com/SujithClasher/SentinelGuard.git
cd SentinelGuard

# 2. Install dependencies
flutter pub get

# 3. Build and run on connected device
flutter run

# 4. Or build APK for manual installation
flutter build apk --debug
# APK location: build/app/outputs/flutter-apk/app-debug.apk
# Transfer this APK to your Android device for installation

# 5. Build for release (optional - requires signing)
flutter build apk --release
```

#### 📱 Installation Steps (for Downloaded APK)
1. **Download APK** from [MediaFire](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file)
2. **Enable Unknown Sources:** Settings → Apps → Special access → Install unknown apps
3. **Install APK:** Open the downloaded APK file on your device
4. **Launch:** Find "Sentinel Guard" in your app drawer
5. **Grant permissions** when prompted for full functionality

### 🛠️ Development Setup

#### Prerequisites

- **Flutter SDK:** 3.2.0 or higher
- **Android Studio:** Latest version with Android SDK
- **Git:** For version control

#### Installation Steps

```bash
# 1. Clone the repository
git clone https://github.com/SujithClasher/SentinelGuard.git
cd SentinelGuard

# 2. Install dependencies
flutter pub get

# 3. Run the app on connected device/emulator
flutter run

# 4. Build APK for manual installation (optional)
flutter build apk --debug
# APK will be created at: build/app/outputs/flutter-apk/app-debug.apk
# Transfer this APK to your Android device for installation

# 5. Build for release (optional - requires signing)
flutter build apk --release
```

---

## 🎬 Demo

### 📺 Demo Video & APK Download

<div align="center">

**[🎬 ▶️ WATCH DEMO ON YOUTUBE](https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd)** | **[📱 DOWNLOAD APK](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file)**

<div align="center">
  <a href="https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd" target="_blank">
    <img src="https://img.youtube.com/vi/p64nOcLEdRs/maxresdefault.jpg" alt="YouTube Demo Video" width="640" height="360" style="border: 2px solid #FF0000; border-radius: 8px;">
  </a>
</div>

*🎬 Complete app demonstration with live interface walkthrough!*

**💡 Want to test the app yourself?** [Download APK](#-installation) or [Build it from source](#-development-setup)!

</div>

### 🎮 Demo Credentials

| Credential | Value | Description |
|------------|-------|-------------|
| **Demo PIN** | `123456` | PIN for exiting kids mode |
| **Demo Device** | "Alex's Phone" | Samsung Galaxy S24 Ultra (simulated) |
| **Demo Data** | 7 days | Realistic usage patterns (mock data) |
| **Features** | 45+ apps | Real Android app simulation |

**🔧 To test these features:**
1. **Download APK** from [MediaFire](https://www.mediafire.com/file/zxy7v025exiirr6/app-debug.apk/file) or [Build the app](#-development-setup)
2. **Run on device/emulator** with `flutter run`
3. **[🎬 Watch demo video](https://youtube.com/shorts/p64nOcLEdRs?si=aGx_OaJAgbVoNDTd)** to see all features in action
4. **Explore all demo features** with realistic mock data

### 📸 Screenshots

<div align="center">
  <img src="https://raw.githubusercontent.com/SujithClasher/SentinelGuard/master/screenshots/dashboard.png" alt="Dashboard" width="300" style="margin: 10px;">
  <img src="https://raw.githubusercontent.com/SujithClasher/SentinelGuard/master/screenshots/kids_mode.png" alt="Kids Mode" width="300" style="margin: 10px;">
  <img src="https://raw.githubusercontent.com/SujithClasher/SentinelGuard/master/screenshots/app_control.png" alt="App Control" width="300" style="margin: 10px;">
</div>

<div align="center">
  <img src="https://raw.githubusercontent.com/SujithClasher/SentinelGuard/master/screenshots/web_filtering.png" alt="Web Filtering" width="300" style="margin: 10px;">
  <img src="https://raw.githubusercontent.com/SujithClasher/SentinelGuard/master/screenshots/nsfw_scanner.png" alt="NSFW Scanner" width="300" style="margin: 10px;">
  <img src="https://raw.githubusercontent.com/SujithClasher/SentinelGuard/master/screenshots/premium_features.png" alt="Premium Features" width="300" style="margin: 10px;">
</div>

**[📂 View All Screenshots](https://github.com/SujithClasher/SentinelGuard/tree/master/screenshots)**

---

## 🚀 Usage

### 🎯 Quick Start

```bash
# 1. Install and launch the app
# 2. Complete the onboarding process
# 3. Explore the dashboard with demo data
# 4. Try kids mode with PIN: 123456
# 5. Test all features with realistic mock data
```

### 📱 App Navigation

#### Parent Dashboard
- **Overview Tab:** Screen time, app usage, activity feed
- **Apps Tab:** Manage app permissions and time limits
- **Screen Time:** Set daily limits and schedules
- **Web Filtering:** Configure content categories
- **Reports:** View usage analytics and history

#### Kids Mode
- **Launcher:** Child-friendly app grid interface
- **Timer Display:** Shows remaining screen time
- **PIN Exit:** Secure exit requiring parent PIN
- **Approved Apps:** Only allowed applications visible

### 🧪 Test Scenarios

1. **Dashboard Overview**
   ```bash
   # View: 5m screen time, 4 apps used, 8 websites visited
   ```

2. **Kids Mode Testing**
   ```bash
   # PIN: 123456 (for exiting kids mode)
   # See colorful launcher interface
   ```

3. **App Management**
   ```bash
   # 45+ real apps available
   # Set time limits and permissions
   ```

4. **Premium Features**
   ```bash
   # Explore subscription options
   # Test premium feature flows
   ```

---

## ⚙️ Configuration

### 🔧 Environment Setup

This demo application uses **realistic mock data** and requires no external configuration. All data is generated locally for demonstration purposes.

### 📋 Demo Data Configuration

The app includes pre-configured demo data:

```dart
// Device Information
final deviceInfo = DeviceInfo(
  name: "Alex's Phone",
  model: 'Samsung Galaxy S24 Ultra',
  androidVersion: 'Android 15',
  lastSync: DateTime.now().subtract(const Duration(minutes: 2)),
);

// Demo Usage Data
final todaySummary = {
  'screenTime': const Duration(minutes: 5),
  'appsUsed': 4,
  'websitesVisited': 8,
  'blockedAttempts': 2,
  'pendingRequests': 1,
};
```

### 🎨 Theme Configuration

The app supports both light and dark themes:

```dart
// Light Theme (Default)
ThemeMode.light

// Dark Theme
ThemeMode.dark
```

---

## 🛠️ Tech Stack

### 🎯 Core Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.2.0+ | Cross-platform mobile framework |
| **Dart** | 2.19+ | Programming language |
| **Material Design 3** | Latest | UI component system |
| **Provider** | 6.1.1 | State management |

### 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Navigation
  go_router: ^13.0.0

  # UI Components
  fl_chart: ^0.66.0
  shimmer: ^3.0.0
  animate_do: ^3.1.2
  google_fonts: ^6.1.0

  # Icons & Assets
  font_awesome_flutter: ^10.6.0

  # App Functionality
  android_intent_plus: ^4.0.3
  url_launcher: ^6.2.2
  webview_flutter: ^4.4.2
  external_app_launcher: ^4.0.3
  usage_stats: ^1.3.0
  local_auth: ^2.1.8

  # Database & Storage
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  shared_preferences: ^2.2.2

  # Utilities
  intl: ^0.19.0
```

### 🏗️ Architecture

- **MVVM Pattern** - Model-View-ViewModel architecture
- **Provider Pattern** - Reactive state management
- **Repository Pattern** - Data access abstraction
- **Service Layer** - Business logic separation
- **Widget Composition** - Reusable UI components

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help improve Sentinel Guard:

### 🚀 Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/your-username/SentinelGuard.git
   cd SentinelGuard
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes**
   ```bash
   # Add your improvements
   flutter pub get
   flutter run
   ```

4. **Test your changes**
   ```bash
   flutter test
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "Add amazing feature"
   git push origin feature/amazing-feature
   ```

6. **Open a Pull Request**

### 📝 Contribution Guidelines

- **Code Style:** Follow Dart/Flutter best practices
- **Testing:** Include tests for new features
- **Documentation:** Update README for significant changes
- **Issues:** Use GitHub Issues for bug reports and features
- **PRs:** Keep PRs focused and well-documented

### 🧪 Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### 🐛 Reporting Issues

- **Bug Reports:** Use [GitHub Issues](https://github.com/SujithClasher/SentinelGuard/issues)
- **Feature Requests:** Create an issue with `[Feature]` prefix
- **Questions:** Use [GitHub Discussions](https://github.com/SujithClasher/SentinelGuard/discussions)

---

## 🗺️ Roadmap

### 🎯 Upcoming Features

- [ ] **Real Device Integration** - Actual usage stats tracking
- [ ] **Backend API** - Cloud synchronization and data storage
- [ ] **iOS Support** - Cross-platform compatibility
- [ ] **Advanced Analytics** - ML-powered insights and predictions
- [ ] **Multi-language Support** - Internationalization
- [ ] **Cloud Backup** - Data synchronization across devices
- [ ] **Push Notifications** - Real-time alerts and updates
- [ ] **Family Sharing** - Multi-device family management

### 🔮 Future Enhancements

- **Machine Learning** - AI-powered content classification
- **Geofencing** - Location-based restrictions
- **Emergency Features** - SOS and emergency contacts
- **Parental Reports** - Comprehensive activity summaries
- **API Integration** - Third-party service connections

*Want to suggest a feature? [Open an issue](https://github.com/SujithClasher/SentinelGuard/issues)!*

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 SujithClasher

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

### 🎨 Design & UI
- **Material Design Team** - Material Design 3 components and guidelines
- **Google Fonts** - Typography resources
- **Flutter Team** - Beautiful widget library

### 🛠️ Development Tools
- **Flutter** - Cross-platform mobile framework
- **Dart** - Modern programming language
- **Android Studio** - IDE and development tools

### 📚 Learning Resources
- **Flutter Documentation** - Comprehensive guides and API references
- **Material Design Guidelines** - UI/UX best practices
- **Provider Package** - State management patterns

### 👥 Contributors
- **SujithClasher** - Project creator and maintainer
- **Open Source Community** - Contributors and supporters

### 🎯 Inspiration
- Modern parental control applications
- Material Design case studies
- Flutter showcase projects

---

<div align="center">

**Built with ❤️ using Flutter**

**[⭐ Star this repo](https://github.com/SujithClasher/SentinelGuard)** • **[🐛 Report issues](https://github.com/SujithClasher/SentinelGuard/issues)** • **[💬 Join discussions](https://github.com/SujithClasher/SentinelGuard/discussions)**

</div>
