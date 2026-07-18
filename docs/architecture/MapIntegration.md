# Map Integration — Voyanta AI

This document establishes the Mapbox integration specifications, marker clustering, route path generation, and offline geographic asset management for Voyanta AI.

---

## 1. Mapbox Initialization & Architecture

Voyanta AI uses the **Mapbox Maps SDK** (native bindings on Android/iOS).
- **Core Layer**: Map coordinates and route data live in the Data/Domain layer as abstract geo-models.
- **Presentation Layer**: Custom `MapWidget` components display vector layers. 
- **Style configuration**: A dark glassmorphic map style custom-styled in Mapbox Studio to match brand visual rules.

---

## 2. Marker Clustering & GeoJSON Layers

When rendering multiple travel events (hotels, restaurants, viewpoints) on the map:
- **Layer Injection**: Coordinates are formatted as a local **GeoJSON FeatureCollection** and fed into a Mapbox source.
- **Clustering Rule**: Enable clustering on the source layer. Mapbox groups markers within a `50px` radius:
  ```dart
  // Source layout example in Mapbox
  await mapboxController.addSource(
    GeoJsonSource(
      id: 'itinerary-source',
      data: geoJsonData,
      options: MapboxSourceOptions(
        cluster: true,
        clusterMaxZoom: 14,
        clusterRadius: 50,
      ),
    ),
  );
  ```
- **Custom Renderers**: Cluster groups display as a glowing Cyber Teal badge indicating the count of items. Single points show custom markers reflecting the event category (e.g., fork-knife icon for food).

---

## 3. Offline Map Tile Downloads

To support fully offline navigation, users can download maps for specific travel regions:

- **Region Selection**: When creating a trip, the user can download a bounding box region extending **10km** around all planned events.
- **Download Limits**: Tile packs are limited to a maximum of **100MB** per trip.
- **Background Downloader**: The download task is run as an asynchronous background worker. Mapbox stores vector tiles in a local database cache.
- **Automatic Fallback**: If the device is offline, Mapbox loads tiles from the local offline database first before attempting remote CDN queries.

---

## 4. Route Paths Generation

- **Route Data**: Coordinates for travel events are passed to the Mapbox Directions API when online, and saved locally.
- **Offline Path Rendering**: If offline, the client renders static paths connecting day events as simple polyline geometries directly on the cached vector layers instead of using directions API query routines.
- **PostGIS Queries**: Spatial queries (e.g., finding the nearest restaurant within 500m of the current hotel coordinates) use PostgreSQL PostGIS `ST_DWithin` functions via edge functions when connected.
