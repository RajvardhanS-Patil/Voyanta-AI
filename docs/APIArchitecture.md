# API Architecture — Voyanta AI

This document establishes the communication protocols, endpoint schemas, pagination limits, and real-time synchronization channels for Voyanta AI.

---

## 1. Remote Data Communication Protocols

Voyanta AI uses a hybrid API approach:
- **Supabase PostGrest REST API**: Low-latency queries to perform CRUD operations on trips, events, and expenses.
- **Supabase Real-Time Subscriptions**: WebSockets to sync data updates immediately across multiple user devices.
- **Google AI Studio REST Endpoints**: Direct API calls to Gemini models for background computations.
- **Open-Meteo REST API**: Public weather fetches.

---

## 2. Supabase REST Endpoints (PostGrest Mappings)

All endpoints require standard `Authorization: Bearer <JWT_TOKEN>` header injections handled by the Supabase client library.

### Trips Mappings
- **Fetch Trips List**: `GET /rest/v1/trips`
  - Query Params: `select=*,expenses(amount)&order=start_date.desc&limit=20`
- **Create Trip**: `POST /rest/v1/trips`
  - Body: `{ "title": "Paris Summer Tour", "start_date": "2026-07-20", "end_date": "2026-07-27", "budget": 1500.00 }`
- **Update Trip**: `PATCH /rest/v1/trips?id=eq.{id}`
- **Delete Trip**: `DELETE /rest/v1/trips?id=eq.{id}`

### Expenses Mappings
- **Fetch Expenses**: `GET /rest/v1/expenses?trip_id=eq.{trip_id}`
- **Add Expense**: `POST /rest/v1/expenses`
  - Body: `{ "trip_id": "uuid", "amount": 42.50, "category": "Food", "date": "2026-07-21", "local_id": "client_uuid" }`

---

## 3. Real-Time Subscription Channels

We listen to database mutations inside selected folders to synchronize local caches instantly when connectivity is online.

```dart
// Client subscription wrapper template
final tripSubscription = supabase
    .channel('public:trips')
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'trips',
      callback: (payload) {
        // Parse payload and update local Isar database
        handleIncomingSyncPayload(payload);
      },
    )
    .subscribe();
```

---

## 4. Rate Limiting & Pagination

- **Pagination Rule**: All large listings (trips list, expenses ledger) default to a pagination size of `20` records. UI lists must request pagination ranges using range headers:
  - Header: `Range: 0-19` (first page), `Range: 20-39` (second page).
- **Client-Side Throttling**: Gemini generation requests are locked to a maximum of 3 concurrent requests to prevent triggering AI Studio free-tier rate limits (15 RPM).
