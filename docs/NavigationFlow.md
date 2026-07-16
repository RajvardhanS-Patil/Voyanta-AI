# Navigation Flow — Voyanta AI

This document defines the application route mappings, screen structures, deep linking patterns, and navigation transitions for Voyanta AI.

---

## 1. Route Navigation Map

Voyanta AI utilizes a **Stateful Shell Route** structure. This preserves the navigation history and widget states of tabs (e.g., maintaining scroll positions in the Trips list while switching to the Expenses tab).

```
                             [App Start / Guard]
                                      │
                         (Authenticated / Decrypted?)
                         /                        \
                       [No]                      [Yes]
                       /                            \
              [Onboarding Screen]            [Stateful Shell Navigation]
             /                 \             /           |            \
      [Email Sign In]   [OAuth Portal]      /            |             \
                                           v             v              v
                                    [Trips Tab]    [Expenses Tab]  [Settings Tab]
                                         │               │
                                    (Trip Tap)       (Add Exp)
                                         v               v
                                  [Trip Details]   [Expense Form]
                                     /       \      (Modal Sheet)
                                    v         v
                              [Itinerary]   [Maps View]
```

---

## 2. Stateful Shell Tabs

The core shell contains three primary branches accessible via the persistent bottom navigation layout:

1. **Trips Branch (`/trips`)**:
   - `/trips` (Dashboard showing active, upcoming, and past travel itineraries).
   - `/trips/:id` (Sub-route displaying active day-by-day travel map pins, routes, and plans).
   - `/trips/:id/edit` (Sub-route for AI editing chat prompts).
2. **Expenses Branch (`/expenses`)**:
   - `/expenses` (Global budget summaries, split shares tracking, and history logs).
   - `/expenses/add` (Modal sheet displaying quick calculator inputs).
3. **Settings Branch (`/settings`)**:
   - `/settings` (Unit metrics configuration, theme selector, offline download manager, logout).

---

## 3. Modal Overlays & Deep Linking

- **Modal Sheets**: Create form pages (e.g., Log Expense, New Manual Event) as bottom sheet panels (`showModalBottomSheet` in Flutter, dynamic bottom drawers in React). They occupy a maximum of `85%` screen height, leaving context visual anchors behind.
- **Deep Linking Protocol**: Configure native platforms to capture links matching the pattern `voyanta://trips/:id` or `https://voyanta.ai/trips/:id`. When clicked, the router parses the token, bypasses shell states, validates active session states, and displays the specific itinerary view directly.
- **Transition Animation**: Standard navigation updates use a slide-in page animation. Switching tabs in the shell uses cross-fade animations (150ms duration) to avoid visual jarring.
