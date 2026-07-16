# Design Guidelines — Voyanta AI

This document establishes the UI design tokens, typography, visual behaviors, and responsive layout constraints for Voyanta AI. The goal is to provide a premium, modern user interface.

---

## 1. Typography & Hierarchy

We use Google Fonts **Outfit** for display headings and titles (modern, clean, round geometric features) and **Inter** for body copy and interface buttons (highly readable, clean rendering on high-density mobile screens).

| Style Token | Font Family | Size | Weight | Line Height | Usage |
|---|---|---|---|---|---|
| **Display Large** | Outfit | 32sp | 700 (Bold) | 1.2 | Main hero text, splash titles |
| **Title Medium** | Outfit | 20sp | 600 (Semi-Bold) | 1.3 | Card headers, section dividers |
| **Body Medium** | Inter | 14sp | 400 (Regular) | 1.5 | Description labels, lists |
| **Button Text** | Inter | 14sp | 600 (Semi-Bold) | 1.2 | Active button components |
| **Caption** | Inter | 12sp | 500 (Medium) | 1.4 | Timestamps, currency helper details |

---

## 2. Color Palette System (HSL Values)

Avoid using raw browser colors (plain `#FF0000`, etc.). We use a dynamic dark-mode curated theme with vibrant neon and glassmorphic base layers:

- **Primary Brand (Deep Lavender)**: `hsl(262, 80%, 65%)`
- **Secondary Accent (Cyber Teal)**: `hsl(172, 80%, 45%)`
- **Dark Background (Slate Obsidian)**: `hsl(222, 47%, 11%)`
- **Card Background (Glassmorphic Tint)**: `hsla(222, 47%, 18%, 0.5)`
- **Success Accent (Emerald Green)**: `hsl(142, 70%, 45%)`
- **Warning Accent (Coral Red)**: `hsl(0, 75%, 60%)`

---

## 3. Glassmorphism Tokens

To achieve the premium look, cards and overlays use a glass frosted-glass styling:

```css
/* Web CSS Equivalent representation */
.glass-panel {
  background: rgba(30, 41, 59, 0.45);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
  box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
}
```

In Flutter, this is constructed using:
- `BackdropFilter` with `ImageFilter.blur(sigmaX: 16, sigmaY: 16)`
- `BoxDecoration` with a semi-transparent border color mapping (`Border.all(color: Colors.white.withOpacity(0.08))`)

---

## 4. Animation Guidelines

- **Micro-interactions**: Any interactive button must scale slightly down (`0.95x`) on click, reverting to `1.0x` on release. This tactile scale animation makes the UI feel responsive.
- **Card transitions**: Use a subtle **Hero Transition** or custom **Fade-Slide** interpolation (300ms, using `Curves.easeOutCubic`) when navigating from Trip Card to Itinerary Dashboard to create continuous spatial context.
- **Loading indicators**: Avoid using standard circular grey bars. Use an elegant shimmering gradient animation (Shimmer effect) mapped across mockup panels.
