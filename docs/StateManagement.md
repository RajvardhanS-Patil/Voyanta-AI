# State Management Guide — Voyanta AI

This document establishes the state management standard for Voyanta AI. The project utilizes a **Unidirectional Data Flow** architecture.

---

## 1. Primary Tooling Selection

For Flutter Mobile, the primary state manager is **Riverpod** due to its compile-time safety, separation of state from widget trees, and robust caching rules. For Web interfaces, the equivalent standard is **Zustand**.

---

## 2. Unidirectional Data Flow

State transitions follow a strict one-way loop to ensure predictable application behaviors and easy debugging tracking:

```
[UI Widgets] ──(Dispatches Action)──> [State Notifier / Controller]
     ▲                                            │
     │ (Re-renders on Change)                     │ (Triggers Business Use Case)
     │                                            v
[Immutable State Model] <─────────────── [Domain Use Case / Repositories]
```

### Flow Rules
1. **Widgets are Passive**: Screens must never modify repositories or call APIs directly. They dispatch actions to Controllers.
2. **State is Immutable**: State classes must be `final` and copyable using `copyWith()`. Mutation of raw variables inside notifier classes is forbidden.
3. **Data Flows Down**: The UI listens to reactive streams. When state changes, widgets re-render selectively.

---

## 3. Loading State Architecture

To prevent layout jumping and blank pages, controllers must model state with clear sub-statuses:

```dart
// Standard State wrapper template
@immutable
class TripState {
  final List<Trip> trips;
  final bool isLoading;
  final String? errorMessage;

  const TripState({
    required this.trips,
    required this.isLoading,
    this.errorMessage,
  });

  TripState copyWith({
    List<Trip>? trips,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TripState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
```

- **Shimmer Fallbacks**: While `isLoading` is true, the presentation layer displays layout skeletons instead of loading text block labels.
- **Failures**: Errors are stored inside the state as UI-safe message labels and cleared on reload actions.

---

## 4. State Lifecycle and Scoping

- **Auto-Dispose**: Controllers that fetch specific item data (e.g., `ItineraryDetailsController` for a specific trip ID) must be defined with auto-dispose rules. When the user exits the screen, the state, caches, and stream subscriptions are immediately garbage-collected.
- **Keep-Alive**: Core user configurations (e.g., Auth state, Offline Sync Queue indicators, global Theme parameters) must remain persistent in memory throughout the application session lifetime.
