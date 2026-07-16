# Developer Guide — Voyanta AI

This document serves as a quick-start reference guide for developers running and debugging the Voyanta AI codebase.

---

## 1. Quick Start Checklist

To run the application locally:

### Step 1: Clone Repository
```bash
git clone https://github.com/RajvardhanS-Patil/Voyanta-AI.git
cd Voyanta-AI
```

### Step 2: Set Up Local Supabase Emulator
Make sure Docker is running on your machine.
```bash
# Initialize Supabase configuration locally
supabase init

# Boot up local Postgres database & auth server
supabase start
```
*This command outputs the local database URIs, API keys, and studio URLs.*

### Step 3: Configure Environment
Create a `.env` file or supply variables to build targets:
```bash
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your_local_anon_key
GEMINI_API_KEY=your_gemini_api_studio_key
```

### Step 4: Run Application
```bash
# Get Dart package packages
flutter pub get

# Generate local database models (Isar mappings)
flutter pub run build_runner build --delete-conflicting-outputs

# Boot up application on targeted emulator
flutter run
```

---

## 2. Debugging Tooling & Tips

- **DevTools**: Open Flutter DevTools in your browser. Use the **Widget Inspector** to track rendering trees and analyze sizing bounds.
- **Isar Inspector**: When running on emulators, the app logs a link to the Isar database inspector. Open it to audit local table layouts and synchronization queue updates in real-time.
- **Database Logs**: Monitor local Supabase API requests by running:
  ```bash
  supabase logs --follow
  ```
