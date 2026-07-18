# Closed Beta Test Plan - Voyanta AI

## Scope of Testing
The beta test focuses on core journey tracking, AI itinerary generation accuracy, and the offline-first sync mechanism.

## Test Tracks

### Track 1: The Offline Explorer
**Objective**: Test the Isar Database local persistence and FIFO sync queue.
**Instructions**:
1. Turn on Airplane Mode.
2. Open the Voyanta AI app.
3. Navigate to the Expenses tab and add 3 new expenses (e.g., "Coffee", "Taxi", "Dinner").
4. Verify the expenses show up in the UI immediately.
5. Turn Airplane Mode off.
6. Verify the Sync Status Banner disappears and the `ObservabilityService` logs `offline_sync_completed`.

### Track 2: The Spontaneous Traveler
**Objective**: Test the AI Companion's context awareness.
**Instructions**:
1. Generate a new Trip to "Tokyo, Japan".
2. Open the AI Travel Companion.
3. Ask: "What should I eat near my second activity today?"
4. Verify the AI correctly references the itinerary node and suggests valid restaurants nearby.

### Track 3: The Navigator
**Objective**: Test Mapbox clustering and Live Journey geofencing.
**Instructions**:
1. Start a Live Journey.
2. Grant Location Permissions.
3. Verify the map centers on your current location and paints a route line to the first activity.
4. Physically (or via emulator mocked location) arrive at the first activity coordinates.
5. Verify the app automatically marks the activity as "Completed" and recommends the next stop.
