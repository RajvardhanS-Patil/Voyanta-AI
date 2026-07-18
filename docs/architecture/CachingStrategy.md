# Caching Strategy — Voyanta AI

This document establishes local caching rules, schema migrations, and cache policies for remote data.

---

## 1. Stale-While-Revalidate (SWR) Pattern

For non-critical data feeds (e.g., weather updates, user profiles, past travel templates), Voyanta AI applies the **Stale-While-Revalidate** query paradigm:

```
                  [Query Request]
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
 [Read Cache (Stale)]            [Fetch Network]
         │                               │
    (Immediate UI)                       v
         │                      (Update Local Cache)
         │                               │
         v                               v
[Display Stale Content]   [Emit Re-validated Fresh UI]
```

1. **Immediate Read**: The repository returns cached data from the local Isar database instantly, updating the UI.
2. **Background Refetch**: Simultaneously, an asynchronous API call is fired to fetch fresh data.
3. **Cache Update**: When the network response returns, the repository updates the local cache. If the data has changed, the state controller notifies the presentation layer to render the fresh content.

---

## 2. Dynamic Fetching Policies

Different features apply distinct cache rules:

| Category | Policy | Description |
|---|---|---|
| **Expenses** | **Cache-First** | Writes must go to the local DB first. Reads query local DB directly. Remote network fetches update local tables but never block UI rendering actions. |
| **Active Trip Itinerary** | **Stale-While-Revalidate** | Renders existing local days plans instantly. Fetches background updates from Supabase to incorporate remote modifications. |
| **Weather Forecasts** | **Network-First with Cache Fallback** | Attempts to query the live Open-Meteo API. If offline or network timeouts occur, fallback to the last cached weather snapshot. Cache validity limit is **3 hours**. |

---

## 3. Database Schema Versioning & Migrations

When updates modify the local database schema (e.g., adding an event category column to the itineraries database):
- **Version Tracking**: Isar or SQLite schema versions are declared globally.
- **Migration Strategy**: Migrations are run during the database boot cycle:
  - **Non-destructive additions**: Columns are added with default null/initial values.
  - **Destructive changes**: If database schemas undergo massive updates, migrations migrate data via temporary tables, preventing local data loss for offline users.
  - **Supabase sync check**: If local caches are corrupted, the client drops tables and triggers a full sync download from Supabase.
