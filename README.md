# 🎮 CatchTheBall - Godot Android Game

A fun mobile game built with **Godot 4.2** where you catch falling balls to score points. Automatically built for Android using **GitHub Actions**.

![Build Status](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/build-android.yml/badge.svg)

---

## 🎯 Gameplay

- **Drag** your paddle left and right to catch falling balls
- Different colored balls give different points:
  - 🔴 Red Ball = 1 point (common)
  - 🔵 Blue Ball = 2 points (uncommon)
  - 🟡 Gold Ball = 3 points (rare)
  - 🟣 Purple Ball = 5 points (very rare!)
- Miss 3 balls and it's **Game Over**
- Every 10 points = **Level Up** → balls fall faster!

---

## 📁 Project Structure

```
godot-android-game/
├── .github/
│   └── workflows/
│       └── build-android.yml   # GitHub Actions CI/CD
├── project/
│   ├── scenes/
│   │   ├── Main.tscn           # Main game scene
│   │   └── Ball.tscn           # Ball scene
│   ├── scripts/
│   │   ├── Main.gd             # Game controller
│   │   ├── Player.gd           # Player paddle + touch controls
│   │   ├── Ball.gd             # Ball behavior
│   │   └── UIManager.gd        # UI management
│   ├── assets/                 # Sprites, sounds, fonts
│   ├── project.godot           # Godot project config
│   └── export_presets.cfg      # Android export config
├── .gitignore
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- [Godot 4.2.2](https://godotengine.org/download/) (stable)
- Android Studio or Android SDK (for local builds)
- Java 17

### Run Locally
1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
   cd YOUR_REPO
   ```

2. Open Godot Editor → **Import Project** → select `project/project.godot`

3. Press **F5** to run in the editor (desktop mode)

### Build Android APK Locally
1. In Godot Editor, go to **Project → Export**
2. Select the **Android** preset
3. Set your Android SDK path
4. Click **Export Project**

---

## ⚙️ GitHub Actions CI/CD

The workflow automatically builds an Android APK on every push.

### Workflow Triggers
| Event | Action |
|-------|--------|
| Push to `main`/`master` | Build debug APK |
| Pull Request | Build & verify APK |
| Push tag `v*` | Build + create GitHub Release |
| Manual trigger | `workflow_dispatch` |

### How to Use

**Download a build:**
1. Go to **Actions** tab in your GitHub repo
2. Click the latest workflow run
3. Download the `CatchTheBall-Android-APK` artifact

**Create a release:**
```bash
git tag v1.0.0
git push origin v1.0.0
```
This will automatically create a GitHub Release with the APK attached.

---

## 🔐 Release Signing (Optional)

For production builds, set up a release keystore:

1. Generate a release keystore:
   ```bash
   keytool -genkey -v -keystore release.keystore \
     -alias mykey -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Add secrets to your GitHub repository (**Settings → Secrets**):
   ```
   RELEASE_KEYSTORE_BASE64    # base64-encoded keystore file
   RELEASE_KEYSTORE_ALIAS     # key alias
   RELEASE_KEYSTORE_PASS      # store password
   RELEASE_KEY_PASS           # key password
   ```

3. Update the workflow to use release signing.

---

## 🎨 Customization

### Change Ball Speed
In `project/scripts/Main.gd`:
```gdscript
const INITIAL_SPAWN_INTERVAL = 1.5  # Lower = faster spawning
```

### Add New Ball Types
In `project/scripts/Ball.gd`, add to `BALL_TYPES` array:
```gdscript
{"color": Color(0, 1, 0), "points": 10, "size": 8},  # Green - ultra rare
```

### Modify Level Progression
In `project/scripts/Main.gd`:
```gdscript
const LEVEL_UP_SCORE = 10  # Points needed to level up
const MIN_SPAWN_INTERVAL = 0.4  # Fastest spawn rate
```

---

## 📱 Android Requirements

- **Minimum SDK:** Android 7.0 (API 24)
- **Target SDK:** Android 14 (API 34)
- **Architecture:** arm64-v8a, armeabi-v7a

---

## 🛠️ Tech Stack

- **Game Engine:** Godot 4.2.2
- **Language:** GDScript
- **CI/CD:** GitHub Actions
- **Build:** Gradle + Android SDK

---

## 📄 License

MIT License — feel free to use this as a template for your own Godot Android games!
# Gamee
