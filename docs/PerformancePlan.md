# Performance Optimization Plan — Voyanta AI

This document establishes performance optimization rules, lazy list rendering strategies, build optimizations, and payload batching constraints for Voyanta AI.

---

## 1. UI Rendering Optimizations

To maintain a smooth **120 FPS** interface feel on modern high-refresh screens:
- **Minimize Widget Re-renders**: Use selective Riverpod family listeners (`ref.watch(provider.select(...))`) to ensure widgets only redraw when properties they explicitly display change.
- **Const Constructors**: Maximize the usage of `const` constructors on all layout widgets. This allows the compiler to cache static nodes in the render tree rather than rebuilding them on parent updates.
- **Virtual List Layouts**: Large displays (e.g., historical trips log, long lists of receipts) must use lazy constructors (`ListView.builder` in Flutter, Virtualized lists in Web). Render trees only initialize elements currently visible on the screen.

---

## 2. Media Optimization & Bandwidth Management

- **Image Compression**: User receipt photos, profile uploads, or destination snapshots must be compressed on the client device before upload (maximum **1080p** resolution, JPEG quality **80%**).
- **Cached Network Images**: Network images must be cached locally using a wrapper (`CachedNetworkImage` in Flutter) to avoid redownloading static content during transitions or offline periods.
- **Vector Maps Caching**: Mapbox styling uses vector rendering layers rather than raster graphic image tiles, significantly reducing bandwidth overheads.

---

## 3. Database & Network Payload Optimizations

- **JSON Data Compaction**: Minimize fields returned by Supabase SELECT calls. Avoid querying unused columns (e.g., fetch only `id`, `amount`, and `title` for expense listings instead of fetching large text descriptions).
- **Index Maintenance**: Maintain correct B-Tree indexes on keys used in sort operations (`start_date`, `created_at`) to ensure database lookups complete in under **10ms**.
- **Batch Writes**: Local sync queues combine multiple insert actions (e.g., adding 5 expenses sequentially) into a single batch transaction API call to avoid API network overheads.
