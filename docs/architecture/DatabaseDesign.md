# Database Design — Voyanta AI

This document defines the schema, table constraints, relationships, indexing strategies, and offline synchronization schemas for Voyanta AI.

---

## 1. Remote Database Schema (Supabase / PostgreSQL)

Supabase PostgreSQL acts as the global storage of truth. We use Row Level Security (RLS) to restrict users to their own data.

```
 +------------------+         +------------------+         +------------------+
 |      users       |         |      trips       |         |   itineraries    |
 +------------------+         +------------------+         +------------------+
 | id (PK, auth.uuid) |<------| user_id (FK)     |         | id (PK, uuid)    |
 | email (varchar)  |         | id (PK, uuid)    |        | trip_id (FK)     |
 | created_at       |         | title (varchar)  |<--------| updated_at       |
 +------------------+         | start_date (date)|         +------------------+
                              | end_date (date)  |                   |
                              | budget (numeric) |                   v
                              +------------------+         +------------------+
                                       |                   |   itinerary_days |
                                       |                   +------------------+
                                       |                   | id (PK, uuid)    |
                                       |                   | itinerary_id (FK)|
                                       | (FK)              | day_number (int) |
                                       v                   +------------------+
                              +------------------+                   |
                              |     expenses     |                   v
                              +------------------+         +------------------+
                              | id (PK, uuid)    |         | itinerary_events |
                              | trip_id (FK)     |         +------------------+
                              | amount (numeric) |         | id (PK, uuid)    |
                              | category (varchar|         | day_id (FK)      |
                              | date (date)      |         | title (varchar)  |
                              | local_id (varchar|         | geo_lat (double) |
                              +------------------+         | geo_lon (double) |
                                                           | geo_point(PostGIS|
                                                           +------------------+
```

### Table: `trips`
- `id`: `UUID` (Primary Key, Default: `uuid_generate_v4()`)
- `user_id`: `UUID` (Foreign Key referencing `auth.users.id` on delete cascade)
- `title`: `VARCHAR(100)` (Not Null)
- `start_date`: `DATE` (Not Null)
- `end_date`: `DATE` (Not Null)
- `budget`: `NUMERIC(10, 2)` (Default: `0.00`)
- `created_at`: `TIMESTAMPTZ` (Default: `NOW()`)
- `updated_at`: `TIMESTAMPTZ` (Default: `NOW()`)

### Table: `expenses`
- `id`: `UUID` (Primary Key)
- `trip_id`: `UUID` (Foreign Key referencing `trips.id` on delete cascade)
- `amount`: `NUMERIC(10, 2)` (Not Null)
- `currency`: `VARCHAR(3)` (Default: `USD`)
- `category`: `VARCHAR(50)` (Not Null) -- e.g., food, lodging, transport
- `description`: `TEXT`
- `date`: `DATE` (Not Null)
- `local_id`: `VARCHAR(100)` (Unique, to map client-created records during offline periods)
- `created_at`: `TIMESTAMPTZ` (Default: `NOW()`)

### Table: `itinerary_events`
- `id`: `UUID` (Primary Key)
- `day_id`: `UUID` (Foreign Key referencing `itinerary_days.id` on delete cascade)
- `title`: `VARCHAR(200)` (Not Null)
- `description`: `TEXT`
- `start_time`: `TIME`
- `end_time`: `TIME`
- `geo_lat`: `DOUBLE PRECISION`
- `geo_lon`: `DOUBLE PRECISION`
- `geo_point`: `GEOMETRY(Point, 4326)` -- PostGIS coordinate type for geospatial queries

---

## 2. Local Database Schema (Isar NoSQL)

Local client storage uses **Isar** collections matching the domain entities structure. We map unique UUID values to integer primary keys required by Isar:

```dart
@collection
class LocalTrip {
  Id? isarId; // Auto-increment integer index
  
  @Index(unique: true, replace: true)
  String id; // UUID string representation mapped to remote database
  
  String title;
  DateTime startDate;
  DateTime endDate;
  double budget;
  bool isDirty; // Flag indicating if changes require remote synchronization
  
  final expenses = IsarLinks<LocalExpense>();
}
```

---

## 3. Indexing & Optimization Strategy

- **Foreign Key Indexes**: Ensure all foreign key columns (`trip_id`, `user_id`, `day_id`) have explicit B-Tree indexes created in PostgreSQL to speed up JOIN operations.
- **Geospatial Indexes**: Create a **GIST** index on `itinerary_events.geo_point` to optimize map coordinate clustering queries:
  ```sql
  CREATE INDEX idx_events_geo ON itinerary_events USING GIST(geo_point);
  ```
- **Sync Optimization**: Create a composite index in PostgreSQL on `(user_id, updated_at)` to enable incremental synchronization queries (fetching only records updated since last client sync date).
