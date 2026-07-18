# App Store Screenshots Generation Guide

This guide outlines exactly how to generate production-quality, reproducible screenshots for the App Store, Play Store, and README markdown files.

## Environment Preparation
1. **Device Profile**: Use an iOS Simulator (iPhone 15 Pro) and an Android Emulator (Pixel 8 Pro).
2. **System Theme**: Dark Mode enabled.
3. **App State**: Launch the application using the **Demo Mode Configuration** to ensure consistent seed data.
   ```bash
   flutter run -t lib/main_demo.dart
   ```
4. **Time & Status Bar**: Use a tool like `Simulator Status Magic` or Android's System UI Tuner to lock the time to `9:41 AM`, with full WiFi and Battery icons.

## Required Screenshots

### 1. The Dashboard (Home)
- **Path**: `/`
- **Action**: Launch the app in Demo Mode. Wait for the Paris 3-Day itinerary to load.
- **Filename**: `docs/assets/screenshots/01_dashboard.png`
- **Caption**: "AI-Generated Itineraries tailored to you."

### 2. Live Journey Engine (Maps)
- **Path**: `/journey`
- **Action**: Tap "Start Journey". Ensure the map cluster markers are visible.
- **Filename**: `docs/assets/screenshots/02_live_journey.png`
- **Caption**: "Real-time navigation and geofenced activity tracking."

### 3. AI Travel Companion
- **Path**: `/companion`
- **Action**: Ask "What should I eat for dinner near the Eiffel Tower?". Wait for the response.
- **Filename**: `docs/assets/screenshots/03_ai_companion.png`
- **Caption**: "Context-aware AI Travel Companion."

### 4. Expense Ledger
- **Path**: `/expenses`
- **Action**: Scroll halfway down the list so both the Budget Progress Ring and the list of expenses are visible.
- **Filename**: `docs/assets/screenshots/04_expenses.png`
- **Caption**: "Track your budget in real-time."

### 5. Offline Sync Banner
- **Path**: `/expenses`
- **Action**: Turn off the device's WiFi/Cellular. Wait for the Orange "Offline - Changes saved locally" banner to appear.
- **Filename**: `docs/assets/screenshots/05_offline_sync.png`
- **Caption**: "100% Offline Capable. Syncs when connected."

## Asset Export
Save all screenshots in `docs/assets/screenshots` using standard PNG format without alpha channels (unless wrapped in device mockups).
