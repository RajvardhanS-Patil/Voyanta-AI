<div align="center">
  <img src="https://via.placeholder.com/150x150?text=Voyanta+Logo" alt="Voyanta AI Logo" width="150"/>
  <h1>Voyanta AI</h1>
  
  <p><b>AI-Powered Offline-First Travel Planner & Expense Tracker</b></p>
  
  <!-- Animated Typing Banner Placeholder -->
  <a href="https://voyanta.ai">
    <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=20&duration=3000&pause=1000&color=20B2AA&center=true&vCenter=true&width=435&lines=Your+Personal+AI+Travel+Concierge;100%25+Offline-First+Architecture;Real-Time+Journey+Geofencing" alt="Typing SVG" />
  </a>
  <br/>
  
  [![Release](https://img.shields.io/badge/Release-v1.0.0--beta-blue.svg)](https://github.com/RajvardhanS-Patil/Voyanta-AI/releases)
  [![Build Status](https://github.com/RajvardhanS-Patil/Voyanta-AI/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/RajvardhanS-Patil/Voyanta-AI/actions)
  [![Flutter](https://img.shields.io/badge/Flutter-3.19.0-02569B?logo=flutter)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.3.0-0175C2?logo=dart)](https://dart.dev/)
  [![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)](#)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
  [![GitHub stars](https://img.shields.io/github/stars/RajvardhanS-Patil/Voyanta-AI.svg?style=social&label=Star)](https://github.com/RajvardhanS-Patil/Voyanta-AI/stargazers)
  [![GitHub issues](https://img.shields.io/github/issues/RajvardhanS-Patil/Voyanta-AI.svg)](https://github.com/RajvardhanS-Patil/Voyanta-AI/issues)
</div>

<br/>

> **Elevator Pitch**: Planning a trip is exhausting. Travelers rely on five different apps—Maps, Spreadsheets, Notes, TripAdvisor, and AI Chats—to manage a single vacation. Voyanta AI unifies this chaos into one **100% Offline-First** application. It orchestrates Google Gemini to build day-by-day itineraries, tracks your live GPS journey, and logs your expenses in a local database that silently syncs to the cloud the moment you find WiFi.

---

## 🎯 Product Vision
Our mission is to build the ultimate travel companion that works flawlessly in airplane mode. Whether you are navigating the Tokyo subway without a data plan or tracking cash expenses in a remote market, Voyanta AI guarantees 0ms latency and data durability.

---

## 📸 Screenshots & Demos

*(Demo GIF placeholders)*
<div align="center">
  <img src="https://via.placeholder.com/250x500?text=AI+Itinerary+Demo" width="250"/>
  <img src="https://via.placeholder.com/250x500?text=Live+Journey+Demo" width="250"/>
  <img src="https://via.placeholder.com/250x500?text=Offline+Sync+Demo" width="250"/>
</div>

For high-resolution marketing assets, view our [Screenshots Guide](docs/assets/SCREENSHOTS_GUIDE.md).

---

## 🌟 Key Features

| Feature | Description |
|---------|-------------|
| 🧠 **AI Itinerary Orchestration** | Generates day-by-day travel plans customized to your budget, pacing, and weather via Gemini 1.5 Flash. |
| 📴 **Offline-First Resilience** | Optimistic UI writes directly to a local Isar DB. A FIFO queue syncs to Supabase when reconnected. |
| 📍 **Live Journey Engine** | Real-time GPS tracking and geofenced arrival detection via Mapbox vector layers. |
| 💬 **Context-Aware AI Companion** | An AI chat assistant that knows your active itinerary, remaining budget, and local weather. |
| 📊 **Expense Ledger** | Log spending offline and track budget health via animated progress rings. |

---

## 📐 Architecture & Technology Stack

Voyanta AI implements a strict **Clean Architecture** pattern combined with **Feature-First Modular** directory layouts. 

<details>
<summary><b>View Technology Stack</b></summary>
<br>

- **Client**: Flutter (Dart) & Riverpod for State Management.
- **Backend**: Supabase (PostgreSQL, Auth, RLS).
- **Local Cache**: Isar Database (NoSQL).
- **AI Engine**: Google Gemini API.
- **Mapping**: Mapbox SDK.
</details>

<details>
<summary><b>View Folder Structure</b></summary>
<br>

```text
lib/
├── core/                         # Shared infrastructure (router, theme, UX, sync queue)
└── features/                     # Self-contained modules by functional area
    ├── auth/                     
    ├── companion/                
    ├── expenses/                 
    ├── intelligence/             
    ├── journey/                  
    ├── maps/                     
    └── trip_planner/             
```
</details>

For a deep dive into the engineering, view our [Architecture Documentation](docs/architecture/) and [Engineering Case Study](docs/presentations/CASE_STUDY.md).

### Deep Dive Modules
- **AI Architecture**: [Read More](docs/architecture/AIArchitecture.md)
- **Offline Sync Engine**: [Read More](docs/architecture/OfflineStrategy.md)
- **Live Journey Engine**: [Read More](docs/architecture/NavigationFlow.md)
- **State Management**: [Read More](docs/architecture/StateManagement.md)

---

## 🎨 Design System

Voyanta AI utilizes the proprietary **Stitch Design System**, emphasizing:
- **Glassmorphism**: Frosted glass panels for contextual floating overlays.
- **Micro-Animations**: Shimmer loaders and Lottie animations to mask API latency.
- **Palette**: Dark Mode default with vibrant Teal and Coral accents.
See the [Brand Guidelines](docs/assets/branding/BRAND_GUIDELINES.md) for specifics.

---

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/RajvardhanS-Patil/Voyanta-AI.git
cd Voyanta-AI
```

### 2. Environment Setup
You must provide API keys to compile the application. Create `.env.dev` and `.env.prod` files in the root directory:

```bash
MAPBOX_PUBLIC_TOKEN=your_mapbox_public_token
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your_local_anon_key
GEMINI_API_KEY=your_gemini_api_studio_key
```

### 3. Running Development
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -t lib/main_dev.dart
```

### 4. Running Demo Mode
If you are presenting the app to judges or investors, use Demo Mode to inject a rich mock dataset (Paris Itinerary, AI History, Expenses) instantly into the local database:
```bash
flutter run -t lib/main_demo.dart
```

### 5. Building Release (Production)
```bash
flutter build apk --release -t lib/main_prod.dart
```

---

## 🧪 Testing & CI/CD
We enforce strict test coverage via GitHub Actions.
```bash
flutter analyze
flutter test --update-goldens test/golden_test.dart
flutter test integration_test/app_test.dart
```

---

## 🗺 Roadmap & Future Scope
- **Phase 15**: Open Source Documentation Overhaul (Completed).
- **Phase 16**: Multiplayer Trips using CRDTs for collaborative editing.
- **Phase 17**: Receipt OCR scanning for automatic expense entry.
See [Roadmap](docs/architecture/Roadmap.md) for full history.

## ⚠️ Known Limitations
- The Mapbox engine may cause a ~1-second UI stutter on older Android devices during cold boot.
- AI itinerary generation can take up to 5 seconds due to strict JSON parsing enforcement.

---

## 🤝 Contributing
We welcome pull requests! Please read our [Contributing Guide](CONTRIBUTING.md) and [Code of Conduct](#) before submitting. 

If you find a bug, please use the [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md).
For security issues, refer to our [Security Policy](SECURITY.md).

---

## 📜 License & Acknowledgements
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Special thanks to:
- [Google AI Studio](https://aistudio.google.com/)
- [Supabase](https://supabase.com/)
- [Isar Database](https://isar.dev/)
