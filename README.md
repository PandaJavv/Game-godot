# 🚀 Cosmic Jumper — Godot Android Game

An endless vertical platformer game for Android, built with **Godot 4.2** and auto-deployed via **GitHub Actions**.

---

## 🎮 Game Overview

**Cosmic Jumper** is a Doodle Jump–style endless jumper where:
- Your character auto-jumps on every platform
- Tilt your device (accelerometer) to move left/right
- Platforms include **Normal**, **Moving**, and **Breakable** types
- Score increases the higher you climb
- Game speeds up as your score increases

---

## 📁 Project Structure

```
godot-android-game/
├── .github/
│   └── workflows/
│       └── build-android.yml   # CI/CD pipeline
├── scenes/
│   ├── Main.tscn               # Main game scene
│   ├── Player.tscn             # Player character
│   └── Platform.tscn           # Platform object
├── scripts/
│   ├── Main.gd                 # Game controller logic
│   ├── Player.gd               # Player physics & input
│   └── Platform.gd             # Platform behavior
├── assets/
│   ├── sprites/                # Game graphics
│   └── sounds/                 # Audio files
├── android/build/              # Godot Gradle build files
├── export/                     # APK output (git-ignored)
├── export_presets.cfg          # Android export configuration
└── project.godot               # Godot project settings
```

---

## 🛠️ Local Development Setup

### Prerequisites

| Tool | Version |
|------|---------|
| [Godot Engine](https://godotengine.org/download) | 4.2.2 stable |
| [Android Studio](https://developer.android.com/studio) | Latest |
| Java JDK | 17+ |

### Steps

1. **Clone the repo**
   ```bash
   git clone https://github.com/YOUR_USERNAME/cosmic-jumper.git
   cd cosmic-jumper
   ```

2. **Open in Godot**
   - Launch Godot 4.2
   - Click **Import** → select `project.godot`

3. **Configure Android SDK in Godot**
   - Go to **Editor → Editor Settings**
   - Navigate to **Export → Android**
   - Set **Android SDK Path** to your Android SDK directory
     - macOS: `~/Library/Android/sdk`
     - Linux: `~/Android/Sdk`
     - Windows: `C:\Users\<user>\AppData\Local\Android\Sdk`

4. **Install Android Export Templates**
   - Go to **Editor → Manage Export Templates**
   - Download templates for Godot 4.2.2

5. **Run on device or emulator**
   - Connect Android device (USB debugging enabled) or start emulator
   - Click the **Remote Debug** button in the top bar

---

## 🤖 GitHub Actions CI/CD

### How It Works

The workflow (`.github/workflows/build-android.yml`) triggers on:
- ✅ Push to `main` or `develop`
- ✅ Pull requests to `main`
- ✅ Tag pushes (`v1.0.0`, `v2.0.0`, etc.)
- ✅ Manual trigger via **Actions → Run workflow**

### Build Matrix

| Event | APK Type | Uploaded To |
|-------|----------|-------------|
| Pull Request | Debug | Actions Artifacts |
| Push to `main` (no keystore) | Debug | Actions Artifacts |
| Push to `main` (with keystore) | Release (signed) | Actions Artifacts |
| Tag `v*` (with keystore) | Release (signed) | GitHub Releases |

---

## 🔐 Setting Up Signing (Optional but Recommended)

### 1. Generate a Keystore

```bash
keytool -genkey -v \
  -keystore cosmic-jumper.jks \
  -alias cosmic-jumper \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

### 2. Convert to Base64

```bash
# Linux/macOS
base64 -w 0 cosmic-jumper.jks

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("cosmic-jumper.jks"))
```

### 3. Add GitHub Secrets

Go to **Settings → Secrets and variables → Actions** and add:

| Secret | Value |
|--------|-------|
| `KEYSTORE_BASE64` | Base64-encoded content of your `.jks` file |
| `KEYSTORE_USER` | Alias used when creating the keystore |
| `KEYSTORE_PASSWORD` | Password for the keystore |

> ⚠️ **Never commit your `.jks` file to the repository!**

---

## 🚀 Releasing a New Version

1. Update version in `project.godot`:
   ```ini
   config/version="1.1.0"
   ```

2. Commit and push:
   ```bash
   git add .
   git commit -m "chore: bump version to 1.1.0"
   git tag v1.1.0
   git push origin main --tags
   ```

3. GitHub Actions will:
   - Build a signed release APK
   - Create a GitHub Release automatically
   - Attach the APK to the release

---

## 🎯 Controls

| Platform | Control |
|---------|---------|
| Android (device) | Tilt phone left/right |
| Android (emulator) | Swipe left/right on screen |
| Desktop (testing) | Arrow keys ← → |

---

## 📄 License

MIT License — feel free to use this as a template for your own Godot Android game!
