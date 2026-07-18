# Voyanta AI — Brand Guidelines

This document establishes the official brand identity, design principles, and UI conventions for Voyanta AI.

## 1. Mission & Vision

**Mission Statement**
> "To orchestrate seamless travel experiences by unifying itinerary planning, real-time navigation, and local intelligence into a single, offline-first application."

**Vision Statement**
> "Voyanta AI envisions a world where travelers can disconnect from cellular networks without disconnecting from their travel plans, empowering exploration without anxiety."

## 2. Voice & Tone
- **Professional but Warm**: The AI companion should speak like a highly competent hotel concierge.
- **Concise**: Travel information should be direct and scannable. Avoid large blocks of text in the UI.
- **Reassuring**: When offline, the app should explicitly reassure the user that their data is safe and saved locally.

## 3. UI Principles
Voyanta AI implements a custom design language called **Stitch**.

- **Glassmorphism**: Floating overlays (like the Expense Form) should use frosted glass effects (`BackdropFilter` with `sigmaX: 10, sigmaY: 10`) to provide context without completely obscuring the background map.
- **Card-Based Architecture**: Day itineraries are broken into distinct cards with high corner radius (`borderRadius: BorderRadius.circular(24)`).
- **Zero Empty States**: An empty screen is a failure. If a user has no trips, show a beautiful `EmptyStateView` with a clear Call-To-Action (CTA) to generate one.

## 4. Typography
We utilize the **Google Fonts** library to ensure cross-platform consistency.

- **Primary Font**: `Outfit`
  - Used for all Headers (H1-H4), AI Companion names, and high-impact numerical values (Budget totals).
- **Secondary Font**: `Inter`
  - Used for body text, expense lists, and dense informational paragraphs.

## 5. Color Palette

Our palette reflects the ocean and the sunset, inspiring travel.

- **Primary Accent**: `Teal Accent` (`#18FFFF`)
  - Used for the primary Call to Action (CTA) buttons, progress rings, and active Mapbox route lines.
- **Secondary Accent**: `Coral/Sunset Orange` (`#FF6E40`)
  - Used to indicate offline status (Offline Banner) and warnings.
- **Background (Dark Mode)**: `Deep Slate` (`#121212` to `#1E1E1E`)
  - The app is fundamentally designed for Dark Mode to reduce eye strain when traveling at night.

## 6. Logo Usage
*(Logo assets will be stored in `docs/assets/branding/logo/`)*
- Always maintain clear space around the logo equivalent to 50% of the logo's height.
- Never stretch, skew, or recolor the logo outside the official palette.
