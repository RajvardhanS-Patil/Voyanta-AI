---
layout: default
title: Voyanta AI Documentation
---

# Voyanta AI Documentation Hub

Welcome to the official documentation for **Voyanta AI**, an offline-first travel planner and real-time journey tracker built with Flutter, Riverpod, Isar, and Google Gemini.

## 🚀 Getting Started
If you are a developer looking to contribute or compile the application locally, start here:
- [Developer Guide](guides/DeveloperGuide.md)
- [Architecture Overview](architecture/SystemDesign.md)
- [Contributing Guidelines](../CONTRIBUTING.md)

## 📐 Core Engineering Architectures
Voyanta AI solves several complex mobile engineering challenges. Read our deep-dives:
- **[Offline Sync Engine](architecture/OfflineStrategy.md)**: How we use Optimistic UI and a local FIFO queue to ensure 0ms latency and data durability without network connectivity.
- **[AI Companion Engine](architecture/AIArchitecture.md)**: How we enforce strict JSON schemas on Google Gemini 1.5 Flash.
- **[Live Journey Tracking](architecture/NavigationFlow.md)**: Real-time mapbox vector maps and geofenced activity completion.

## 🎨 Design & Assets
- [Brand Guidelines](assets/branding/BRAND_GUIDELINES.md)
- [Screenshots Guide](assets/SCREENSHOTS_GUIDE.md)

## 🎤 Presentations & Case Studies
- [Engineering Case Study](presentations/CASE_STUDY.md)
- [Pitch Deck Outlines](presentations/PITCH_DECK.md)
- [Live Demo Scripts](demo/DEMO_SCRIPT.md)

---
*Voyanta AI is open-source under the MIT License.*
